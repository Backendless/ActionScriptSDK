package com.backendless.messaging
{
  import mx.collections.ArrayCollection;
  import mx.rpc.events.FaultEvent;

  public class SubscriptionResponder implements ISubscriptionResponder
  {
    private var _resultHandler:Function;
    private var _faultHandler:Function;

    public function SubscriptionResponder( result:Function, fault:Function )
    {
      _resultHandler = result;
      _faultHandler = fault;
    }

    public function received( messages:ArrayCollection ):void
    {
      _resultHandler( messages );
    }

    public function error( error:FaultEvent ):void
    {
      _faultHandler( error );
    }
  }
}
