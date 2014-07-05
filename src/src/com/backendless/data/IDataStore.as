/*                                                                                                                                                                           
 * ********************************************************************************************************************
 *
 *  BACKENDLESS.COM CONFIDENTIAL
 *
 * ********************************************************************************************************************
 *
 *   Copyright 2012 BACKENDLESS.COM. All Rights Reserved.
 *
 *  NOTICE:  All information contained herein is, and remains the property of Backendless.com and its suppliers,
 *  if any.  The intellectual and technical concepts contained herein are proprietary to Backendless.com and its
 *  suppliers and may be covered by U.S. and Foreign Patents, patents in process, and are protected by trade secret
 *  or copyright law. Dissemination of this information or reproduction of this material is strictly forbidden
 *  unless prior written permission is obtained from Backendless.com.
 *
 * *******************************************************************************************************************
 */
package com.backendless.data
{
  import com.backendless.BackendlessDataQuery;

  import flash.events.IEventDispatcher;

  import mx.rpc.IResponder;
  import mx.rpc.AsyncToken;

  public interface IDataStore extends IEventDispatcher
  {
    function save( candidate:*, responder:IResponder = null ):AsyncToken;

    function saveDynamic( className:String, candidate:Object, responder:IResponder = null ):AsyncToken;

    function remove( candidate:*, responder:IResponder = null ):AsyncToken;

    function removeById( candidateId:String, responder:IResponder = null ):AsyncToken;

    function find( query:BackendlessDataQuery = null, responder:IResponder = null ):BackendlessCollection;

    function findById( entityId:String, responder:IResponder = null ):AsyncToken;

    function findByIdWithRelations( entityId:String, relations:Array, responder:IResponder = null ):AsyncToken;

    function findByIdWithDepth( entityId:String, relationsDepth:int, responder:IResponder = null ):AsyncToken;

    function first( responder:IResponder = null ):AsyncToken;

    function firstWithRelations( relations:Array, responder:IResponder = null ):AsyncToken;

    function firstWithDepth( relationsDepth:int, responder:IResponder = null ):AsyncToken;

    function last( responder:IResponder = null ):AsyncToken;

    function lastWithRelations( relations:Array, responder:IResponder = null ):AsyncToken;

    function lastWithDepth( relationsDepth:int, responder:IResponder = null ):AsyncToken;

    function loadRelations( dataObject:*, relations:Array = null, responder:IResponder = null ):AsyncToken;
  }
}