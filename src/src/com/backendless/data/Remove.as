/**
 * Created by mark on 1/21/15.
 */
package com.backendless.data
{
  public class Remove extends AbstractDataPermission
    {
      protected override function getOperation():PersistenceOperation
      {
        return new PersistenceOperation( "REMOVE" );
      }
    }
}
