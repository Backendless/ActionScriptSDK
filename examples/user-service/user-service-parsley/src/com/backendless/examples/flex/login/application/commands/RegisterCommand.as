/*
 * Copyright (C) 2013 max.rozdobudko@gmail.com
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

package com.backendless.examples.flex.login.application.commands
{
import com.backendless.Backendless;
import com.backendless.BackendlessUser;
import com.backendless.examples.flex.logging.Logger;
import com.backendless.examples.flex.login.application.enum.Destination;
import com.backendless.examples.flex.login.application.messages.NavigateToMessage;
import com.backendless.examples.flex.login.application.messages.RegisterMessage;
import com.backendless.examples.flex.login.domain.Model;

import mx.rpc.AsyncToken;
import mx.rpc.Fault;

public class RegisterCommand
{
    public function RegisterCommand()
    {
        super();
    }

    [MessageDispatcher]
    public var dispatcher:Function;

    [Inject]
    public var model:Model;

    public function execute(msg:RegisterMessage):AsyncToken
    {
        const user:BackendlessUser = new BackendlessUser();
        user.password = msg.register.password;
        user.setProperty("email", msg.register.email);
        user.setProperty("name", msg.register.name);

	    return Backendless.UserService.register(user);
    }


    public function result(data:Object):void
    {
        Logger.info("Register success");

        model.setUser(Backendless.UserService.currentUser);

        dispatcher(new NavigateToMessage(Destination.CHECKMAIL));
    }

    public function error(fault:Fault):void
    {
        // handled at presentation layer

        Logger.error(fault.toString());
    }
}
}