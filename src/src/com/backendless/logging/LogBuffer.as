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
    private var logBatches:Object;
    private var messageCount:int;
    private var mutex:Mutex;
    private var timer:Timer;

    function LogBuffer()
    {
      mutex = new Mutex();
      numOfMessages = 100;
      timeFrequency = 1000 * 60 * 5; // 5 minutes
      logBatches = new Object();
      messageCount = 0;
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
        ArgumentValidator.greaterThanZero( timeFrequency, "The timeFrequency argument must be a positive value" );

      this.numOfMessages = numOfMessages;
      this.timeFrequency = timeFrequency;
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

        if( logBatches.hasOwnProperty( logger ) )
        {
          logLevels = logBatches[ logger ];
        }
        else
        {
          logLevels = new Object();
          logBatches[ logger ] = logLevels;
        }

        if( logLevels.hasOwnProperty( logLevel ) )
        {
          messages = logLevels[ logLevel ] as LinkedList;
        }
        else
        {
          messages = new LinkedList();
          logLevels[ logLevel ] = messages;
        }

        messages.push( new LogMessage( new Date(), message, error.getStackTrace() ) );
        messageCount++;

        if( messageCount == numOfMessages )
          flush();

        mutex.unlock();
      }
    }

    private function flush():void
    {
      var allMessages:Array = [];

      for( var logger:String in logBatches )
      {
        var messages:Object = logBatches[ logger ];

        for( var logLevel:String in messages )
        {
          var logBatch:LogBatch = new LogBatch();
          logBatch.logger = logger;
          logBatch.logLevel = logLevel;
          logBatch.messages = messages[ logLevel ];
          allMessages.push( logBatch );
          delete messages[ logLevel ];
        }

        delete logBatches[ logger ];
      }

      Backendless.Logging.reportBatch( allMessages );
    }

    public function flushMessages(event:TimerEvent):void
    {
      mutex.lock();
      flush();
      mutex.unlock();
    }
  }
}
