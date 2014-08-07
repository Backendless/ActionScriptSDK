/**
 * Created by mark on 8/7/14.
 */
package com.backendless.counters
{
  import com.backendless.Backendless;
  import com.backendless.rpc.BackendlessClient;

  import mx.rpc.AsyncToken;
  import mx.rpc.IResponder;

  public class Counters
  {
    private static const COUNTERS_SERVER_ALIAS:String = "com.backendless.services.redis.AtomicOperationService";

    private static const instance:Counters = new Counters();

    public static function getInstance():Counters
    {
      return instance;
    }

    function Counters()
    {
    }

    public function of( counterName:String ):IAtomic
    {
      return new AtomicImpl( counterName );
    }

    public function reset( counterName:String, responder:IResponder = null ):AsyncToken
    {
      var asyncToken:AsyncToken = BackendlessClient.instance.invoke( COUNTERS_SERVER_ALIAS, "reset", [Backendless.appId, Backendless.version, counterName ] );

      if( responder != null )
        asyncToken.addResponder( responder );

      return asyncToken;
    }

    public function get( counterName:String, responder:IResponder = null ):AsyncToken
    {
      var asyncToken:AsyncToken = BackendlessClient.instance.invoke( COUNTERS_SERVER_ALIAS, "get", [Backendless.appId, Backendless.version, counterName ] );

      if( responder != null )
        asyncToken.addResponder( responder );

      return asyncToken;
    }

    public function getAndIncrement( counterName:String, responder:IResponder = null ):AsyncToken
    {
      var asyncToken:AsyncToken = BackendlessClient.instance.invoke( COUNTERS_SERVER_ALIAS, "getAndIncrement", [Backendless.appId, Backendless.version, counterName ] );

      if( responder != null )
        asyncToken.addResponder( responder );

      return asyncToken;
    }

    public function incrementAndGet( counterName:String, responder:IResponder = null ):AsyncToken
    {
      var asyncToken:AsyncToken = BackendlessClient.instance.invoke( COUNTERS_SERVER_ALIAS, "incrementAndGet", [Backendless.appId, Backendless.version, counterName ] );

      if( responder != null )
        asyncToken.addResponder( responder );

      return asyncToken;
    }

    public function getAndDecrement( counterName:String, responder:IResponder = null ):AsyncToken
    {
      var asyncToken:AsyncToken = BackendlessClient.instance.invoke( COUNTERS_SERVER_ALIAS, "getAndDecrement", [Backendless.appId, Backendless.version, counterName ] );

      if( responder != null )
        asyncToken.addResponder( responder );

      return asyncToken;
    }

    public function decrementAndGet( counterName:String, responder:IResponder = null ):AsyncToken
    {
      var asyncToken:AsyncToken = BackendlessClient.instance.invoke( COUNTERS_SERVER_ALIAS, "decrementAndGet", [Backendless.appId, Backendless.version, counterName ] );

      if( responder != null )
        asyncToken.addResponder( responder );

      return asyncToken;
    }

    public function addAndGet( counterName:String, value:Number, responder:IResponder = null ):AsyncToken
    {
      var asyncToken:AsyncToken = BackendlessClient.instance.invoke( COUNTERS_SERVER_ALIAS, "addAndGet", [Backendless.appId, Backendless.version, counterName, value ] );

      if( responder != null )
        asyncToken.addResponder( responder );

      return asyncToken;
    }

    public function getAndAdd( counterName:String, value:Number, responder:IResponder = null ):AsyncToken
    {
      var asyncToken:AsyncToken = BackendlessClient.instance.invoke( COUNTERS_SERVER_ALIAS, "getAndAdd", [Backendless.appId, Backendless.version, counterName, value ] );

      if( responder != null )
        asyncToken.addResponder( responder );

      return asyncToken;
    }

    public function compareAndSet( counterName:String, expected:Number, updated:Number, responder:IResponder = null ):AsyncToken
    {
      var asyncToken:AsyncToken = BackendlessClient.instance.invoke( COUNTERS_SERVER_ALIAS, "compareAndSet", [Backendless.appId, Backendless.version, counterName, expected, updated ] );

      if( responder != null )
        asyncToken.addResponder( responder );

      return asyncToken;
    }
  }
}
