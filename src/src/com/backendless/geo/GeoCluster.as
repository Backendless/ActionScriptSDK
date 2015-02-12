/**
 * Created by mark on 1/28/15.
 */
package com.backendless.geo
{
  [RemoteClass(alias="com.backendless.geo.model.GeoCluster")]
  public class GeoCluster extends GeoPoint
  {
    private var _totalPoints:int;
    private var _geoQuery:BackendlessGeoQuery;

    public function get totalPoints():int
    {
      return _totalPoints;
    }

    public function set totalPoints( value:int ):void
    {
      _totalPoints = value;
    }

    public function get geoQuery():BackendlessGeoQuery
    {
      return _geoQuery;
    }

    public function set geoQuery( value:BackendlessGeoQuery ):void
    {
      this._geoQuery = value;
    }
  }
}
