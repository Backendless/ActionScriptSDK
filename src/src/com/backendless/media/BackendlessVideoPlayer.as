package com.backendless.media
{
import com.backendless.errors.MediaError;
import com.backendless.service._MediaService;

import org.osmf.net.DynamicStreamingResource;

import spark.components.VideoDisplay;
import spark.components.VideoPlayer;

public class BackendlessVideoPlayer extends VideoPlayer
{
    override public function set source(value:Object):void {

        var dynamicStreamingResource:DynamicStreamingResource = BackendlessVideoSource.makeStreamingResource(value);

        super.source = dynamicStreamingResource;
    }
}
}