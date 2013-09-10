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
 * Time: 8:00 PM
 * To change this template use File | Settings | File Templates.
 */
package com.backendless.flex.examples.chat.domain
{
import com.backendless.flex.examples.chat.domain.ChatMember;

import flash.events.EventDispatcher;

[Bindable]
[RemoteClass(alias="com.backendless.flex.examples.chat.domain.messages.Message")]
public class ChatMessage extends EventDispatcher
{
    public function ChatMessage(type:String)
    {
        super();

        this.type = type;
    }

    public var messageId:String;

    public var timestamp:Number;

    public var member:ChatMember;

    public var type:String;

    public function copy(that:Object):void
    {
        this.messageId = that.messageId;
        this.timestamp = new Date().getTime();
        this.type = that.type;
        this.member = new ChatMember();
        this.member.copy(that.member);
    }

    public function getTime():String
    {
        var date:Date = new Date();
        date.setTime( timestamp );
        return date.toLocaleTimeString();
    }
}
}
