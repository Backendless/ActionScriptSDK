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
	import com.backendless.data.IBackendlessEntity;
	import com.backendless.data.IDataStore;
	import com.backendless.helpers.ClassHelper;
	import com.backendless.helpers.ObjectsBuilder;
	import com.backendless.rpc.BackendlessClient;
	import com.backendless.service._PersistenceService;
	import com.backendless.validators.ArgumentValidator;
	
	import flash.events.EventDispatcher;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectUtil;


	public class DataStore extends EventDispatcher implements IDataStore
	{
		private var candidateClassName:String;
		private var candidateFullClassName:String;
		private var candidateClass:Class;
		
		public function DataStore(candidate:Class)
		{
			candidateFullClassName = ClassHelper.getCanonicalClassName(candidate);
			candidateClassName = ClassHelper.getCanonicalShortClassName(candidate);
			candidateClass = candidate;
		}
		
		public function findByCriteria(query:BackendlessDataQuery, responder:IResponder = null):AsyncToken {
			return BackendlessClient.instance.invoke(_PersistenceService.SERVICE_SOURCE, 
				"find", [Backendless.appId, Backendless.version, candidateClassName, query], responder);
		}
		
		public function find(query:BackendlessDataQuery, responder:IResponder=null):BackendlessCollection
		{
			ArgumentValidator.notNull(query);
			
			if(!query.valid) {
				throw new Error("Passed query is not valid.");
			}
			
			var result:BackendlessCollection = new BackendlessCollection(candidateFullClassName);
			var token:AsyncToken = findByCriteria(query, responder);
			token.addResponder(
				new Responder(
					function(event:ResultEvent):void
					{
						trace(event.result);
						result.bindSource(event.result.data);
					}, 
					function(event:FaultEvent):void
					{
						onFault(event, responder);
					}
				)
			);
			
			return result;
		}
		
		public function findById(entityId:String, responder:IResponder):void
		{
			ArgumentValidator.notEmpty(entityId);
			ArgumentValidator.notNull(entityId);
			
			var token:AsyncToken = BackendlessClient.instance.invoke(
				_PersistenceService.SERVICE_SOURCE,
				"findById",
				[Backendless.appId, Backendless.version, candidateClassName, entityId]
			);
			
			token.addResponder(
				new Responder(
					function(event:ResultEvent):void
					{
						if (responder)
						{
							responder.result(
								ResultEvent.createEvent(ObjectsBuilder.build(candidateClass, event.result), token)
							)
						}
					},
					function(event:FaultEvent):void
					{
						onFault(event, responder);
					}
				)
			)
		}
		
		public function first(responder:IResponder):void
		{
			var token:AsyncToken = BackendlessClient.instance.invoke(
				_PersistenceService.SERVICE_SOURCE, 
				"first", 
				[Backendless.appId, Backendless.version, candidateClassName]
			);
			
			token.addResponder(
				new Responder(
					function (event:ResultEvent):void
					{
						if (responder)
						{
							responder.result(
								ResultEvent.createEvent(ObjectsBuilder.build(candidateClass, event.result),	token)
							)
						}
					},
					function (event:FaultEvent):void
					{
						onFault(event, responder);
					}
				)
			)
		}
		
		public function last(responder:IResponder):void
		{
			var token:AsyncToken = BackendlessClient.instance.invoke(
				_PersistenceService.SERVICE_SOURCE, 
				"last", 
				[Backendless.appId, Backendless.version, candidateClassName] 
			);
			
			token.addResponder(
				new Responder(
					function (event:ResultEvent):void
					{
						if (responder)
						{
							responder.result(
								ResultEvent.createEvent(ObjectsBuilder.build(candidateClass, event.result),	token)
							)
						}
					},
					function (event:FaultEvent):void
					{
						onFault(event, responder);
					}
				)
			)				
		}
		
		public function remove(candidate:IBackendlessEntity, responder:IResponder=null):void
		{
			ArgumentValidator.notNull(candidate);
			removeById(candidate.objectId, responder);	
		}
		
		public function removeById(candidateId:String, responder:IResponder=null):void
		{
			ArgumentValidator.notNull(candidateId);
			ArgumentValidator.notEmpty(candidateId);
			
			var token:AsyncToken = BackendlessClient.instance.invoke(
				_PersistenceService.SERVICE_SOURCE, 
				"remove", 
				[Backendless.appId, Backendless.version, candidateClassName, candidateId]
			);
			
			token.addResponder(
				new Responder(
					function(event:ResultEvent):void 
					{
						if (responder) responder.result(event);
					}, 
					function(event:FaultEvent):void 
					{
						onFault(event, responder);
					}
				)
			);			
		}
		
		public function save(candidate:IBackendlessEntity, responder:IResponder=null):void
		{
			ArgumentValidator.notNull(candidate, "the save method doesn't allow to pass null properties");
			
			handleSave(candidate, candidateClassName, responder);
		}
		
		public function saveDynamic(className:String, candidate:Object, responder:IResponder=null):void
		{
			handleSave(candidate, className, responder);
		}
		
		private function handleSave(candidate:*, className:String, responder:IResponder=null):void {
			var currentOperation:String = (candidate.objectId == null) ? "create" : "update";
			
			addClassName( candidate, true );
			
			var token:AsyncToken = BackendlessClient.instance.invoke(_PersistenceService.SERVICE_SOURCE, currentOperation, 
				[Backendless.appId, Backendless.version, className, candidate]);
			
			token.addResponder(
				new Responder(
					function(event:ResultEvent):void 
					{
						responder.result(
							ResultEvent.createEvent(
								ObjectsBuilder.updateWith(candidate, event.result),
								token
							)
						);
					},
					function(event:FaultEvent):void
					{
						onFault(event, responder);
					}
				)
			);
		}
		
		private function onFault(event:FaultEvent, responder:IResponder):void {
			if(responder != null) {
				responder.fault(event);
			}	
			dispatchEvent(event);
		}
	

		private function addClassName(dataObject:*, isRoot:Boolean ):void 
		{
			if( dataObject is Array )
			{
				for( var prop:* in dataObject )
					addClassName( dataObject[ prop ], false );
			}
			else if( !ObjectUtil.isSimple( dataObject ) )
			{
				var objInfo:Object = ObjectUtil.getClassInfo( dataObject );
				
				for each(var item:QName in objInfo.properties) 
				{
					var obj:* = dataObject[ item.localName ];
						
					if( obj != null && (!ObjectUtil.isSimple( obj ) || obj is Array) ) 
						addClassName( obj, false );
				}
				
				if( !isRoot && !dataObject.hasOwnProperty( "___class" ) )
				{
					if( !ObjectUtil.isDynamicObject( dataObject ) )
						throw new Error( "Cannot save/update object. Either declare '___class' property in all related objects. The property value must be the name of the class/table. Altenratively declare the class 'dynamic'" );
						
					var className:String  = getQualifiedClassName( dataObject );
					var dot:int = className.lastIndexOf( ":" );
					
					if( dot > -1 )
						className = className.substring( dot + 1 );
					
					dataObject[ "___class" ] = className;
				}					
			}
		}
	}
}