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
 * User: max
 * Date: 17.02.13
 * Time: 13:12
 * To change this template use File | Settings | File Templates.
 */
package com.backendless.examples.flex.login.application.commands
{
import com.backendless.Backendless;
import com.backendless.examples.flex.logging.Logger;
import com.backendless.examples.flex.login.application.enum.Destination;
import com.backendless.examples.flex.login.application.messages.LogoutMessage;
import com.backendless.examples.flex.login.application.messages.NavigateToMessage;

import mx.rpc.AsyncToken;
import mx.rpc.Fault;

public class LogoutCommand
    {
        public function LogoutCommand()
        {
        }

        [MessageDispatcher]
        public var dispatcher:Function

        public function execute(msg:LogoutMessage):AsyncToken
        {
            return Backendless.UserService.logout();
        }

        public function result(user:Object):void
        {
            Logger.info("Logout success");

            dispatcher(new NavigateToMessage(Destination.LOGIN));
        }

        public function error(fault:Fault):void
        {
            // handled at presentation level

            Logger.error(fault.faultString);
        }

    }
}