package com.backendless
{
  public class BackendlessDataQuery
  {
    private var _properties:Array = [];
    private var _whereClause:String;
    private var _queryOptions:QueryOptions = new QueryOptions;

    public function BackendlessDataQuery( whereClause:String = null ):void
    {
      this.whereClause = whereClause;
    }

    public function get properties():Array
    {
      return _properties;
    }

    public function set properties( value:Array ):void
    {
      _properties = value;
    }

    public function get whereClause():String
    {
      return _whereClause;
    }

    public function set whereClause( value:String ):void
    {
      _whereClause = value;
    }

    public function get queryOptions():QueryOptions
    {
      return _queryOptions;
    }

    public function set queryOptions( value:QueryOptions ):void
    {
      _queryOptions = value;
    }
  }
}