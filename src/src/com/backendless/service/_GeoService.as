/*                                                                                                                                                                           
 * ********************************************************************************************************************                                                      
 *                                                                                                                                                                           
 *  BACKENDLESS.COM CONFIDENTIAL                                                                                                                                             
 *                                                                                                                                                                           
 * ********************************************************************************************************************                                                      
 *                                                                                                                                                                           
 *   Copyright 2012 BACKENDLESS.COM. All Rights Reserved.                                                                                                                    
 *                                                                                                                                                                           
 *  NOTICE:  All information contained herein is, and remains the property of Backendless.com and its suppliers,                                                             
 *  if any.  The intellectual and technical concepts contained herein are proprietary to Backendless.com and its                                                             
 *  suppliers and may be covered by U.S. and Foreign Patents, patents in process, and are protected by trade secret                                                          
 *  or copyright law. Dissemination of this information or reproduction of this material is strictly forbidden                                                               
 *  unless prior written permission is obtained from Backendless.com.                                                                                                        
 *                                                                                                                                                                           
 * *******************************************************************************************************************                                                       
 */
package com.backendless.service
{
  import com.backendless.Backendless;
  import com.backendless.data.BackendlessCollection;
  import com.backendless.data.store.Utils;
  import com.backendless.errors.InvalidArgumentError;
  import com.backendless.geo.BackendlessGeoQuery;
  import com.backendless.geo.GeoCluster;
  import com.backendless.geo.GeoPoint;
  import com.backendless.geo.SearchMatchesResult;
  import com.backendless.helpers.ClassHelper;
  import com.backendless.rpc.BackendlessClient;
  import com.backendless.validators.ArgumentValidator;

  import mx.rpc.AsyncToken;
  import mx.rpc.IResponder;
  import mx.rpc.Responder;
  import mx.rpc.events.FaultEvent;
  import mx.rpc.events.ResultEvent;

  public class _GeoService extends BackendlessService
  {
    private static const SERVICE_SOURCE:String = "com.backendless.services.geo.GeoService";

    private static const DEFAULT_CATEGORY:String = "Default";

    public function addCategory( name:String, responder:IResponder = null ):AsyncToken
    {
      ArgumentValidator.notNull( name, "a category name can be neither null nor an empty string" );
      ArgumentValidator.notEmpty( name, "a category name can be neither null nor an empty string" );

      if( name == DEFAULT_CATEGORY )
        throw new InvalidArgumentError( "the 'default' name is reserved; you can't use it" );

      var token:AsyncToken = BackendlessClient.instance.invoke( SERVICE_SOURCE, "addCategory", [Backendless.appId, Backendless.version, name] );
      token.addResponder( new Responder( function ( event:ResultEvent ):void
                                         {
                                           if( responder ) responder.result( event );
                                         }, function ( event:FaultEvent ):void
                                         {
                                           onFault( event, responder );
                                         } ) );

      return token;
    }

    public function deleteCategory( name:String, responder:IResponder = null ):AsyncToken
    {
      ArgumentValidator.notNull( name, "a category name can be neither null nor an empty string" );
      ArgumentValidator.notEmpty( name, "a category name can be neither null nor an empty string" );

      if( name == DEFAULT_CATEGORY )
        throw new InvalidArgumentError( "the 'default' name is reserved; you can't delete it" );

      var token:AsyncToken = BackendlessClient.instance.invoke( SERVICE_SOURCE, "deleteCategory", [Backendless.appId, Backendless.version, name] );
      token.addResponder( new Responder( function ( event:ResultEvent ):void
                                         {
                                           if( responder ) responder.result( event );
                                         }, function ( event:FaultEvent ):void
                                         {
                                           onFault( event, responder );
                                         } ) );

      return token;
    }

    public function addPoint( point:GeoPoint, responder:IResponder = null ):AsyncToken
    {
      return savePoint( point, responder );
    }

    public function savePoint( point:GeoPoint, responder:IResponder = null ):AsyncToken
    {
      ArgumentValidator.notNull( point );
      validateCoordinates( point );

      if( point.categories == null || point.categories.length == 0 )
        point.categories = [ DEFAULT_CATEGORY ];

      for each( var metaValue:Object in point.metadata )
        Utils.addClassName( metaValue, false );

      var remoteMethod:String = point.objectId == null ? "addPoint" : "updatePoint";
      var token:AsyncToken = BackendlessClient.instance.invoke( SERVICE_SOURCE, remoteMethod, [Backendless.appId, Backendless.version, point] );
      token.addResponder( new Responder( function ( event:ResultEvent ):void
                                         {
                                           if( responder ) responder.result( event );
                                         }, function ( event:FaultEvent ):void
                                         {
                                           onFault( event, responder );
                                         } ) );

      return token;
    }

    public function removePoint( point:GeoPoint, responder:IResponder = null ):AsyncToken
    {
      ArgumentValidator.notNull( point );
      var token:AsyncToken = BackendlessClient.instance.invoke( SERVICE_SOURCE, "removePoint", [Backendless.appId, Backendless.version, point.objectId] );
      token.addResponder( new Responder( function ( event:ResultEvent ):void
                                         {
                                           if( responder )
                                             responder.result( event );
                                         },
                                         function ( event:FaultEvent ):void
                                         {
                                           onFault( event, responder );
                                         } ) );

      return token;
    }

    public function getCategories( responder:IResponder = null ):AsyncToken
    {
      var token:AsyncToken = BackendlessClient.instance.invoke( SERVICE_SOURCE, "getCategories", [Backendless.appId, Backendless.version] );
      token.addResponder( new Responder( function ( event:ResultEvent ):void
                                         {
                                           if( responder )
                                             responder.result( event );
                                         },
                                         function ( event:FaultEvent ):void
                                         {
                                           onFault( event, responder );
                                         } ) );

      return token;
    }

    public function getPoints( query:BackendlessGeoQuery, responder:IResponder = null ):BackendlessCollection
    {
      ArgumentValidator.notNull( query );
      ArgumentValidator.notNegative( query.offset, "offset can't be negative" );

      if( query.units != null )
        validateCoordinates( query );

      var result:BackendlessCollection = new BackendlessCollection( ClassHelper.getCanonicalClassName( GeoPoint ) );
      result.pageSize = query.pageSize;
      var token:AsyncToken = BackendlessClient.instance.invoke( SERVICE_SOURCE, "getPoints", [Backendless.appId, Backendless.version, query] );

      token.addResponder( new Responder( function ( event:ResultEvent ):void
                                         {
                                           result.bindSource( event.result );

                                           for each( var geoPoint:GeoPoint in result.currentPage )
                                            if( geoPoint is GeoCluster )
                                              (geoPoint as GeoCluster).geoQuery = query;

                                           if( responder )
                                             responder.result( ResultEvent.createEvent( result, token,  event.message ) );
                                         },
                                         function ( event:FaultEvent ):void
                                         {
                                           onFault( event, responder );
                                         } ) );

      return result;
    }

    public function getClusterPoints( geoCluster:GeoCluster, responder:IResponder = null ):AsyncToken
    {
      ArgumentValidator.notNull( geoCluster );
      var result:BackendlessCollection = new BackendlessCollection( ClassHelper.getCanonicalClassName( GeoPoint ) );
      var args:Array = [Backendless.appId, Backendless.version, geoCluster.objectId, geoCluster.geoQuery ];
      var token:AsyncToken = BackendlessClient.instance.invoke( SERVICE_SOURCE, "loadGeoPoints", args );

      token.addResponder( new Responder( function ( event:ResultEvent ):void
                                         {
                                           result.bindSource( event.result );

                                           for each( var geoPoint:GeoPoint in result.currentPage )
                                            if( geoPoint is GeoCluster )
                                              (geoPoint as GeoCluster).geoQuery = geoCluster.geoQuery;

                                           if( responder )
                                             responder.result( ResultEvent.createEvent( result, token,  event.message ) );
                                         },
                                         function ( event:FaultEvent ):void
                                         {
                                           onFault( event, responder );
                                         } ) );
      return token;
    }

    public function getFencePoints( geoFenceName:String, geoQuery:BackendlessGeoQuery = null, responder:IResponder = null ):AsyncToken
    {
      ArgumentValidator.notNull( geoFenceName );
      var result:BackendlessCollection = new BackendlessCollection( ClassHelper.getCanonicalClassName( GeoPoint ) );
      var args:Array = [Backendless.appId, Backendless.version, geoFenceName, geoQuery ];
      var token:AsyncToken = BackendlessClient.instance.invoke( SERVICE_SOURCE, "getPoints", args );

      token.addResponder( new Responder( function ( event:ResultEvent ):void
                                         {
                                           result.bindSource( event.result );

                                           for each( var geoPoint:GeoPoint in result.currentPage )
                                            if( geoPoint is GeoCluster )
                                              (geoPoint as GeoCluster).geoQuery = geoQuery;

                                           if( responder )
                                             responder.result( ResultEvent.createEvent( result, token,  event.message ) );
                                         },
                                         function ( event:FaultEvent ):void
                                         {
                                           onFault( event, responder );
                                         } ) );
      return token;
    }

    public function runOnEnterAction( geoFenceName:String, geoPoint:GeoPoint = null, responder:IResponder = null ):AsyncToken
    {
      return runGeoAction( "runOnEnterAction", geoFenceName, geoPoint, responder );
    }

    public function runOnStayAction( geoFenceName:String, geoPoint:GeoPoint = null, responder:IResponder = null ):AsyncToken
    {
      return runGeoAction( "runOnStayAction", geoFenceName, geoPoint, responder );

    }

    public function runOnExitAction( geoFenceName:String, geoPoint:GeoPoint = null, responder:IResponder = null ):AsyncToken
    {
      return runGeoAction( "runOnExitAction", geoFenceName, geoPoint, responder );
    }

    private function runGeoAction( methodName:String, geoFenceName:String, geoPoint:GeoPoint = null, responder:IResponder = null ):AsyncToken
    {
      ArgumentValidator.notNull( geoFenceName );
      var args:Array;

      if( geoPoint == null )
        args = [Backendless.appId, Backendless.version, geoFenceName ];
      else
        args = [Backendless.appId, Backendless.version, geoFenceName, geoPoint ];

      var token:AsyncToken = BackendlessClient.instance.invoke( SERVICE_SOURCE, methodName, args );
      token.addResponder( new Responder( function ( event:ResultEvent ):void
                                         {
                                           if( responder )
                                             responder.result( event );
                                         },
                                         function ( event:FaultEvent ):void
                                         {
                                           onFault( event, responder );
                                         } ) );
      return token;
    }

    public function relativeFind( geoQuery:BackendlessGeoQuery, responder:IResponder = null ):AsyncToken
    {
      ArgumentValidator.notNull( geoQuery, "BackendlessGeoQuery cannot be null" );
      ArgumentValidator.notNull( geoQuery.relativeFindMetadata, "relativeFindMetadata in BackendlessGeoQuery cannot be null" );
      ArgumentValidator.notEmpty( geoQuery.relativeFindMetadata, "relativeFindMetadata in BackendlessGeoQuery must contain at least one metadata property" );
      ArgumentValidator.greaterThanZero( geoQuery.relativeFindPercentThreshold, "relativeFindPercentThreshold in BackendlessGeoQuery must be greater than zero" );

      var result:BackendlessCollection = new BackendlessCollection( ClassHelper.getCanonicalClassName( SearchMatchesResult ) );
      result.pageSize = geoQuery.pageSize;

      var methodArgs:Array = [Backendless.appId, Backendless.version, geoQuery ];
      var token:AsyncToken = BackendlessClient.instance.invoke( SERVICE_SOURCE, "relativeFind", methodArgs );
      token.addResponder( new Responder( function ( event:ResultEvent ):void
                                         {
                                           result.bindSource( event.result );
                                           if( responder )
                                             responder.result( ResultEvent.createEvent( result, token, event.message ) );
                                         },
                                         function ( event:FaultEvent ):void
                                         {
                                           onFault( event, responder );
                                         } ) );

      return token;
    }

    public function loadMetadata( pointOrCluster:*, responder:IResponder = null ):AsyncToken
    {
      var methodArgs:Array;

      if( pointOrCluster is GeoPoint )
      {
        var geoPoint:GeoPoint = pointOrCluster as GeoPoint;
        methodArgs = [Backendless.appId, Backendless.version, geoPoint.objectId ];
      }

      if( pointOrCluster is GeoCluster )
      {
        var geoCluster:GeoCluster = pointOrCluster as GeoCluster;
        methodArgs.push( geoCluster.geoQuery );
      }
      else
      {
        methodArgs.push( null );
      }

      var token:AsyncToken = BackendlessClient.instance.invoke( SERVICE_SOURCE, "loadMetadata", methodArgs );
      token.addResponder( new Responder( function ( event:ResultEvent ):void
                                         {
                                           pointOrCluster.metadata = event.result;

                                           if( responder )
                                             responder.result( ResultEvent.createEvent( pointOrCluster, token, event.message ) );
                                         },
                                         function ( event:FaultEvent ):void
                                         {
                                           onFault( event, responder );
                                         } ) );

      return token;
    }

    private function validateCoordinates( pointOrQuery:* ):void
    {
      if( pointOrQuery is GeoPoint || pointOrQuery is BackendlessGeoQuery )
      {
        ArgumentValidator.validate( pointOrQuery.longitude, function ( value:Number ):Boolean
        {
          return !isNaN( value ) && value <= 180 && value >= -180;
        }, "Value of longitude should be less or equal 180 and greater or equal -180" );

        ArgumentValidator.validate( pointOrQuery.latitude, function ( value:Number ):Boolean
        {
          return !isNaN( value ) && value <= 90 && value >= -90;
        }, "Value of latitude should be less or equal 90 and greater or equal -90" );
      }
    }
  }
}