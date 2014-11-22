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
	import com.backendless.Backendless;
	import com.backendless.BackendlessDataQuery;
  import com.backendless.BackendlessUser;
  import com.backendless.QueryOptions;
	import com.backendless.data.event.DynamicLoadEvent;
	import com.backendless.data.store.DataStore;
	import com.backendless.helpers.ObjectsBuilder;
	import com.backendless.validators.ArgumentValidator;
	
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	
	import mx.collections.ArrayCollection;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	/**
	 * Dispatched when requested data is loaded and placed into the collection
	 * @eventType DynamicLoadEvent.LOADED
	 */
	[Event(name="loaded", type="com.backendless.data.event.DynamicLoadEvent")]
	public class BackendlessCollection extends ArrayCollection implements IDynamicLoad
	{
		private var _entityClass:Class;
	
		private var _loaded:Boolean;
		private var _loading:Boolean;
	
		private var _pageSize:int = 20;
		private var _total:int;
		private var _offset:int;
	    private var _currentPage:ArrayCollection;
		private var _tempOffset:int;
	
		public function BackendlessCollection( _entityName:String = null )
		{
          if( _entityName != null )
			try
			{
				_entityClass = getDefinitionByName( _entityName ) as Class;
			}
			catch( e:Error )
			{
				trace( e );
			}
			
			_currentPage = new ArrayCollection();
			_loaded = source && source.length > 0;
		}

        public function setEntityClass( clazz:Class ):void
        {
          this._entityClass = clazz;
        }

        public override function addItem(item:Object):void
        {
          _currentPage.addItem( item );
        }

        public override function removeItem(item:Object):Boolean
        {
          return _currentPage.removeItem( item );
        }
	
		public function getNextPage( responder:IResponder = null ):AsyncToken
		{
			var token:AsyncToken = loadPage( _offset + _pageSize, _pageSize, responder );
			_offset += _pageSize;
			return token;
		}
	
		public function getPage( offset:int, pageSize:int, responder:IResponder = null ):AsyncToken
		{
			var token:AsyncToken = loadPage( offset, pageSize, responder );
			_offset = offset;
			return token;
		}
	
		private function loadPage(offset:int, pageSize:int, responder:IResponder = null ):AsyncToken
		{
			ArgumentValidator.notNull(_entityClass, "Entity either doesn't exist or not initialized properly.")
	
			_tempOffset = offset;
			var query:BackendlessDataQuery = new BackendlessDataQuery();
			query.queryOptions = new QueryOptions( pageSize, offset );
			var token:AsyncToken = (Backendless.PersistenceService.of( _entityClass ) as DataStore ).findByCriteria( query );
			var collection:BackendlessCollection = this;
			token.addResponder( new Responder(
				function( event:ResultEvent ):void
				{
					bindSource(event.result.data);

					if( responder )
						responder.result( ResultEvent.createEvent( collection, token,  event.message ) );
				},
				function( event:FaultEvent ):void
				{
					throw new Error( "unable load the page" );
				}
			));
	
			return token;
		}
	
		public function bindSource( source:Object ):void
		{
			var events:Array = [];
			_currentPage.removeAll();
	
			if (source is Array) // ? always array
			{
				for each( var item:Object in source as Array )
				{
                  var entity:Object;

                  if( _entityClass == BackendlessUser )
                    entity = ObjectsBuilder.buildUser( item );
                  else
					entity = ObjectsBuilder.build( _entityClass, item );

					_currentPage.addItem( entity );
   			        //addItem( entity );
				}
			}
			else if( isBackendlessCollection( source ) )
			{
				for each( var item1:Object in source.data as Array )
				{
					var entity1:Object;

                  if( _entityClass == BackendlessUser )
                    entity1 = ObjectsBuilder.buildUser( item1 );
                  else
					entity1 = ObjectsBuilder.build( _entityClass, item1 );

					_currentPage.addItem( entity1 );
					//addItem( entity1 );
				}				
				
				this._total = source.totalObjects;
				this._offset = source.offset;
			}
	
	
			_loaded = true;
			_loading = false;
	
			events.push(new DynamicLoadEvent(DynamicLoadEvent.LOADED, this));
			events.push(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, true, false, CollectionEventKind.ADD));
	
			for each(var event:Event in events)
				dispatchEvent(event);
		}
	
		[Bindable(event="loaded")]
		public function get loaded():Boolean
		{
			return _loaded;
		}
	
		public function set loaded(value:Boolean):void
		{
			_loaded = value;
		}
	
		public function get loading():Boolean
		{
			return _loading;
		}
	
		public function set loading(value:Boolean):void
		{
			_loading = value;
		}
	
		public function get pageSize():int
		{
			return _pageSize;
		}
	
		public function set pageSize(value:int):void
		{
			_pageSize = value;
		}
		
		public function get totalObjects():int
		{
			return _total;
		}
		
		public function get offset():int
		{
			return _offset;
		}
		
		public function get currentPage():ArrayCollection
		{
			return _currentPage;
		}
		
		private function isBackendlessCollection( obj:Object ):Boolean
		{
			return obj.hasOwnProperty( "data" ) &&
				obj.hasOwnProperty( "offset" ) &&
				obj.hasOwnProperty( "totalObjects" );
		}		
	}
}