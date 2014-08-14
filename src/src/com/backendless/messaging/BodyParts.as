/**
 * Created by mark on 8/14/14.
 */
package com.backendless.messaging
{
  public class BodyParts
  {
    public var textMessage:String;
    public var htmlMessage:String;

    public function BodyParts( textMessage:String, htmlMessage:String )
    {
      this.textMessage = textMessage;
      this.htmlMessage = htmlMessage;
    }
  }
}
