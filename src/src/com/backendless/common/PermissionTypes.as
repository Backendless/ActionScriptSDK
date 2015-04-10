package com.backendless.common
{
  public class PermissionTypes
  {
    public static const GRANT:PermissionTypes = new PermissionTypes( "GRANT" );
    public static const DENY:PermissionTypes = new PermissionTypes( "DENY" );
    private var typeid:String;

    function PermissionTypes( typeid:String ):void
    {
      this.typeid = typeid;
    }

    public function getId():String
    {
      return typeid;
    }
  }
}
