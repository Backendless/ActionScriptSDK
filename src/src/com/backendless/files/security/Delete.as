/**
 * Created by mark on 4/7/15.
 */
package com.backendless.files.security
{
  public class Delete extends AbstractFilesPermission
    {
      protected override function getOperation():FileOperation
      {
        return new FileOperation( "DELETE" );
      }
    }
}
