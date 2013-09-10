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
 * Time: 12:41
 * To change this template use File | Settings | File Templates.
 */
package com.backendless.examples.flex.login.presentation
{
import com.backendless.examples.flex.login.application.enum.Destination;
import com.backendless.examples.flex.login.application.messages.LoginMessage;
import com.backendless.examples.flex.login.application.messages.LogoutMessage;
import com.backendless.examples.flex.login.application.messages.NavigateToMessage;
import com.backendless.examples.flex.login.application.messages.RegisterMessage;
import com.backendless.examples.flex.login.domain.vo.Login;
import com.backendless.examples.flex.login.domain.vo.Register;
import com.backendless.examples.flex.login.presentation.validators.LoginVallidators;
import com.backendless.examples.flex.login.presentation.validators.RegisterValidators;

import mx.rpc.Fault;

public class LoginPM implements ILoginPM
    {
        public function LoginPM()
        {
            super();

            reset();

            loginValidators = new LoginVallidators();
            loginValidators.model = this;
            loginValidators.initialized(this,  "loginValidators");
            loginValidators.validate(true);

            registerValidators = new RegisterValidators();
            registerValidators.model = this;
            registerValidators.initialized(this,  "registerValidators");
            registerValidators.validate(true);
        }

        //---------------------------------------------------------------------
        //
        //  Variables
        //
        //---------------------------------------------------------------------

        [MessageDispatcher]
        public var dispatcher:Function;

        //---------------------------------------------------------------------
        //
        //  Properties
        //
        //---------------------------------------------------------------------

        //--------------------------------
        //  Properties: ILoginPM
        //--------------------------------

        [Bindable]
        public var userLogin:Login;

        [Bindable]
        public var userRegister:Register;

        [Bindable]
        public var loginErrorString:String;

        [Bindable]
        public var registerErrorString:String;

        [Bindable]
        [CommandStatus(type="com.backendless.examples.flex.login.application.messages.LoginMessage")]
        public var isSigningIn:Boolean;

        [Bindable]
        [CommandStatus(type="com.backendless.examples.flex.login.application.messages.RegisterMessage")]
        public var isRegistering:Boolean;

        [Bindable]
        public var loginValidators:LoginVallidators;

        [Bindable]
        public var registerValidators:RegisterValidators;

        //---------------------------------------------------------------------
        //
        //  Methods
        //
        //---------------------------------------------------------------------

        public function reset():void
        {
            this.userLogin = new Login();

            this.userRegister = new Register();
        }

        public function login():void
        {
            if (!loginValidators.validate())
                return;

            dispatcher(new LoginMessage(userLogin));
        }

        public function logout():void
        {
            dispatcher(new LogoutMessage());
        }

        public function register():void
        {
            if (!registerValidators.validate())
                return;

            dispatcher(new RegisterMessage(userRegister));
        }

        public function ok():void
        {
            reset();

            dispatcher(new NavigateToMessage(Destination.LOGIN));
        }

        [CommandError(type="com.backendless.examples.flex.login.application.messages.LoginMessage")]
        public function loginError(fault:Fault, trigger:LoginMessage):void
        {
            this.loginErrorString = fault.faultString;
        }

        [CommandError(type="com.backendless.examples.flex.login.application.messages.RegisterMessage")]
        public function registerError(fault:Fault, trigger:RegisterMessage):void
        {
            this.registerErrorString = fault.faultString;
        }
    }
}
