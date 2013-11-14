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
package com.backendless.rpc
{
	import com.backendless.Backendless;
	import com.backendless.core.backendless;
	import com.backendless.messaging.BackendlessChannel;
	
	import flash.events.EventDispatcher;
	
	import mx.messaging.ChannelSet;
	import mx.rpc.AbstractOperation;
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.remoting.RemoteObject;
	
	public class BackendlessClient extends EventDispatcher
	{
		private static const DEFAULT_DESTINATION:String = "GenericDestination";
		
		private var _channelSet:ChannelSet;
		
		private static var _instance:BackendlessClient;
		
		public function BackendlessClient(lock:BackendlessClientLock):void {
			if(lock == null) {
				throw new Error("BackendlessClient class is a singleton. Please use BackendlessClient.instance instead of the direct instantiation");
			}
		}

		public function invoke(source:String, methodName:String, args:Array = null, responder:IResponder = null):AsyncToken {
			var remoteObject:RemoteObject = new RemoteObject(DEFAULT_DESTINATION);
			remoteObject.channelSet = _channelSet;
			remoteObject.source = source;
			
			var operation:AbstractOperation = remoteObject.getOperation(methodName);
			operation.arguments = args;
			
			var token:AsyncToken = operation.send();
			if (responder) token.addResponder(responder);
			
			return token;
		}
		
		public static function get instance():BackendlessClient 
		{
			if(_instance == null)
				_instance = new BackendlessClient(new BackendlessClientLock());
			
			return _instance;
		}
		
		backendless function initChannel():void
		{
			_channelSet = new ChannelSet();
			_channelSet.addChannel(new BackendlessChannel(null, Backendless.AMF_ENDPOINT));
		}		
	}
}

class BackendlessClientLock{}