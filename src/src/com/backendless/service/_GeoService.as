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
package com.backendless.service
{
	import com.backendless.Backendless;
	import com.backendless.data.BackendlessCollection;
	import com.backendless.errors.InvalidArgumentError;
	import com.backendless.geo.BackendlessGeoQuery;
	import com.backendless.geo.GeoPoint;
	import com.backendless.geo.PointBase;
	import com.backendless.helpers.ClassHelper;
	import com.backendless.rpc.BackendlessClient;
	import com.backendless.validators.ArgumentValidator;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	public class _GeoService extends BackendlessService
	{
		private static const SERVICE_SOURCE:String = "com.backendless.services.geo.GeoService";
	
		private static const DEFAULT_CATEGORY:String = "Default";
	
		public function addCategory(name:String, responder:IResponder = null):AsyncToken
		{
			ArgumentValidator.notNull(name, "a category name can be neither null nor an empty string");
			ArgumentValidator.notEmpty(name, "a category name can be neither null nor an empty string");
	
			if (name == DEFAULT_CATEGORY)
				throw new InvalidArgumentError("the 'default' name is reserved; you can't use it");
	
			var token:AsyncToken = BackendlessClient.instance.invoke(SERVICE_SOURCE, "addCategory",
				[Backendless.appId, Backendless.version, name]);
	
			token.addResponder(new Responder(function (event:ResultEvent):void
			{
				if (responder) responder.result(event);
			}, function (event:FaultEvent):void
			{
				onFault(event, responder);
			}));
			
			return token;
		}
	
		public function deleteCategory(name:String, responder:IResponder = null):AsyncToken
		{
			ArgumentValidator.notNull(name, "a category name can be neither null nor an empty string");
			ArgumentValidator.notEmpty(name, "a category name can be neither null nor an empty string");
	
			if (name == DEFAULT_CATEGORY)
				throw new InvalidArgumentError("the 'default' name is reserved; you can't delete it");
			
			var token:AsyncToken = BackendlessClient.instance.invoke(SERVICE_SOURCE, "deleteCategory",
				[Backendless.appId, Backendless.version, name]);
	
			token.addResponder(new Responder(function (event:ResultEvent):void
			{
				if (responder) responder.result(event);
			}, function (event:FaultEvent):void
			{
				onFault(event, responder);
			}));
			
			return token;
		}
	
		public function addPoint(point:GeoPoint, responder:IResponder = null):AsyncToken
		{
			ArgumentValidator.notNull(point);
			validateCoordinates(point);
			
			if( point.categories == null || point.categories.length == 0 )
				point.categories = [ DEFAULT_CATEGORY ];
	
			var token:AsyncToken = BackendlessClient.instance.invoke(SERVICE_SOURCE, "addPoint",
				[Backendless.appId, Backendless.version, point]);
	
			token.addResponder(new Responder(function (event:ResultEvent):void
			{
				if (responder) responder.result(event);
			}, function (event:FaultEvent):void
			{
				onFault(event, responder);
			}));
			
			return token;
		}
	
		public function getCategories(responder:IResponder):AsyncToken
		{
			var token:AsyncToken = BackendlessClient.instance.invoke(SERVICE_SOURCE, "getCategories",
				[Backendless.appId, Backendless.version]);
	
			token.addResponder(new Responder(function (event:ResultEvent):void
			{
				if (responder) responder.result(event);
			}, function (event:FaultEvent):void
			{
				onFault(event, responder);
			}));
			
			return token;
		}
	
		public function getPoints(query:BackendlessGeoQuery, responder:IResponder = null):BackendlessCollection
		{
			ArgumentValidator.notNull(query);
			ArgumentValidator.notNegative(query.offset, "offset can't be negative");
			if (query.units != null) validateCoordinates(query);
	
			var result:BackendlessCollection = new BackendlessCollection(ClassHelper.getCanonicalClassName(GeoPoint));
			result.pageSize = query.pageSize;
			var token:AsyncToken = BackendlessClient.instance.invoke(SERVICE_SOURCE, "getPoints",
				[Backendless.appId, Backendless.version, query]);
	
			token.addResponder(new Responder(function (event:ResultEvent):void
			{
				result.bindSource(event.result);
				if (responder) responder.result(event);
			}, function (event:FaultEvent):void
			{
				onFault(event, responder);
			}));
	
			return result;
		}
	
		private function validateCoordinates(point:PointBase):void
		{
			ArgumentValidator.validate(
				point.longitude,
				function (value:Number):Boolean
				{
					return !isNaN(value) && value <= 180 && value >= -180;
				},
				"Value of longitude should be less or equal 180 and greater or equal -180"
			)
			ArgumentValidator.validate(
				point.latitude,
				function (value:Number):Boolean
				{
					return !isNaN(value) && value <= 90 && value >= -90;
				},
				"Value of latitude should be less or equal 90 and greater or equal -90"
			)
		}
	}
}