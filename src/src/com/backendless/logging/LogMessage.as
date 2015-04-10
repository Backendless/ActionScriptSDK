/**
 * Created by mark on 4/2/15.
 */
package com.backendless.logging
{
  public class LogMessage
  {
    public var timestamp:Date;
    public var message:String;
    public var exception:String;

    public function LogMessage( timestamp:Date, message:String, exception:String ):void
    {
      this.timestamp = timestamp;
      this.message = message;
      this.exception = exception;
    }
  }
}
