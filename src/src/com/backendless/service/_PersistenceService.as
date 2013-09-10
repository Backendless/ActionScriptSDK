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
	import com.backendless.BackendlessUser;
	import com.backendless.data.BackendlessCollection;
	import com.backendless.data.IDataStore;
	import com.backendless.data.store.DataStore;
	import com.backendless.errors.ObjectNotPersistableError;
	import com.backendless.rpc.BackendlessClient;
	
	import flash.utils.Dictionary;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	public class _PersistenceService extends BackendlessService
	{
		public static const SERVICE_SOURCE:String = "com.backendless.services.persistence.PersistenceService";
		
		private static var _dataStoreInstances:Dictionary = new Dictionary;
		
		public function describe(entityName:String, responder:IResponder=null):BackendlessCollection
		{
			var result:BackendlessCollection = new BackendlessCollection(entityName);
			
			var token:AsyncToken = BackendlessClient.instance.invoke(SERVICE_SOURCE, "describe", [Backendless.appId, Backendless.version, entityName], responder);
			
			token.addResponder(new Responder(function(event:ResultEvent):void {
				result.bindSource(event.result);
			}, function(event:FaultEvent):void {
				onFault(event, responder);
			}));
			
			return result;
		}
		
		public function of(candidate:Class):IDataStore {
			if(candidate == BackendlessUser) {
				throw new ObjectNotPersistableError("BackendlessUser class is not a persistable one. Please use the userService");
			}
			
			var instance:IDataStore = _dataStoreInstances[candidate];
			
			if(instance == null) {
				instance = new DataStore(candidate);
				_dataStoreInstances[instance];
			}
			return instance;
		}
	}
}