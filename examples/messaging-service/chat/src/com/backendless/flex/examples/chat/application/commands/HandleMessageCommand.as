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
 * Date: 2/27/13
 * Time: 2:08 PM
 * To change this template use File | Settings | File Templates.
 */
package com.backendless.flex.examples.chat.application.commands
{
import com.backendless.examples.flex.logging.Logger;
import com.backendless.flex.examples.chat.application.helpers.MessageHelper;
import com.backendless.flex.examples.chat.application.messages.HandleGoodbyeMessage;
import com.backendless.flex.examples.chat.application.messages.HandleHelloMessage;
import com.backendless.flex.examples.chat.application.messages.HandleMessageMessage;
import com.backendless.flex.examples.chat.application.messages.HandleTextMessage;
import com.backendless.flex.examples.chat.domain.Chat;
import com.backendless.flex.examples.chat.domain.ChatMember;
import com.backendless.flex.examples.chat.domain.enum.MessageHeader;
import com.backendless.flex.examples.chat.domain.messages.GoodbyeMessage;
import com.backendless.flex.examples.chat.domain.messages.HelloMessage;
import com.backendless.flex.examples.chat.domain.ChatMessage;
import com.backendless.flex.examples.chat.domain.messages.TextMessage;

public class HandleMessageCommand
{
    public function HandleMessageCommand()
    {
        super();
    }

    [MessageDispatcher]
    public var dispatcher:Function;

    [Inject]
    public var chat:Chat;

    public function execute(msg:HandleMessageMessage):void
    {
        const  message:ChatMessage = MessageHelper.convertChatMessage(msg.message);

        // if the "member" field is null, the message is published from the console
        if( message.member != null )
            message.member.isCurrent =  message.member.subscriptionId == chat.currentMember.subscriptionId;

        if (message is HelloMessage)
        {
            dispatcher(new HandleHelloMessage(message as HelloMessage));
        }
        else if (message is GoodbyeMessage)
        {
            dispatcher(new HandleGoodbyeMessage(message as GoodbyeMessage));
        }
        else if (message is TextMessage)
        {
            dispatcher(new HandleTextMessage(message as TextMessage));
        }
    }
}
}
