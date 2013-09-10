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
package com.backendless.data.event
{
	import com.backendless.data.IDynamicLoad;
	
	import flash.events.Event;
	
	public class DynamicLoadEvent extends Event
	{
		
		public static const LOADED:String = "loaded";
		
		private var _data:IDynamicLoad;
		
		public function DynamicLoadEvent(type:String, data:IDynamicLoad):void
		{
			_data = data;			
			super(type);
		}
		
		public function get data():IDynamicLoad
		{
			return _data;
		}
	}
}