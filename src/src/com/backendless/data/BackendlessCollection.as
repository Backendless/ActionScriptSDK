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
	import com.backendless.QueryOptions;
	import com.backendless.data.event.DynamicLoadEvent;
	import com.backendless.data.store.DataStore;
	import com.backendless.helpers.ObjectsBuilder;
	import com.backendless.validators.ArgumentValidator;
	
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.collections.IList;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import mx.rpc.IResponder;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	/**
	 * Dispatched when requested data is loaded and placed into the collection
	 * @eventType DynamicLoadEvent.LOADED
	 */
	[Event(name="loaded", type="com.backendless.data.event.DynamicLoadEvent")]
	
	/**
	 *
	 *
	 * @author Cyril Deba
	 *
	 */
	public class BackendlessCollection extends ArrayCollection implements IDynamicLoad
	{
		private var _entityClass:Class;
	
		private var _loaded:Boolean;
		private var _loading:Boolean;
	
		private var _pageSize:int = 20;
		private var _total:int;
		private var _cacheSize:int;
		private var _offset:int;
	
		private var _loadedPage:IList = new ArrayList();
		private var _cachedData:Dictionary = new Dictionary();
	
		private var _fromCacheData:Array = [];
		private var _tempOffset:int;
	
		public function BackendlessCollection(_entityName:String, cacheSize:int = 0)
		{
			try
			{
				_entityClass = getDefinitionByName(_entityName) as Class;
			}
			catch (e:Error)
			{
				trace(e);
			}
			
			_cacheSize = cacheSize;
			_loaded = source && source.length > 0;
		}
	
		public function clearCache():void
		{
			_cachedData = new Dictionary();
		}
	
		public function getCurrentPage():IList
		{
			return _loadedPage;
		}
	
		public function getNextPage(update:Boolean = false):void
		{
			loadPage(_offset + _pageSize, _pageSize, update);
			_offset += _pageSize;
		}
	
		public function getPage(offset:int, pageSize:int, update:Boolean = false):void
		{
			loadPage(offset, pageSize, update);
			_offset = offset;
		}
	
		private function loadPage(offset:int, pageSize:int, update:Boolean):void
		{
			ArgumentValidator.notNull(_entityClass, "Entity either doesn't exist or not initialized properly.")
	
			_tempOffset = offset;
	
			var responder:IResponder = new Responder(
				function (event:ResultEvent):void
				{
					bindSource(event.result.data);
				},
				function (event:FaultEvent):void
				{
					throw new Error("unable load the page");
				}
			);
	
			var query:BackendlessDataQuery = new BackendlessDataQuery();
	
			if (_cacheSize > 0 || !update)
			{
				_fromCacheData = [];
				for (var i:int = 0; i < pageSize; i++)
				{
					var currentEntry:Object = _cachedData[offset + i + 1];
	
					if (currentEntry != null)
					{
						_fromCacheData.push(currentEntry);
					}
					else
					{
						break;
					}
				}
	
				if (_fromCacheData.length < pageSize)
					query.queryOptions = new QueryOptions(pageSize - _fromCacheData.length, offset + _fromCacheData.length);
	
			}
			else
			{
				query.queryOptions = new QueryOptions(pageSize, offset);
			}
	
			(Backendless.PersistenceService.of(_entityClass) as DataStore).findByCriteria(query).addResponder(responder);
		}
	
		public function bindSource(source:Object):void
		{
	
			var events:Array = [];
	
			if (source is Array) // ? always array
			{
				var cacheStartIndex:int = _fromCacheData.length + _tempOffset;
				for each(var item:Object in source as Array)
				{
					addItem(ObjectsBuilder.build(_entityClass, item));
	
					if (_cacheSize > 0)
					{
						_cachedData[++cacheStartIndex] = item;
					}
				}
			}
	
	
			_loaded = true;
			_loading = false;
	
			events.push(new DynamicLoadEvent(DynamicLoadEvent.LOADED, this));
			events.push(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, true, false, CollectionEventKind.ADD));
	
			for each(var event:Event in events)
			{
				dispatchEvent(event);
			}
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
	
		public function get loadedPage():IList
		{
			return _loadedPage;
		}
	
		public function get cacheSize():int
		{
			return _cacheSize;
		}
	
		public function set cacheSize(value:int):void
		{
			_cacheSize = (value < 0) ? 0 : value;
		}
	
	}
}