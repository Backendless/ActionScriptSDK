package com.backendless.data
{
  public class PersistenceOperation extends AbstractDataPermission
  {
/*    public const FIND:PersistenceOperation = new PersistenceOperation( 0 );
    public const UPDATE:PersistenceOperation = new PersistenceOperation( 1 );
    public const REMOVE:PersistenceOperation = new PersistenceOperation( 2 );     */

    private var typeid:String;

    function PersistenceOperation( typeid:String ):void
    {
      this.typeid = typeid;
    }

    public function getId():String
    {
      return typeid;
    }
  }
}
