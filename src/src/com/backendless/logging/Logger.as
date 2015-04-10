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

    public function debug( message:String ):void
    {
      buffer.enqueue( loggerName, "debug", message );
    }

    public function info( message:String ):void
    {
      buffer.enqueue( loggerName, "info", message );
    }

    public function warn( message:String, exception:Error = null ):void
    {
      buffer.enqueue( loggerName, "warn", message, exception );
    }

    public function error( message:String, exception:Error = null ):void
    {
      buffer.enqueue( loggerName, "error", message, exception );
    }

    public function fatal( message:String, exception:Error = null ):void
    {
      buffer.enqueue( loggerName, "fatal", message, exception );
    }
  }
}
