/**
 * Created by mark on 4/7/15.
 */
package com.backendless.files.security
{
  public class FilePermission extends AbstractFilesPermission
  {
    public static function get READ():Read
    {
      return new Read();
    }

    public static function get DELETE():Delete
    {
      return new Delete();
    }

    public static function get WRITE():Write
    {
      return new Write();
    }

    public static function get PERMISSION():Permission
    {
      return new Permission();
    }
  }
}
