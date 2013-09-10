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
 * Date: 2/22/13
 * Time: 1:47 PM
 * To change this template use File | Settings | File Templates.
 */
package com.backendless.examples.flex.logging
{
import flash.events.Event;
import flash.events.EventDispatcher;

import mx.utils.StringUtil;

public class Logger extends EventDispatcher
{
    private static const MAX_LOGS:int = 50;

    private static var instance:Logger = new Logger();

    public static function get get():Logger
    {
        return instance;
    }

    public static function print(msg:String, ...rest):void
    {
        msg = StringUtil.substitute(msg, rest);

        if (instance.logs.length >= MAX_LOGS)
            instance.logs.shift();

        instance.logs.push(msg);

        instance.dispatchEvent(new Event("logsChange"));
    }

    public static function info(msg:String):void
    {
        print("{0} {1}", "[INFO]", msg);
    }

    public static function error(msg:String):void
    {
        print("{0} {1}", "[ERROR]", msg);
    }

    public static function clear():void
    {
        get.logs = [];

        instance.dispatchEvent(new Event("logsChange"));
    }

    function Logger()
    {
        super();
    }

    private var logs:Array = [];

    [Bindable(event="logsChange")]
    public function get hasErrors():Boolean
    {
        for each (var log:String in logs)
        {
            if (log.indexOf("[ERROR]") != -1) {
                return true;
            }
        }

        return false;
    }

    [Bindable(event="logsChange")]
    public function get out():String
    {
        return logs.join("\n");
    }
}
}
