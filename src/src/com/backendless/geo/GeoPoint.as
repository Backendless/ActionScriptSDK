package com.backendless.geo
{
  import flash.utils.getQualifiedClassName;

  import mx.collections.ArrayCollection;
  import mx.utils.ObjectUtil;

  [RemoteClass(alias="com.backendless.geo.model.GeoPoint")]
  public class GeoPoint
  {
    private var _objectId:String;
    private var _categories:Array;
    private var _metadata:Object = {};
    private var _distance:Number;
    private var _latitude:Number;
    private var _longitude:Number;

    public function GeoPoint( latitude:Number = 0, longitude:Number = 0 ):void
    {
      this.latitude = latitude;
      this.longitude = longitude;
    }

    public function get latitude():Number
    {
      return _latitude;
    }

    public function set latitude( value:Number ):void
    {
      _latitude = value;
    }

    public function get longitude():Number
    {
      return _longitude;
    }

    public function set longitude( value:Number ):void
    {
      _longitude = value;
    }

    public function get objectId():String
    {
      return _objectId;
    }

    public function set objectId( value:String ):void
    {
      _objectId = value;
    }

    public function get categories():Array
    {
      if( _categories == null )
        _categories = [];

      return _categories;
    }

    public function set categories( value:* ):void
    {
      if( value is ArrayCollection )
        _categories = (value as ArrayCollection).source;

      if( value is Array )
        _categories = value as Array;
    }

    public function get metadata():Object
    {
      return _metadata;
    }

    public function set metadata( value:Object ):void
    {
      _metadata = value;
    }

    public function get distance():Number
    {
      return _distance;
    }

    public function set distance( value:Number ):void
    {
      this._distance = value;
    }

    public function addCategory( categoryName:String ):void
    {
      if( _categories == null )
        _categories = [];

      _categories.push( categoryName );
    }

    public function clearMetadata():void
    {
      _metadata = new Object();
    }

    public function addMetadata( key:String, value:Object ):void
    {
      _metadata[ key ] = value;
    }

    public function set ___class( value:String ):void
    {

    }

    public function get ___class():String
    {
      return "com.backendless.geo.model.GeoPoint";
    }
    public function toString():String
    {
      return getQualifiedClassName( this ) + "{ objectId='".concat( objectId, "' latitude=", latitude,", longitude=",longitude,", categories=[", categories.join(", "),"], metadata={",ObjectUtil.toString( metadata ),"}, distance=",distance,"}" );
    }
  }
}