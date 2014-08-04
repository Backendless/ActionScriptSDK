/**
 * Created by mark on 7/30/14.
 */
package com.backendless.cache
{
  import com.backendless.Backendless;
  import com.backendless.rpc.BackendlessClient;

  import flash.utils.ByteArray;

  import mx.rpc.AsyncToken;
  import mx.rpc.Fault;
  import mx.rpc.IResponder;
  import mx.rpc.Responder;
  import mx.rpc.events.FaultEvent;
  import mx.rpc.events.ResultEvent;

  public class Cache
  {
    private static const CACHE_SERVER_ALIAS:String = "com.backendless.services.redis.CacheService";

    private static const instance:Cache = new Cache();

    public static function getInstance():Cache
    {
      return instance;
    }

    function Cache()
    {
    }

    public function forKey( key:String ):ICache
    {
      return new CacheService( key );
    }

    public function put( key:String, object:Object, expire:int = 0, responder:IResponder = null ):AsyncToken
    {
      if( object == null )
      {
         if( responder != null )
          responder.fault( new FaultEvent( FaultEvent.FAULT, false, true, new Fault( null, "object to store in cache cannot be null" )) );

        return null;
      }

      var byteArray:ByteArray = new ByteArray();
      byteArray.writeObject( object );
      var asyncToken:AsyncToken = BackendlessClient.instance.invoke( CACHE_SERVER_ALIAS, "putBytes", [Backendless.appId, Backendless.version, key, byteArray, expire ] );

      if( responder != null )
        asyncToken.addResponder( responder );

      return asyncToken;
    }

    public function get( key:String, responder:IResponder ):void
    {
      var getBytesResponder:IResponder = new Responder( function ( evt:ResultEvent ):void
                                                        {
                                                          var result:Object = null;
                                                          var bytes:ByteArray = evt.result as ByteArray;

                                                          if( bytes != null )
                                                            result = bytes.readObject();

                                                          var resultEvent:ResultEvent = new ResultEvent( ResultEvent.RESULT, false, true, result );
                                                          responder.result( resultEvent );
                                                        },
                                                        function ( evt:FaultEvent ):void
                                                        {
                                                          responder.fault( evt );
                                                        } );

      BackendlessClient.instance.invoke( CACHE_SERVER_ALIAS, "getBytes", [Backendless.appId, Backendless.version, key ], getBytesResponder );
    }

    public function contains( key:String, responder:IResponder = null ):AsyncToken
    {
      var asyncToken:AsyncToken = BackendlessClient.instance.invoke( CACHE_SERVER_ALIAS, "containsKey", [Backendless.appId, Backendless.version, key ] );

      if( responder != null )
        asyncToken.addResponder( responder );

      return asyncToken;
    }

    public function expireIn( key:String, seconds:int, responder:IResponder = null ):AsyncToken
    {
      var asyncToken:AsyncToken = BackendlessClient.instance.invoke( CACHE_SERVER_ALIAS, "expireIn", [Backendless.appId, Backendless.version, key, seconds ] );

      if( responder != null )
        asyncToken.addResponder( responder );

      return asyncToken;
    }

    public function expireAt( key:String, timestamp:Number, responder:IResponder = null ):AsyncToken
    {
      var asyncToken:AsyncToken = BackendlessClient.instance.invoke( CACHE_SERVER_ALIAS, "expireAt", [Backendless.appId, Backendless.version, key, timestamp / 1000 ] );

      if( responder != null )
        asyncToken.addResponder( responder );

      return asyncToken;
    }


    public function remove( key:String, responder:IResponder = null ):AsyncToken
    {
      var asyncToken:AsyncToken = BackendlessClient.instance.invoke( CACHE_SERVER_ALIAS, "delete", [Backendless.appId, Backendless.version, key ] );

      if( responder != null )
        asyncToken.addResponder( responder );

      return asyncToken;
    }
  }
}
