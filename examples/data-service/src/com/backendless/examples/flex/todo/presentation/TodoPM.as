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
 * Date: 18.02.13
 * Time: 08:37
 * To change this template use File | Settings | File Templates.
 */
package com.backendless.examples.flex.todo.presentation
{
import com.backendless.examples.flex.todo.application.messages.AddTodoMessage;
import com.backendless.examples.flex.todo.application.messages.CheckTodoMessage;
import com.backendless.examples.flex.todo.application.messages.FavoriteTodoMessage;
import com.backendless.examples.flex.todo.application.messages.RemoveTodoMessage;
import com.backendless.examples.flex.todo.domain.Todo;

import mx.collections.ArrayCollection;

import mx.collections.IList;

import spark.collections.Sort;

import spark.collections.SortField;

public class TodoPM implements ITodoPM
{
    public function TodoPM()
    {
        super();
    }

    [MessageDispatcher]
    public var dispatcher:Function;

    [Bindable]
    public var newTodoLabel:String;

    [Bindable]
    [Subscribe(objectId="todos")]
    public var todoList:IList;

//    private var _originalList:IList;
//
//    [Bindable]
//    [Subscribe(objectId="todos")]
//    public function get originalList():IList
//    {
//        return _originalList;
//    }
//
//    public function set originalList(value:IList):void
//    {
//        _originalList = value;
//
//        todoList.source = _originalList ? _originalList.toArray() : [];
//    }

    public function addTodo(label:String):void
    {
        const todo:Todo = new Todo();
        todo.label = label;

        this.newTodoLabel = null;

        dispatcher(new AddTodoMessage(todo));
    }

    public function removeTodo(todo:Todo):void
    {
        dispatcher(new RemoveTodoMessage(todo));
    }

    public function checkTodo(todo:Todo):void
    {
        dispatcher(new CheckTodoMessage(todo));
    }

    public function favoriteTodo(todo:Todo):void
    {
        dispatcher(new FavoriteTodoMessage(todo));
    }

    //----------------------------------------------------------------
    //----------------------------------------------------------------

    [CommandResult(type="com.backendless.examples.flex.todo.application.messages.AddTodoMessage")]
    public function addTodoResult(data:Object, trigger:AddTodoMessage):void
    {

    }

    [CommandError(type="com.backendless.examples.flex.todo.application.messages.AddTodoMessage")]
    public function addTodoError(data:Object, trigger:AddTodoMessage):void
    {
        this.newTodoLabel = trigger.todo.label;
    }
}
}
