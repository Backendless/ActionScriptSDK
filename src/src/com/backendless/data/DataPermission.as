/**
 * Created by mark on 1/21/15.
 */
package com.backendless.data
{
  public class DataPermission extends AbstractDataPermission
  {
    //public const _FIND:Find = new Find();
    //public const _UPDATE:Update = new Update();
    //public const _REMOVE:Remove = new Remove();

    public static function get FIND():Find
    {
      return new Find();
    }

    public static function get UPDATE():Update
    {
      return new Update();
    }

    public static function get REMOVE():Remove
    {
      return new Remove();
    }
  }
}
