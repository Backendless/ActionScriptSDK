/**
 * Created by mark on 1/21/15.
 */
package com.backendless.data
{
  import flash.utils.getQualifiedClassName;

  import com.backendless.Backendless;
  import com.backendless.rpc.BackendlessClient;

  import flash.utils.getDefinitionByName;

  import mx.rpc.AsyncToken;
  import mx.rpc.IResponder;

  public class AbstractDataPermission
  {
    private static const PERMISSION_SERVICE:String = "com.backendless.services.persistence.permissions.ClientPermissionService";

    //private static const PERMISSION_SERVICE:String = "com.backendless.services.persistence.common.permissions.ClientPermissionService";
    protected function getOperation():PersistenceOperation
    {
      return null;
    }

    public function grantForUser( userId:String, dataObject:Object, responder:IResponder ):void
    {
      var method:String = "updateUserPermission";
      var args:Array = buildArgs( dataObject, userId, PermissionTypes.GRANT );
      serverCall( responder, method, args );
    }

    public function denyForUser( userId:String, dataObject:Object, responder:IResponder ):void
    {
      var method:String = "updateUserPermission";
      var args:Array = buildArgs( dataObject, userId, PermissionTypes.DENY );
      serverCall( responder, method, args );
    }

    public function grantForRole( roleName:String, dataObject:Object, responder:IResponder ):void
    {
      var method:String = "updateRolePermission";
      var args:Array = buildArgs( dataObject, roleName, PermissionTypes.GRANT );
      serverCall( responder, method, args );
    }

    public function denyForRole( roleName:String, dataObject:Object, responder:IResponder ):void
    {
      var method:String = "updateRolePermission";
      var args:Array = buildArgs( dataObject, roleName, PermissionTypes.DENY );
      serverCall( responder, method, args );
    }

    public function grantForAllUsers( dataObject:Object, responder:IResponder ):void
    {
      var method:String = "updateAllUserPermission";
      var args:Array = buildArgs( dataObject, null, PermissionTypes.GRANT );
      serverCall( responder, method, args );
    }

    public function denyForAllUsers( dataObject:Object, responder:IResponder ):void
    {
      var method:String = "updateAllUserPermission";
      var args:Array = buildArgs( dataObject, null, PermissionTypes.DENY );
      serverCall( responder, method, args );
    }

    public function grantForAllRoles( dataObject:Object, responder:IResponder ):void
    {
      var method:String = "updateAllRolePermission";
      var args:Array = buildArgs( dataObject, null, PermissionTypes.GRANT );
      serverCall( responder, method, args );
    }

    public function denyForAllRoles( dataObject:Object, responder:IResponder ):void
    {
      var method:String = "updateAllRolePermission";
      var args:Array = buildArgs( dataObject, null, PermissionTypes.DENY );
      serverCall( responder, method, args );
    }

    private function buildArgs( dataObject:Object, principal:String, permissionType:PermissionTypes ):Array
    {

      var appId:String = Backendless.appId;
      var version:String = Backendless.version;
      var className:String  = getQualifiedClassName( dataObject );
      var dataObjectClass:Class = getDefinitionByName( className ) as Class;
      var tableName:String = Backendless.Data.getTableNameForClass( dataObjectClass );

      var objectId:String = null;

      if( dataObject.hasOwnProperty( "objectId" ) && dataObject.objectId != null )
       objectId = dataObject.objectId;

      var operation:PersistenceOperation = getOperation();

      if( principal != null )
        return [ appId, version, tableName, principal, objectId, operation.getId(), permissionType.getId() ];
      else
        return [ appId, version, tableName, objectId, operation.getId(), permissionType.getId() ];
    }

    private function serverCall( responder:IResponder, method:String, args:Array ):AsyncToken
    {
      var token:AsyncToken = BackendlessClient.instance.invoke( PERMISSION_SERVICE, method, args );

      if( responder != null )
        token.addResponder( responder );

      return token;
    }
  }
}
