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
 * Time: 2:16 PM
 * To change this template use File | Settings | File Templates.
 */
package com.backendless.flex.examples.chat.application.commands
{
import com.backendless.Backendless;
import com.backendless.flex.examples.chat.application.messages.SayGoodbyeMessage;
import com.backendless.flex.examples.chat.application.messages.SayHelloMessage;
import com.backendless.flex.examples.chat.application.messages.SendMessageMessage;
import com.backendless.flex.examples.chat.domain.Chat;
import com.backendless.flex.examples.chat.domain.enum.MessageHeader;
import com.backendless.flex.examples.chat.domain.enum.MessageType;
import com.backendless.messaging.PublishOptions;

import mx.rpc.Responder;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;

public class SayGoodbyeCommand
{
    public function SayGoodbyeCommand()
    {
        super();
    }

    [MessageDispatcher]
    public var dispatcher:Function;

    [Inject]
    public var chat:Chat;

    public function execute(msg:SayGoodbyeMessage):void
    {
        const options:PublishOptions = new PublishOptions();
        options.publisherId = chat.currentMember.subscriptionId;

        Backendless.Messaging.publish(chat.currentMember, options);
    }
}
}
