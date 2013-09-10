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
 * Time: 21:28
 * To change this template use File | Settings | File Templates.
 */
package com.backendless.examples.flex.todo.domain
{
import mx.collections.ArrayCollection;
import mx.collections.ArrayList;
import mx.collections.IList;

import spark.collections.Sort;
import spark.collections.SortField;

public class Todos
{
    public function Todos()
    {
        super();
    }

    [Bindable]
    [Publish(objectId="todos")]
    public var list:IList;

    public function setTodoList(source:ArrayCollection):void
    {
        const sort:Sort = new Sort();
        sort.fields = [new SortField("done"), new SortField("favorite", true)];

        source.sort = sort;
        source.refresh();

        this.list = source;
    }

    public function addTodo(todo:Todo):void
    {
        list.addItem(todo);
    }

    public function removeTodo(todo:Todo):void
    {
        list.removeItemAt(list.getItemIndex(todo));
    }

    public function updateTodo(origin:Todo, recent:Todo):void
    {
        if (list.getItemIndex(origin) != -1)
        {
            origin.copy(recent);
        }
    }

    public function checkTodo(todo:Todo):void
    {
        todo.done = !todo.done;
    }
}
}
