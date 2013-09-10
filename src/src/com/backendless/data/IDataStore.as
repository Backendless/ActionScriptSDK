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

	public interface IDataStore extends IEventDispatcher
	{
		function save(candidate:IBackendlessEntity, responder:IResponder = null):void;
		function saveDynamic(className:String, candidate:Object, responder:IResponder = null):void;
		
		function remove( candidate:IBackendlessEntity, responder:IResponder = null):void;
		function removeById(candidateId:String, responder:IResponder = null):void;
		
		function find(query:BackendlessDataQuery, responder:IResponder = null):BackendlessCollection;
		function findById(entityId:String, responder:IResponder):void;
		function first(responder:IResponder):void;
		function last(responder:IResponder):void;
	}
}