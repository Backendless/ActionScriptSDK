/**
 * Created by mark on 9/4/14.
 */
package com.backendless.rpc
{
  import com.backendless.Backendless;

  import mx.rpc.AsyncToken;
  import mx.rpc.IResponder;

  public class BaseService
  {
    private static var SERVICE_NAME:String = "com.backendless.services.servercode.CustomServiceHandler";

    public function invoke(  serviceName:String, serviceVersion:String, methodName:String, responder:IResponder, ... methodArgs ):AsyncToken
    {
      methodArgs.unshift( methodName );
      methodArgs.unshift( serviceVersion );
      methodArgs.unshift( serviceName );
      methodArgs.unshift( Backendless.version );
      methodArgs.unshift( Backendless.appId );


      var asyncToken:AsyncToken = BackendlessClient.instance.invoke( SERVICE_NAME, "dispatchService", methodArgs );

      if( responder != null )
        asyncToken.addResponder( responder );

      return asyncToken;
    }
  }
}
