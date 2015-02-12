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
package com.backendless.data.store
{
	import com.backendless.Backendless;
	import com.backendless.BackendlessDataQuery;
	import com.backendless.data.BackendlessCollection;
	import com.backendless.data.IDataStore;
	import com.backendless.helpers.ClassHelper;
	import com.backendless.helpers.ObjectsBuilder;
	import com.backendless.rpc.BackendlessClient;
	import com.backendless.service._PersistenceService;
	import com.backendless.validators.ArgumentValidator;
	
	import flash.events.EventDispatcher;
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;

	public class DataStore extends EventDispatcher implements IDataStore
	{
		private var candidateClassName:String;
		private var candidateFullClassName:String;
		private var candidateClass:Class;
		
		public function DataStore(candidate:Class)
		{
			candidateFullClassName = ClassHelper.getCanonicalClassName(candidate);
            candidateClassName = Backendless.PersistenceService.getTableNameForClass( candidate );
			candidateClass = candidate;
		}
		
		public function findByCriteria(query:BackendlessDataQuery, responder:IResponder = null):AsyncToken {
			return BackendlessClient.instance.invoke(_PersistenceService.SERVICE_SOURCE, 
				"find", [Backendless.appId, Backendless.version, candidateClassName, query], responder);
		}
		
		public function find(query:BackendlessDataQuery = null, responder:IResponder=null):BackendlessCollection
		{
			if( query != null )
				ArgumentValidator.notNull( query );
			
			var result:BackendlessCollection = new BackendlessCollection(candidateFullClassName);
			var token:AsyncToken = findByCriteria(query);
			token.addResponder(
				new Responder(
					function(event:ResultEvent):void
					{
						trace(event.result);
						result.bindSource(event.result);
						
						if( responder )
							responder.result( ResultEvent.createEvent( result, token,  event.message ) );
					}, 
					function(event:FaultEvent):void
					{
						onFault(event, responder);
					}
				)
			);
			
			return result;
		}

      public function findById( entityId:Object, responder:IResponder = null ):AsyncToken
      {
        return internalFindById( entityId, [], 0, responder );
      }

      public function findByIdWithRelations( entityId:Object, relations:Array, responder:IResponder = null ):AsyncToken
      {
        return internalFindById( entityId, relations, 0, responder );
      }

      public function findByIdWithDepth( entityId:Object, relationsDepth:int, responder:IResponder = null ):AsyncToken
      {
        return internalFindById( entityId, [], relationsDepth, responder );
      }
		
		private function internalFindById( entityId:Object, relations:Array, relationsDepth:int, responder:IResponder = null ):AsyncToken
		{
			ArgumentValidator.notEmpty(entityId);
			ArgumentValidator.notNull(entityId);

          var args:Array = [Backendless.appId, Backendless.version, candidateClassName, entityId];

          if( !(entityId is String) )
          {
            args.push( [] );  // relations
            args.push( 0 );   // relations depth
          }
			
			var token:AsyncToken = BackendlessClient.instance.invoke(
				_PersistenceService.SERVICE_SOURCE,
				"findById",
				args
			);
			
			if( responder != null )
				token.addResponder(
					new Responder(
						function(event:ResultEvent):void
						{
							var evt:ResultEvent = ResultEvent.createEvent( ObjectsBuilder.build( candidateClass, event.result ), token );
							responder.result( evt );
						},
						function(event:FaultEvent):void
						{
							onFault(event, responder);
						}
					)
				);
				
			return token;
		}
		
      public function first( responder:IResponder = null ):AsyncToken
      {
        return internalFirst( [], 0, responder );
      }

      public function firstWithRelations( relations:Array, responder:IResponder = null ):AsyncToken
      {
        return internalFirst( relations, 0, responder );
      }

      public function firstWithDepth( relationsDepth:int, responder:IResponder = null ):AsyncToken
      {
        return internalFirst( [], relationsDepth, responder );
      }

      private function internalFirst( relations:Array, relationsDepth:int, responder:IResponder = null ):AsyncToken
      {
          var token:AsyncToken = BackendlessClient.instance.invoke(
              _PersistenceService.SERVICE_SOURCE,
              "first",
              [Backendless.appId, Backendless.version, candidateClassName, relations, relationsDepth ]
          );

          if( responder != null )
              token.addResponder(
                  new Responder(
                      function (event:ResultEvent):void
                      {
                          var evt:ResultEvent = ResultEvent.createEvent( ObjectsBuilder.build( candidateClass, event.result ), token );
                          responder.result( evt );
                      },
                      function (event:FaultEvent):void
                      {
                          onFault( event, responder );
                      }
                  )
              );

          return token;
      }

      public function last( responder:IResponder = null ):AsyncToken
      {
        return internalLast( [], 0, responder );
      }

      public function lastWithRelations( relations:Array, responder:IResponder = null ):AsyncToken
      {
        return internalLast( relations, 0, responder );
      }

      public function lastWithDepth( relationsDepth:int, responder:IResponder = null ):AsyncToken
      {
        return internalLast( [], relationsDepth, responder );
      }

		private function internalLast( relations:Array, relationsDepth:int, responder:IResponder = null ):AsyncToken
		{
			var token:AsyncToken = BackendlessClient.instance.invoke(
				_PersistenceService.SERVICE_SOURCE, 
				"last", 
				[Backendless.appId, Backendless.version, candidateClassName, relations, relationsDepth]
			);
			
			if( responder != null )
				token.addResponder(
					new Responder(
						function (event:ResultEvent):void
						{
							var evt:ResultEvent = ResultEvent.createEvent( ObjectsBuilder.build( candidateClass, event.result ), token );
							responder.result( evt );
						},
						function (event:FaultEvent):void
						{
							onFault( event, responder );
						}
					)
				);
			
			return token;
		}
		
		public function remove( candidate:*, responder:IResponder=null ):AsyncToken
		{
			ArgumentValidator.notNull( candidate );
			return removeById( candidate.objectId, responder );	
		}
		
		public function removeById(candidateId:String, responder:IResponder=null):AsyncToken
		{
			ArgumentValidator.notNull(candidateId);
			ArgumentValidator.notEmpty(candidateId);
			
			var token:AsyncToken = BackendlessClient.instance.invoke(
				_PersistenceService.SERVICE_SOURCE, 
				"remove", 
				[Backendless.appId, Backendless.version, candidateClassName, candidateId]
			);
			
			if( responder != null )
				token.addResponder(
					new Responder(
						function( event:ResultEvent ):void 
						{
							responder.result( event );
						}, 
						function(event:FaultEvent):void 
						{
							onFault( event, responder );
						}
					)
				);		
			
			return token;
		}
		
		public function save( candidate:*, responder:IResponder=null ):AsyncToken
		{
			ArgumentValidator.notNull( candidate, "the save method doesn't allow to pass null properties" );
			return handleSave( candidate, candidateClassName, responder );
		}
		
		public function saveDynamic( className:String, candidate:Object, responder:IResponder=null ):AsyncToken
		{
			return handleSave(candidate, className, responder);
		}
		
		public function loadRelations( dataObject:*, relations:Array = null, responder:IResponder = null ):AsyncToken
		{
			if( relations == null )
				relations = [ "*" ];
			
			var token:AsyncToken = BackendlessClient.instance.invoke(_PersistenceService.SERVICE_SOURCE, "findById", 
				[Backendless.appId, Backendless.version, candidateClassName, dataObject, relations]);
			
			if( responder != null )
				token.addResponder(
					new Responder(
						function(event:ResultEvent):void 
						{
							var object:Object = ObjectsBuilder.updateWith(dataObject, event.result );
							var resultEvent:ResultEvent = ResultEvent.createEvent( object, token );
							responder.result( resultEvent );
						},
						function(event:FaultEvent):void
						{
							onFault( event, responder );
						}
					)
				);	
			
			return token;
		}
		
		private function handleSave(candidate:*, className:String, responder:IResponder=null):AsyncToken 
		{	
			var currentOperation:String = "create";
			
			if( candidate.hasOwnProperty( "objectId" ) && candidate.objectId != null )
				currentOperation = "update";
			
			Utils.addClassName( candidate, true );
			
			var token:AsyncToken = BackendlessClient.instance.invoke(_PersistenceService.SERVICE_SOURCE, currentOperation, 
				[Backendless.appId, Backendless.version, className, candidate]);
			
			if( responder != null )
				token.addResponder( new Responder(
						function(event:ResultEvent):void 
						{
							var evt:ResultEvent = ResultEvent.createEvent( ObjectsBuilder.updateWith( candidate, event.result), token );
							responder.result( evt );
						},
						function(event:FaultEvent):void
						{
							onFault( event, responder );
						}
					)
				);
			
			return token;
		}
		
		private function onFault(event:FaultEvent, responder:IResponder):void 
		{
			if( responder != null )
				responder.fault( event );
				
			dispatchEvent( event );
		}
	}
}