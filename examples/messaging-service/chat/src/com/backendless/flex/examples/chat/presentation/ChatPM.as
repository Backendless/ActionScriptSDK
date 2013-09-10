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
 * Time: 7:40 PM
 * To change this template use File | Settings | File Templates.
 */
package com.backendless.flex.examples.chat.presentation
{
import com.backendless.flex.examples.chat.application.messages.LeaveChatMessage;
import com.backendless.flex.examples.chat.application.messages.SendMessageMessage;
import com.backendless.flex.examples.chat.domain.messages.SystemMessage;
import com.backendless.flex.examples.chat.domain.messages.TextMessage;
import com.backendless.flex.examples.chat.presentation.renderers.SystemMessageRenderer;
import com.backendless.flex.examples.chat.presentation.renderers.TextMessageRenderer;

import flash.events.EventDispatcher;

import mx.collections.IList;
import mx.core.ClassFactory;
import mx.core.IFactory;

import spark.skins.spark.DefaultItemRenderer;

public class ChatPM extends EventDispatcher implements IChatPM
{
    public function ChatPM()
    {
        super();
    }

    [MessageDispatcher]
    public var dispatcher:Function;

    [Bindable]
    [Subscribe(objectId="messages")]
    public var messages:IList;

    [Bindable]
    public var message:String;

    public function messageRendererFunction(item:Object):IFactory
    {
        if (item is TextMessage)
            return new ClassFactory(TextMessageRenderer);

        if (item is SystemMessage)
            return new ClassFactory(SystemMessageRenderer);

        return new ClassFactory(DefaultItemRenderer);
    }

    public function clear():void
    {
        this.message = null;
    }

    public function send():void
    {
        if (!this.message)
            return;

        dispatcher(new SendMessageMessage(this.message));

        this.clear();
    }

    public function leave():void
    {
        dispatcher(new LeaveChatMessage());
    }
}
}
