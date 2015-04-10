/**
 * Created by mark on 4/7/15.
 */
package com.backendless.files.security
{
  public class FileOperation extends AbstractFilesPermission
  {
    private var typeid:String;

    function FileOperation( typeid:String ):void
    {
      this.typeid = typeid;
    }

    public function getId():String
    {
      return typeid;
    }
  }
}
