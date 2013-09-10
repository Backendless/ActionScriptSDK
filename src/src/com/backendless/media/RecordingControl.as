package com.backendless.media
{
import flash.media.Camera;
import flash.media.Video;
import flash.net.NetStream;

public class RecordingControl
{
    private var stream: NetStream;
    private var recordStarted:Boolean;
    private var streamName:String;
    private var tube:String;
    private var settings:StreamSettings;
    private var _playback:Video;
    private var paused:Boolean = false;
    private var type:String = "record";


    public function RecordingControl(stream:NetStream, tube:String, settings:StreamSettings, filename:String, type:String = "record") {
        this.stream = stream;
        this.streamName = filename;
        this.tube = tube;
        this.settings = settings;
        this.type = type;
    }

    public function stop():void
    {
        stream.close();
        paused = false;
    }

    public function pause():void
    {
        stream.pause();
    }

    public function resume():void
    {
        stream.resume();
    }

    public function start():void
    {
        recordStarted = true;
        stream.publish(streamName);
    }

    public function togglePause():void
    {
        if(!paused)
        {
            paused = true;
            stream.attachCamera(null);
            stream.attachAudio(null);
        }
        else
        {
            paused = false;
            stream.attachCamera(settings.camera);
            stream.attachAudio(settings.microphone);
        }
    }

    public function get playback():Video
    {
        if(_playback == null)
        {
            _playback = new Video();
            _playback.attachCamera(settings.camera);
        }
        return _playback;
    }

}
}