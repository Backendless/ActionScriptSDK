/**
 * Created by mark on 4/2/15.
 */
package com.backendless.logging
{
  import com.backendless.Backendless;

  public class Logger
  {
    private var loggerName:String;
    private var buffer:LogBuffer;

    public function Logger( loggerName:String )
    {
      this.loggerName = loggerName;
      this.buffer = Backendless.Logging.buffer;
    }

    public function trace( message:String ):void
    {
      buffer.enqueue( loggerName, "TRACE", message );
    }

    public function debug( message:String ):void
    {
      buffer.enqueue( loggerName, "DEBUG", message );
    }

    public function info( message:String ):void
    {
      buffer.enqueue( loggerName, "INFO", message );
    }

    public function warn( message:String, exception:Error = null ):void
    {
      buffer.enqueue( loggerName, "WARN", message, exception );
    }

    public function error( message:String, exception:Error = null ):void
    {
      buffer.enqueue( loggerName, "ERROR", message, exception );
    }

    public function fatal( message:String, exception:Error = null ):void
    {
      buffer.enqueue( loggerName, "FATAL", message, exception );
    }
  }
}
