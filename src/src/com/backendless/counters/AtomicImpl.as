/**
 * Created by mark on 8/7/14.
 */
package com.backendless.counters
{
  import mx.rpc.AsyncToken;
  import mx.rpc.IResponder;

  public class AtomicImpl implements IAtomic
  {
    private var counterName:String;

    public function AtomicImpl( counterName:String )
    {
      this.counterName = counterName;
    }

    public function reset( responder:IResponder = null ):AsyncToken
    {
      return Counters.getInstance().reset( counterName, responder );
    }

    public function get( responder:IResponder = null ):AsyncToken
    {
      return Counters.getInstance().get( counterName, responder );
    }

    public function getAndIncrement( responder:IResponder = null ):AsyncToken
    {
      return Counters.getInstance().getAndIncrement( counterName, responder );
    }

    public function incrementAndGet( responder:IResponder = null ):AsyncToken
    {
      return Counters.getInstance().incrementAndGet( counterName, responder );;
    }

    public function getAndDecrement( responder:IResponder = null ):AsyncToken
    {
      return Counters.getInstance().getAndDecrement( counterName, responder );
    }

    public function decrementAndGet( responder:IResponder = null ):AsyncToken
    {
      return Counters.getInstance().decrementAndGet( counterName, responder );
    }

    public function addAndGet( value:Number, responder:IResponder = null ):AsyncToken
    {
      return Counters.getInstance().addAndGet( counterName, value, responder );
    }

    public function getAndAdd( value:Number, responder:IResponder = null ):AsyncToken
    {
      return Counters.getInstance().getAndAdd( counterName, value, responder );
    }

    public function compareAndSet( expected:Number, updated:Number, responder:IResponder = null ):AsyncToken
    {
      return Counters.getInstance().compareAndSet( counterName, expected, updated, responder );
    }
  }
}
