package com.backendless.data.store
{
  import com.backendless.BackendlessUser;
  import com.backendless.data.BackendlessCollection;

  import flash.utils.getQualifiedClassName;

  import mx.utils.ObjectUtil;

  public class Utils
  {
    public static function prepareArgForSend( obj:Object ):Object
    {
      if( obj is Array )
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
      else if( !ObjectUtil.isSimple( obj ) )
      {
        var targetObject:Object = {};
        var objInfo:Object = ObjectUtil.getClassInfo( obj );

        for each( var item:QName in objInfo.properties )
        {
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

    public static function addClassName( dataObject:*, isRoot:Boolean ):void
    {
      if( dataObject is Array )
      {
        for( var prop:* in dataObject )
          addClassName( dataObject[ prop ], false );
      }
      else if( dataObject is BackendlessCollection )
      {
        var collection:BackendlessCollection = dataObject as BackendlessCollection;

        if( collection.currentPage != null )
          addClassName( collection.currentPage.source, false );
      }
      else if( !ObjectUtil.isSimple( dataObject ) && !(dataObject is BackendlessUser) )
      {
        var objInfo:Object = ObjectUtil.getClassInfo( dataObject );

        for each( var item:QName in objInfo.properties )
        {
          var obj:* = dataObject[ item.localName ];

          if( obj != null && (!ObjectUtil.isSimple( obj ) || obj is Array) )
            addClassName( obj, false );
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