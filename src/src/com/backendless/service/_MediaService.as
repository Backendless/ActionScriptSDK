/*                                                                                                                                                                           
* ********************************************************************************************************************                                                      
*                                                                                                                                                                           
*  BACKENDLESS.COM CONFIDENTIAL                                                                                                                                             
*                                                                                                                                                                           
* ********************************************************************************************************************                                                      
*                                                                                                                                                                           
*   Copyright 2012 BACKENDLESS.COM. All Rights Reserved.                                                                                                                    
*                                                                                                                                                                           
*  NOTICE:  All information contained herein is, and remains the property of Backendless.com and its suppliers,                                                             
*  if any.  The intellectual and technical concepts contained herein are proprietary to Backendless.com and its                                                             
*  suppliers and may be covered by U.S. and Foreign Patents, patents in process, and are protected by trade secret                                                          
*  or copyright law. Dissemination of this information or reproduction of this material is strictly forbidden                                                               
*  unless prior written permission is obtained from Backendless.com.                                                                                                        
*                                                                                                                                                                           
* *******************************************************************************************************************                                                       
*/
package com.backendless.service
{
	import com.backendless.Backendless;
	import com.backendless.BackendlessUser;
	import com.backendless.errors.MediaError;
	import com.backendless.media.MediaControl;
	import com.backendless.media.RecordingControl;
	import com.backendless.media.StreamSettings;
	
	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	
	//import flash.net.dns.AAAARecord;
	public class _MediaService extends BackendlessService
	{
        //public static var BACKENDLESS_MEDIA_STREAMING_URL:String = "rtmp://10.0.1.9/mediaApp/";

        public static const BACKENDLESS_MEDIA_STREAMING_URL:String = "rtmp://wowza.backendless.com/mediaApp/";


		private static const SERVICE_SOURCE:String = "com.backendless.services.media.MediaService";
		private static const SERVICE_URL_PART:String = "files";
		private static const PATH_SEPARATOR:String = "/";
		private var _uploading:Boolean = false;

        public function playRecord(tube: String, streamName: String, responder:IResponder):void
        {
            playStream(tube, streamName, responder, false);
        }

        public function playLive(tube: String, streamName: String, responder:IResponder):void
        {
            playStream(tube, streamName, responder, true);
        }

		private function playStream( tube:String, filename:String, responder:IResponder, typeIsLive: Boolean ):void
		{
            var streamType: String = null;
            var operation: String = "playRecord";
            if(typeIsLive)
            {
                streamType = "live";
                operation = "playLive";
            }
            processStream(responder, tube, operation, function(netStream:NetStream):void
            {
                try{
                    var mediaControl:MediaControl = new MediaControl(netStream, tube, filename);

                    responder.result(mediaControl);
                }
                catch(er:Error)
                {
                    responder.fault(new MediaError("Failed to start video playback"));
                }
            }, streamType
            );
        }

        public function record(tube: String, streamName: String, responder:IResponder, settings:StreamSettings = null):void
        {
            recordStream(tube, streamName, responder, 0, settings);
        }

        public function publishLive(tube: String, streamName: String, responder:IResponder, settings:StreamSettings = null):void
        {
            recordStream(tube, streamName, responder, 1, settings);
        }

        public function publishLiveAndRecord(tube: String, streamName: String, responder:IResponder, settings:StreamSettings = null):void
        {
            recordStream(tube, streamName, responder, 2, settings);
        }

        private function recordStream(tube: String, streamName: String, responder:IResponder,  typeIsLive: int, settings:StreamSettings = null):void
        {
            if(settings == null)
                settings = new StreamSettings();

            var operation:String;
            var streamType:String;

            if(typeIsLive == 0)
            {
                operation = "publishRecorded";
//                streamType = "record";
            }
            else if(typeIsLive == 1)
            {
                operation = "publishLive";
                streamType = "live";
            }
            else if(typeIsLive == 2)
            {
                operation = "publishLive";
                streamType = "live-record";
            }

            processStream(responder, tube, operation, function(netStream:NetStream):void
                    {
                        try{
                            netStream.attachCamera(settings.camera);
                            netStream.attachAudio(settings.microphone);

                            var recordingControl:RecordingControl = new RecordingControl(netStream, tube, settings, streamName, streamType);
                            responder.result(recordingControl);
                        }
                        catch (error: Error)
                        {
                            responder.fault(new MediaError("Failed to start video recording"));
                        }
                    }, streamType
            );
        }

        private function processStream(responder: IResponder, tube:String, type: String, listener:Function, streamType: String = null): void{
            trace("get stream");

            var connection:NetConnection = new NetConnection()
            {
                function onBWCheck():void{ trace("onBWCheck") }
            };
            connection.addEventListener("onMetaData", ns_onMetaData);
            connection.addEventListener("onCuePoint", ns_onCuePoint);
            connection.addEventListener(NetStatusEvent.NET_STATUS, function(event:NetStatusEvent):void
            {
                switch(event.info.code)
                {
                    case "NetConnection.Connect.Success":
                        try{

                            var ns:NetStream = new NetStream(connection);

                            var nsClient:Object = {

                            };
                            nsClient.onMetaData = ns_onMetaData;
                            nsClient.onCuePoint = ns_onCuePoint;
                            ns.client = nsClient;

                            listener(ns);
                        }
                        catch(err: Error)
                        {
                            responder.fault(new MediaError("NetStream creation failed"));
                        }
                        break;
                    case "streamIsBusy":
                        responder.fault(new MediaError("Stream is busy. Wait until another user finish publishing"));
                        break;
                    case "onConnectionGetRefused":
                        responder.fault(new MediaError("Connection get refused. Possibly user have not access for operation or tube does not exist"));
                        break;
                    case "NetConnection.Connect.Failed":
                        responder.fault(event.info);
                        break;
                    case "NetConnection.Connect.Rejected":
                        responder.fault(new MediaError("Connection rejected"));
                        break;
                    case "NetStream.Play.StreamNotFound":
                        responder.fault(new MediaError("Stream not found"));
                        break;
                    case "NetConnection.Connect.Closed":
                        trace("Closed");
                        break;
                }
            });

            var connectParams:Array = getConnectParams(tube, type);

            if(streamType != null)
                connection.connect(BACKENDLESS_MEDIA_STREAMING_URL, connectParams[0], connectParams[1], connectParams[2],  connectParams[3],  connectParams[4], streamType );
            else
                connection.connect(BACKENDLESS_MEDIA_STREAMING_URL, connectParams[0], connectParams[1], connectParams[2],  connectParams[3],  connectParams[4]);
        }

        public static function getConnectParams(tube: String, operationType:String ):Array
        {
            var currentUser:BackendlessUser = Backendless.UserService.currentUser;
            var identity:Object = currentUser != null?currentUser.getProperty(Backendless.LOGGED_IN_KEY): null;

            var arr:Array = [];
            arr.push(Backendless.appId.toString());
            arr.push(Backendless.version.toString());
            arr.push(identity != null? identity.toString(): null);
            arr.push(tube.toString());
            arr.push(operationType.toString());
            return arr;
        }

        private function ns_onMetaData(item:Object):void {
            trace("meta");
        }

        private function ns_onCuePoint(item:Object):void {
            trace("cue");
        }

        public function broadcast( stream: String, settings: StreamSettings ):void
        {

        }
	}
}