/**
 * Created by mark on 8/7/14.
 */
package com.backendless.counters
{
  import mx.rpc.AsyncToken;
  import mx.rpc.IResponder;

  public interface IAtomic
  {
    function reset( responder:IResponder = null ):AsyncToken;

    function get( responder:IResponder = null ):AsyncToken;

    function getAndIncrement( responder:IResponder = null ):AsyncToken;

    function incrementAndGet( responder:IResponder = null ):AsyncToken;

    function getAndDecrement( responder:IResponder = null ):AsyncToken;

    function decrementAndGet( responder:IResponder = null ):AsyncToken;

    function addAndGet( value:Number, responder:IResponder = null ):AsyncToken;

    function getAndAdd( value:Number, responder:IResponder = null ):AsyncToken;

    function compareAndSet( expected:Number, updated:Number, responder:IResponder = null ):AsyncToken;
  }
}
