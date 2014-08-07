/**
 * Created by mark on 7/31/14.
 */
package com.backendless.cache
{
  import mx.rpc.AsyncToken;
  import mx.rpc.IResponder;

  public class CacheService implements ICache
  {
    private var key:String;

    public function CacheService( key:String )
    {
      this.key = key;
    }

    public function put( value:Object, expire:int = 0, responder:IResponder = null ):AsyncToken
    {
      return Cache.getInstance().put( key, value, expire, responder );
    }

    public function get( responder:IResponder = null ):void
    {
      Cache.getInstance().get( key, responder );
    }

    public function contains( responder:IResponder = null ):AsyncToken
    {
      return Cache.getInstance().contains( key, responder );
    }

    public function expireIn( seconds:int, responder:IResponder = null ):AsyncToken
    {
      return Cache.getInstance().expireIn( key, seconds, responder );
    }

    public function expireAt( timestamp:int, responder:IResponder = null ):AsyncToken
    {
      return Cache.getInstance().expireAt( key, timestamp, responder );
    }

    public function remove( responder:IResponder = null ):AsyncToken
    {
      return Cache.getInstance().remove( key, responder );
    }
  }
}
