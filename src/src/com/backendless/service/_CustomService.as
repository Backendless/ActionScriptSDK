/**
 * Created with IntelliJ IDEA.
 * User: Eugene Chipachenko
 * Date: 09.06.2015
 * Time: 16:36
 */
package com.backendless.service
{
import com.backendless.Backendless;
import com.backendless.rpc.BackendlessClient;

import mx.rpc.AsyncToken;
import mx.rpc.IResponder;

public class _CustomService
{
    private static const CUSTOM_SERVICE_ALIAS:String = "com.backendless.services.servercode.CustomServiceHandler";
    private static const METHOD_NAME_ALIAS:String = "dispatchService";

    public function _CustomService()
    {
    }

    public function invoke( serviceName:String, serviceVersion:String, method:String, arguments:Array,
                            responder:IResponder = null ):AsyncToken
    {
        var asyncToken:AsyncToken = BackendlessClient.instance.invoke( CUSTOM_SERVICE_ALIAS, METHOD_NAME_ALIAS, [Backendless.appId, Backendless.version, serviceName, serviceVersion, method, arguments] );
        if( responder != null )
            asyncToken.addResponder( responder );

        return asyncToken;
    }

}
}
