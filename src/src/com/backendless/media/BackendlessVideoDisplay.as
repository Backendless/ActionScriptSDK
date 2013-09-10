package com.backendless.media
{

import com.backendless.service._MediaService;

import org.osmf.net.DynamicStreamingResource;

import spark.components.VideoDisplay;
import spark.components.mediaClasses.DynamicStreamingVideoSource;

public class BackendlessVideoDisplay extends VideoDisplay
{
    override public function set source(value:Object):void {

        super.source = BackendlessVideoSource.makeStreamingResource(value);

    }
}
}