package com.backendless.geo
{
  [RemoteClass(alias="com.backendless.geo.BackendlessGeoQuery")]
  public class BackendlessGeoQuery
  {
    private static const CLUSTER_SIZE_DEFAULT_VALUE:int = 100;
    private var _latitude:Number;
    private var _longitude:Number;
    private var _searchRectangle:Array = null;
    private var _radius:Number;
    private var _units:String;
    private var _categories:Array = [];
    private var _metadata:Object = {};
    private var _includeMeta:Boolean;
    private var _pageSize:int = 100;
    private var _offset:int;
    private var _relativeFindPercentThreshold:Number = 0;
    private var _relativeFindMetadata:Object;
    private var _whereClause:String;
    private var _dpp:Number;
    private var _clusterGridSize:int = CLUSTER_SIZE_DEFAULT_VALUE;

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

    public function get offset():int
    {
      return _offset;
    }

    public function set offset( value:int ):void
    {
      _offset = value;
    }

    public function get pageSize():int
    {
      return _pageSize;
    }

    public function set pageSize( value:int ):void
    {
      _pageSize = value;
    }

    public function get includeMeta():Boolean
    {
      return _includeMeta;
    }

    public function set includeMeta( value:Boolean ):void
    {
      _includeMeta = value;
    }

    public function get metadata():Object
    {
      return _metadata;
    }

    public function set metadata( value:Object ):void
    {
      _metadata = value;
    }

    public function get relativeFindMetadata():Object
    {
      return _relativeFindMetadata;
    }

    public function set relativeFindMetadata( value:Object ):void
    {
      _relativeFindMetadata = value;
    }

    public function get categories():Array
    {
      return _categories;
    }

    public function set categories( value:Array ):void
    {
      _categories = value;
    }

    public function get units():String
    {
      return _units;
    }

    public function set units( value:String ):void
    {
      _units = value;
    }

    public function get radius():Number
    {
      return _radius;
    }

    public function set radius( value:Number ):void
    {
      _radius = value;
    }

    public function get searchRectangle():Array
    {
      return _searchRectangle;
    }

    public function set searchRectangle( value:Array ):void
    {
      _searchRectangle = value;
    }

    public function get dpp():Number
    {
      return _dpp;
    }

    public function set dpp( value:Number ):void
    {
      _dpp = value;
    }

    public function get clusterGridSize():int
    {
      return _clusterGridSize;
    }

    public function set clusterGridSize( value:int ):void
    {
      _clusterGridSize = value;
    }

    public function addMetadata( key:*, value:* ):void
    {
      if( key == null || value == null )
        throw new Error( "null key or null value are not allowed" );

      if( _metadata == null )
        _metadata = new Object();

      _metadata[key] = value;
    }

    public function get relativeFindPercentThreshold():Number
    {
      return _relativeFindPercentThreshold;
    }

    public function set relativeFindPercentThreshold( value:Number ):void
    {
      _relativeFindPercentThreshold = value;
    }

    public function addRelativeFindMetadata( key:*, value:* ):void
    {
      if( key == null || value == null )
         throw new Error( "null key or null value are not allowed" );

       if( _relativeFindMetadata == null )
         _relativeFindMetadata = new Object();

      _relativeFindMetadata[key] = value;
    }

    public function get whereClause():String
    {
      return _whereClause;
    }

    public function set whereClause( value:String ):void
    {
      _whereClause = value;
    }

    public function setClusteringParams( westLongitude:Number, eastLongitude:Number, mapWidth:int, clusterGridSize:int = CLUSTER_SIZE_DEFAULT_VALUE ):void
    {
      var longDiff:Number = eastLongitude - westLongitude;

      if( longDiff < 0 )
        longDiff += 360;

      dpp = longDiff / mapWidth;
      this.clusterGridSize = clusterGridSize;
    }
  }
}