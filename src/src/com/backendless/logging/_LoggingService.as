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
package com.backendless.logging
{
  import com.backendless.helpers.ClassHelper;
  import com.backendless.service.*;
  import com.backendless.Backendless;
  import com.backendless.rpc.BackendlessClient;

  public class _LoggingService extends BackendlessService
  {
    private static const SERVICE_SOURCE:String = "com.backendless.services.logging.LogService";
    private var _buffer:LogBuffer;
    private var loggers:Object;

    public function _LoggingService():void
    {
      _buffer = new LogBuffer();
      loggers = new Object();
    }

    public function setLogReportingPolicy( numOfMessages:int, timeFrequencySec:int ):void
    {
      _buffer.setLogReportingPolicy( numOfMessages, timeFrequencySec );
    }

    public function flush():void
    {
      trace( new Date().toLocaleString() + "  manual flush ");
      _buffer.flush();
      _buffer.resetTimer();
    }

    public function getLogger( loggerName:* ):Logger
    {
       if( loggerName is Class )
         loggerName = ClassHelper.getCanonicalClassName( loggerName );

      if( loggers.hasOwnProperty( loggerName ) )
        return loggers[ loggerName ];

      var logger:Logger = new Logger( loggerName as String );
      loggers[ loggerName ] = logger;
      return logger;
    }

    internal function get buffer():LogBuffer
    {
       return _buffer;
    }

    internal function reportSingleLogMessage( logger:String, loglevel:String, message:String, error:Error = null ):void
    {
      var args:Array = [Backendless.appId, Backendless.version, loglevel, logger, message, error == null ? "" : error.getStackTrace() ];
      BackendlessClient.instance.invoke( SERVICE_SOURCE, "log", args );
    }

    internal function reportBatch( batch:Array ):void
    {
      var args:Array = [Backendless.appId, Backendless.version, batch ];
      BackendlessClient.instance.invoke( SERVICE_SOURCE, "batchLog", args );
    }
  }
}
