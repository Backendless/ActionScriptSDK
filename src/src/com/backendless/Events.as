/*
* ********************************************************************************************************************
*
*  BACKENDLESS.COM CONFIDENTIAL
*
* ********************************************************************************************************************
*
*   Copyright 2012 BACKENDLESS.COM. All Rights Reserved.
*
*  NOTICE:  All information contained herein is, and remains the property of Backendless.com and its suppliers,
*  if any.  The intellectual and technical concepts contained herein are proprietary to Backendless.com and its
*  suppliers and may be covered by U.S. and Foreign Patents, patents in process, and are protected by trade secret
*  or copyright law. Dissemination of this information or reproduction of this material is strictly forbidden
*  unless prior written permission is obtained from Backendless.com.
*
* *******************************************************************************************************************
*/
package com.backendless
{
  import com.backendless.rpc.BackendlessClient;

  import mx.rpc.AsyncToken;
  import mx.rpc.IResponder;
  import mx.rpc.Responder;
  import mx.rpc.events.FaultEvent;
  import mx.rpc.events.ResultEvent;

  public class Events
  {
    private static var EVENTS_MANAGER_SERVER_ALIAS:String = "com.backendless.services.servercode.EventHandler";
    private static var instance:Events = new Events();

    function Events()
    {
    }

    public static function getInstance():Events
    {
      return instance;
    }

    public function dispatch( eventName:String, eventArgs:Object, responder:IResponder ):AsyncToken
    {
      var token:AsyncToken = BackendlessClient.instance.invoke( EVENTS_MANAGER_SERVER_ALIAS, "dispatchEvent", [
        Backendless.appId, Backendless.version, eventName, eventArgs
      ] );

      if( responder != null )
        token.addResponder( new Responder( function ( event:ResultEvent ):void
                                           {
                                             responder.result( event );
                                           }, function ( event:FaultEvent ):void
                                           {
                                             onFault( event, responder );
                                           } ) );

      return token;
    }

    private function onFault( event:FaultEvent, responder:IResponder ):void
    {
      if( responder != null )
        responder.fault( event );

     // dispatchEvent( event );
    }
  }
}
