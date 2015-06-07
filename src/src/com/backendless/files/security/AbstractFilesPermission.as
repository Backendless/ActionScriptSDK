/**
 * Created by mark on 4/7/15.
 */
package com.backendless.files.security
{
  import com.backendless.Backendless;
  import com.backendless.common.PermissionTypes;
  import com.backendless.rpc.BackendlessClient;

  import mx.rpc.AsyncToken;
  import mx.rpc.IResponder;

  public class AbstractFilesPermission
  {
    private static const PERMISSION_SERVICE:String = "com.backendless.services.file.FileService";

    protected function getOperation():FileOperation
    {
      return null;
    }

    public function grantForUser( userId:String, fileOrDirPath:String, responder:IResponder = null ):void
    {
      var method:String = "updateUserPermission";
      var args:Array = buildArgs( fileOrDirPath, userId, false, PermissionTypes.GRANT );
      serverCall( responder, method, args );
    }

    public function denyForUser( userId:String, fileOrDirPath:String, responder:IResponder = null ):void
    {
      var method:String = "updateUserPermission";
      var args:Array = buildArgs( fileOrDirPath, userId, false, PermissionTypes.DENY );
      serverCall( responder, method, args );
    }

    public function grantForRole( roleName:String, fileOrDirPath:String, responder:IResponder = null ):void
    {
      var method:String = "updateRolePermission";
      var args:Array = buildArgs( fileOrDirPath, roleName, true, PermissionTypes.GRANT );
      serverCall( responder, method, args );
    }

    public function denyForRole( roleName:String, fileOrDirPath:String, responder:IResponder = null ):void
    {
      var method:String = "updateRolePermission";
      var args:Array = buildArgs( fileOrDirPath, roleName, true, PermissionTypes.DENY );
      serverCall( responder, method, args );
    }

    public function grantForAllUsers( fileOrDirPath:String, responder:IResponder = null ):void
    {
      var method:String = "updatePermissionForAllUsers";
      var args:Array = buildArgs( fileOrDirPath, null, false, PermissionTypes.GRANT );
      serverCall( responder, method, args );
    }

    public function denyForAllUsers( fileOrDirPath:String, responder:IResponder = null ):void
    {
      var method:String = "updatePermissionForAllUsers";
      var args:Array = buildArgs( fileOrDirPath, null, false, PermissionTypes.DENY );
      serverCall( responder, method, args );
    }

    public function grantForAllRoles( fileOrDirPath:String, responder:IResponder = null ):void
    {
      var method:String = "updateRolePermissionsForAllRoles";
      var args:Array = buildArgs( fileOrDirPath, null, true, PermissionTypes.GRANT );
      serverCall( responder, method, args );
    }

    public function denyForAllRoles( fileOrDirPath:String, responder:IResponder = null ):void
    {
      var method:String = "updateRolePermissionsForAllRoles";
      var args:Array = buildArgs( fileOrDirPath, null, true, PermissionTypes.DENY );
      serverCall( responder, method, args );
    }

    private function buildArgs( fileOrDirPath:String, principal:String, isRole:Boolean, permissionType:PermissionTypes ):Array
    {
      var appId:String = Backendless.appId;
      var version:String = Backendless.version;
      var operation:FileOperation = getOperation();
      var permission:BasePermission;

      if( isRole )
        permission = new FileRolePermission();
      else
        permission = new FileUserPermission();

      permission.access = permissionType.getId();
      permission.folder = fileOrDirPath;
      permission.operation = operation.getId();

      if( principal != null )
        return [ appId, version, principal, permission ];
      else
        return [ appId, version, permission ];
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
