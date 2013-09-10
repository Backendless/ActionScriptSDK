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
 * Date: 16.02.13
 * Time: 11:45
 * To change this template use File | Settings | File Templates.
 */
package com.backendless.examples.flex.login.presentation
{
import com.backendless.examples.flex.login.domain.vo.Login;
import com.backendless.examples.flex.login.domain.vo.Register;
import com.backendless.examples.flex.login.presentation.validators.LoginVallidators;
import com.backendless.examples.flex.login.presentation.validators.RegisterValidators;

public interface ILoginPM
{
    function get userLogin():Login;
    function set userLogin(value:Login):void;

    function get userRegister():Register;
    function set userRegister(value:Register):void;

    function get loginErrorString():String;
    function set loginErrorString(value:String):void;

    function get registerErrorString():String;
    function set registerErrorString(value:String):void;

    function get isSigningIn():Boolean;
    function set isSigningIn(value:Boolean):void;

    function get isRegistering():Boolean;
    function set isRegistering(value:Boolean):void;

    function get loginValidators():LoginVallidators;
    function set loginValidators(value:LoginVallidators):void;

    function get registerValidators():RegisterValidators;
    function set registerValidators(value:RegisterValidators):void;

    function reset():void;

    function login():void;

    function register():void;

    function logout():void;

    function ok():void;
}
}
