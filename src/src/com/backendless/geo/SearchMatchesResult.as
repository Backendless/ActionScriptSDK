package com.backendless.geo
{
  public class SearchMatchesResult
  {
    private var _matches:Number;
    private var _geoPoint:GeoPoint;

    public function get matches():Number
    {
      return _matches;
    }

    public function set matches( value:Number ):void
    {
      _matches = value;
    }

    public function get geoPoint():com.backendless.geo.GeoPoint
    {
      return _geoPoint;
    }

    public function set geoPoint( value:GeoPoint ):void
    {
      _geoPoint = value;
    }
  }
}
