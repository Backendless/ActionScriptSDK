/*
 * Copyright (C) 2013 max.rozdobudko@gmail.com
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

/**
 * Created with IntelliJ IDEA.
 * User: Max
 * Date: 2/28/13
 * Time: 10:28 AM
 * To change this template use File | Settings | File Templates.
 */
package com.backendless.flex.examples.chat.application.helpers
{
import com.backendless.examples.flex.logging.Logger;
import com.backendless.flex.examples.chat.domain.ChatMember;
import com.backendless.flex.examples.chat.domain.ChatMessage;
import com.backendless.flex.examples.chat.domain.messages.GoodbyeMessage;
import com.backendless.flex.examples.chat.domain.messages.HelloMessage;
import com.backendless.flex.examples.chat.domain.messages.TextMessage;
import com.backendless.messaging.Message;

public class MessageHelper
{
    public static function convertChatMessage(source:Message):ChatMessage
    {
        var message:ChatMessage;

        if( (source.data as Object).hasOwnProperty( "type" ) )
        {
            switch (source.data.type)
            {
                case HelloMessage.TYPE :
                    message = new HelloMessage();
                    break;

                case GoodbyeMessage.TYPE :
                    message = new GoodbyeMessage();
                    break;

                case TextMessage.TYPE :
                    message = new TextMessage();
                    break;

                default :
                    Logger.print("{0} {1}: '{2}'", "[WARNING]", "Unknown message type", source.data.type);
                    break;
            }

            message.copy(source.data);
        }
        else
        {
            message = createChatMessage( source.data );
            message.member = new ChatMember();
            message.member.name = source.publisherId;
            message.timestamp = new Date().getTime();
        }

        return message;
    }

    public static function createChatMessage(source:Object):ChatMessage
    {
        var message:ChatMessage;

        if (source is String /* is plain text */)
        {
            message = new TextMessage();
            TextMessage(message).text = source as String;
        }

        return message;
    }
}
}
