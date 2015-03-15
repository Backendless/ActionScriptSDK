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
package com.backendless.data.store
{
  import com.backendless.BackendlessUser;
  import com.backendless.data.BackendlessCollection;
  import com.backendless.geo.BackendlessGeoQuery;
  import com.backendless.geo.GeoCluster;
  import com.backendless.geo.GeoPoint;

  import flash.utils.ByteArray;
  import flash.utils.Dictionary;
  import flash.utils.describeType;

  import flash.utils.getQualifiedClassName;

  import mx.collections.ArrayCollection;

  import mx.utils.ObjectUtil;

  public class Utils
  {
    public static function prepareArgForSend( obj:Object ):Object
    {
      if( obj is BackendlessGeoQuery || obj is ArrayCollection || obj is GeoPoint || obj is GeoCluster )
      {
        return obj;
      }
      else if( obj is Array )
      {
        for( var prop:* in obj )
          obj[ prop ] = prepareArgForSend( obj[ prop ] );

        return obj;
      }
      else if( obj is BackendlessCollection )
      {
        var collection:BackendlessCollection = obj as BackendlessCollection;

        if( collection.currentPage != null )
          return collection.currentPage.source;
        else
          return null;
      }
      else if( obj is BackendlessUser )
      {
        var userProps:Object = (obj as BackendlessUser).properties;

        if( userProps[ BackendlessUser.PASSWORD ] == null  )
          delete userProps[ BackendlessUser.PASSWORD ];

        return userProps;
      }
      else if( !ObjectUtil.isSimple( obj ) && !(obj is ByteArray))
      {
        var targetObject:Object = {};
        var objInfo:Object = ObjectUtil.getClassInfo( obj );

        //var xDesc:XML = describeType( Object( obj ).constructor );

        for each( var item:QName in objInfo.properties )
        {
          //if( xDesc.factory.variable.(@name== item.localName ).metadata.(@name == 'Transient' ).length() > 0 )
          if( objInfo.metadata != null && objInfo.metadata[ item.localName ].hasOwnProperty( 'Transient' ) )
            continue;

          var objProp:* = obj[ item.localName ];

          if( objProp != null && (!ObjectUtil.isSimple( objProp ) || objProp is Array) )
            targetObject[ item.localName ] = prepareArgForSend( objProp );
          else
            targetObject[ item.localName ] = objProp;
        }

        return targetObject;
      }

      return obj;
    }

    public static function addClassName( dataObject:*, isRoot:Boolean, context:Dictionary = null ):void
    {
      if( context == null )
        context = new Dictionary();

      if( context[ dataObject ] != null )
        return;

      context[ dataObject ] = true;

      if( dataObject is Array )
      {
        for( var prop:* in dataObject )
          addClassName( dataObject[ prop ], false, context );
      }
      else if( dataObject is ArrayCollection )
      {
        var arraycollection:ArrayCollection = dataObject as ArrayCollection;

        for each( var obj:* in arraycollection )
          addClassName( obj, false, context );
      }
      else if( dataObject is BackendlessCollection )
      {
        var collection:BackendlessCollection = dataObject as BackendlessCollection;

        if( collection.currentPage != null )
          addClassName( collection.currentPage.source, false, context );
      }
      else if( !ObjectUtil.isSimple( dataObject ) && !(dataObject is BackendlessUser) && !(dataObject is GeoPoint) )
      {
        var objInfo:Object = ObjectUtil.getClassInfo( dataObject );

        for each( var item:QName in objInfo.properties )
        {
          var obj:* = dataObject[ item.localName ];

          if( obj != null && (!ObjectUtil.isSimple( obj ) || obj is Array) )
            addClassName( obj, false, context );
        }

        if( !isRoot && !dataObject.hasOwnProperty( "___class" ) )
        {
          if( !ObjectUtil.isDynamicObject( dataObject ) )
            throw new Error( "Cannot save/update object. Class " + objInfo["name" ] + " does not have ___class definition. Either declare '___class' property in all related objects or declare class 'dynamic'. The property value must be the name of the class/table." );

          var className:String = getQualifiedClassName( dataObject );
          var dot:int = className.lastIndexOf( ":" );

          if( dot > -1 )
            className = className.substring( dot + 1 );

          dataObject[ "___class" ] = className;
        }
      }
    }
  }
}