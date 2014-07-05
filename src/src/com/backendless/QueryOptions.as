package com.backendless
{
  import flash.utils.Dictionary;

  public class QueryOptions
  {
    private var _pageSize:int;
    private var _offset:int;
    private var _sortBy:Array;
    private var _related:Array;
    private var _relationsDepth:int;

    public function QueryOptions( pageSize:int = 20, offset:int = 0 ):void
    {
      _pageSize = pageSize;
      _offset = offset;
    }

    public function set pageSize( value:int ):void
    {
      _pageSize = value;
    }

    public function get pageSize():int
    {
      return _pageSize;
    }

    public function set offset( value:int ):void
    {
      _offset = value;
    }

    public function get offset():int
    {
      return _offset;
    }

    public function set sortBy( value:Array ):void
    {
      _sortBy = value;
    }

    public function get sortBy():Array
    {
      return _sortBy;
    }

    public function set related( value:Array ):void
    {
      _related = value;
    }

    public function get related():Array
    {
      return _related;
    }

    public function set relationsDepth( value:int ):void
    {
      _relationsDepth = value;
    }

    public function get relationsDepth():int
    {
      return _relationsDepth;
    }

    public function getQuery():Dictionary
    {
      var result:Dictionary = new Dictionary();

      if( _pageSize > 0 )
      {
        result["pageSize"] = _pageSize;
      }
      result["offset"] = _offset;

      if( _sortBy != null )
      {
        result["sortBy"] = _sortBy;
      }
      if( _related != null )
      {
        result["related"] = _related;
      }

      return result;
    }
  }
}