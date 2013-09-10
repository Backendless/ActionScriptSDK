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
 * Date: 2/26/13
 * Time: 5:53 PM
 * To change this template use File | Settings | File Templates.
 */
package com.backendless.flex.examples.chat.domain
{
import com.backendless.flex.examples.chat.domain.ChatMessage;

import mx.collections.ArrayCollection;

import mx.collections.ArrayList;

import mx.collections.IList;

public class Chat
{
    public function Chat()
    {
    }

    private var membersMap:Object = {};

    [Bindable]
    public var currentMember:ChatMember;

    [Bindable]
    public var members:IList = new ArrayList();

    [Bindable]
    [Publish(objectId="messages")]
    public var messages:IList = new ArrayCollection();

    public function addMessage(message:ChatMessage):void
    {
        messages.addItem(message);
    }

    public function addMember(member:ChatMember):Boolean
    {
        if (membersMap[member.subscriptionId])
            return false;

        members.addItem(member);

        membersMap[member.subscriptionId] = member;

        return true;
    }

    public function removeMember(id:String):Boolean
    {
        if (!membersMap[id])
            return false;

        const n:int = members.length;
        for (var i:int = 0; i < n; i++)
        {
            if (members.getItemAt(i).subscriptionId == id)
            {
                members.removeItemAt(i);
                break;
            }
        }

        membersMap[id] = null;

        return true;
    }
}
}
