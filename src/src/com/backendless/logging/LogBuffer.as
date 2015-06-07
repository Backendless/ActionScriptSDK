/**
 * Created by mark on 4/2/15.
 */
package com.backendless.logging
{
  import com.backendless.Backendless;
  import com.backendless.validators.ArgumentValidator;

  import flash.concurrent.Mutex;
  import flash.events.TimerEvent;
  import flash.utils.Timer;

  import mx.utils.LinkedList;

  public class LogBuffer
  {
    private var numOfMessages:int;
    private var timeFrequency:int;
    private var logBatch:LinkedList;
    private var mutex:Mutex;
    private var timer:Timer;

    function LogBuffer()
    {
      mutex = new Mutex();
      numOfMessages = 100;
      timeFrequency = 1000 * 60 * 5; // 5 minutes
      logBatch = new LinkedList();
      setupTimer();
    }

    public function setupTimer():void
    {
      if( timer != null )
        timer.stop();

      if( numOfMessages > 1 )
      {
        timer = new Timer( timeFrequency );
        timer.addEventListener( TimerEvent.TIMER, flushMessages );
        timer.start();
      }
    }

    public function setLogReportingPolicy( numOfMessages:int, timeFrequency:int ):void
    {
      if( numOfMessages > 1 )
        ArgumentValidator.greaterThanZero( timeFrequency, "The timeFrequencySec argument must be a positive value" );

      this.numOfMessages = numOfMessages;
      this.timeFrequency = timeFrequency * 1000;
      setupTimer();
    }

    internal function enqueue( logger:String, logLevel:String, message:String, error:Error = null ):void
    {
      if( numOfMessages == 1 )
      {
        Backendless.Logging.reportSingleLogMessage( logger, logLevel, message, error );
      }
      else
      {
        var logLevels:Object;
        var messages:LinkedList;

        mutex.lock();

        var logMessage:LogMessage = new LogMessage();
        logMessage.timestamp = new Date();
        logMessage.message = message;
        logMessage.exception = error == null ? null : error.getStackTrace();
        logMessage.level = logLevel;
        logMessage.logger = logger;
        logBatch.push( logMessage );

        if( logBatch.length == numOfMessages )
        {
          trace( new Date().toLocaleString() + "  buffer full - flush " + logBatch.length );
          flush();
          resetTimer();
        }

        mutex.unlock();
      }
    }

    internal function resetTimer():void
    {
      timer.reset();
      timer.start();
    }

    internal function flush():void
    {
      if( logBatch.length == 0 )
        return;

      var messages:Array = new Array();

      while( logBatch.length != 0 )
        messages.push( logBatch.shift().value )

      Backendless.Logging.reportBatch( messages );
    }

    public function flushMessages(event:TimerEvent):void
    {
      trace( new Date().toLocaleString() + "  timer event - flush " + logBatch.length );

      mutex.lock();
      flush();
      mutex.unlock();
    }
  }
}
