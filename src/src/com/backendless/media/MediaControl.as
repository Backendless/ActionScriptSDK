package com.backendless.media
{
import flash.media.Video;
import flash.net.NetStream;

public class MediaControl
{
    private var _video:Video;
    private var _stream:NetStream;
    private var filename:String;
    private var tube:String;
    private var playStarted:Boolean;

    public function MediaControl(stream:NetStream, tube:String, filename:String) {
        _video = new Video();
        video.attachNetStream(stream);

        this.filename = filename;
        this.tube = tube;
        this._stream = stream;
    }

    public function stop():void
    {
        _stream.close();
    }

    public function fastForward():void
    {

    }

    public function rewind():void
    {
        _stream.seek(0);
        _stream.pause();
    }

    public function pause():void
    {
        _stream.pause();
    }

    public function resume():void
    {
        _stream.resume();
    }

    public function start():void
    {
        playStarted = true;
        _stream.play(filename);
    }

    public function togglePause():void
    {
        if(!playStarted)
            start();
        else
            _stream.togglePause();
    }

    public function get video():Video {
        return _video;
    }

}
}