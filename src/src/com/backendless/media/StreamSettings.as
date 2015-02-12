package com.backendless.media
{
  import flash.media.Camera;
  import flash.media.Microphone;
  import flash.media.Video;

  public class StreamSettings
  {
    private var _camera:Camera;
    private var _microphone:Microphone;

    public function StreamSettings( camera:Camera = null, microphone:Microphone = null )
    {
      this._camera = camera;
      this._microphone = microphone;
    }

    public function get camera():Camera
    {
      if( _camera == null )
        _camera = Camera.getCamera();

      return _camera;
    }

    public function set camera( value:Camera ):void
    {
      _camera = value;
    }

    public function get microphone():Microphone
    {
      if( _microphone == null )
        _microphone = Microphone.getMicrophone();

      return _microphone;
    }

    public function set microphone( value:Microphone ):void
    {
      _microphone = value;
    }
  }
}