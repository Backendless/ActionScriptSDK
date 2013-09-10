////////////////////////////////////////////////////////////////////////////////
//
//  ADOBE SYSTEMS INCORPORATED
//  Copyright 2009 Adobe Systems Incorporated
//  All Rights Reserved.
//
//  NOTICE: Adobe permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.backendless.media
{
import com.backendless.errors.MediaError;
import com.backendless.service._MediaService;


import org.osmf.net.DynamicStreamingItem;
import org.osmf.net.DynamicStreamingResource;
import spark.components.mediaClasses.DynamicStreamingVideoItem;

[DefaultProperty("streamItems")]

public class BackendlessVideoSource extends Object
{
    private var _tube: String;

    public function BackendlessVideoSource()
    {
        super();
    }

    [Inspectable(category="General")]

    //----------------------------------
    //  initialIndex
    //----------------------------------

    private var _initialIndex:int;

    [Inspectable(category="General")]

    /**
     *  The preferred starting index.  This corresponds to
     *  the stream item that should be attempted first.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get initialIndex():int
    {
        return _initialIndex;
    }

    /**
     *  @private
     */
    public function set initialIndex(value:int):void
    {
        _initialIndex = value;
    }

    //----------------------------------
    //  streamItems
    //----------------------------------

    private var _streamItems:Vector.<DynamicStreamingVideoItem>;

    [Inspectable(category="General")]

    /**
     *  The metadata info object with properties describing the FLB file.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get streamItems():Vector.<DynamicStreamingVideoItem>
    {
        return _streamItems;
    }

    /**
     *  @private
     */
    public function set streamItems(value:Vector.<DynamicStreamingVideoItem>):void
    {
        _streamItems = value;
    }

    //----------------------------------
    //  streamType
    //----------------------------------

    private var _streamType:String = "any";

    [Inspectable(category="General", enumeration="any,live,recorded", defaultValue="any")]

    /**
     *  The type of stream we are trying to connect to: any, live, or recorded.
     *
     *  <p>If the streamType is <code>any</code>, then we will attempt to
     *  connect to a live stream first.  If no live stream is found, we will
     *  attempt to connect to a recorded stream.  If no recorded stream is found,
     *  then a live stream will be created.</p>
     *
     *  @default any
     *
     *  @see org.osmf.net.StreamType
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get streamType():String
    {
        return _streamType;
    }

    /**
     *  @private
     */
    public function set streamType(value:String):void
    {
        _streamType = value;
    }

    public function get tube():String {
        return _tube;
    }

    public function set tube(value:String):void {
        _tube = value;
    }

    public static function makeStreamingResource(value:Object):DynamicStreamingResource {

        if (value is BackendlessVideoSource)
        {
            var streamingSource:BackendlessVideoSource = value as BackendlessVideoSource;
            var dsr:DynamicStreamingResource;

            dsr = new DynamicStreamingResource(_MediaService.BACKENDLESS_MEDIA_STREAMING_URL,
                    streamingSource.streamType);

            if (dsr) {
                var params:Array = _MediaService.getConnectParams(streamingSource.tube, streamingSource.operationType);
                if(dsr.connectionArguments == null)
                {
                    dsr.connectionArguments = new Vector.<Object>();
                }

                for each (var object:Object in params) {
                    dsr.connectionArguments.push(object);
                }

                var n:int = streamingSource.streamItems.length;
                var item:DynamicStreamingVideoItem;
                var dsi:DynamicStreamingItem;
                var streamItems:Vector.<DynamicStreamingItem> = new Vector.<DynamicStreamingItem>(n);

                for (var i:int = 0; i < n; i++)
                {
                    item = streamingSource.streamItems[i];
                    dsi = new DynamicStreamingItem(item.streamName, item.bitrate);
                    streamItems[i] = dsi;
                }
                dsr.streamItems = streamItems;

                dsr.initialIndex = streamingSource.initialIndex;

                // add video type metadata so if the URL is ambiguous, OSMF will
                // know what type of file we're trying to connect to
                dsr.mediaType = "video";
            }
            return dsr;
        }
        else{
            throw new MediaError("Video display supports only BackendlessVideoSource objects as source")
        }
    }

    public function get operationType():String
    {
        if(_streamType == "live")
            return "playLive";
        if(_streamType == "recorded")
            return "playRecorded";
        if(_streamType == "any")
            return "playAny";
        else throw MediaError("Unsupported stream type");
    }

}
}
