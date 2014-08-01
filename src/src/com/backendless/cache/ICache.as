/**
 * Created by mark on 7/30/14.
 */
package com.backendless.cache
{
  import mx.rpc.AsyncToken;
  import mx.rpc.IResponder;

  public interface ICache
  {
    function put( value:Object, expire:int = 0, responder:IResponder = null ) : AsyncToken

    function get( responder:IResponder = null ):void;

    function contains( responder:IResponder = null ) : AsyncToken;

    function extendLife( seconds:int, responder:IResponder = null ) : AsyncToken;

    function remove( responder:IResponder = null ) : AsyncToken;
  }
}
