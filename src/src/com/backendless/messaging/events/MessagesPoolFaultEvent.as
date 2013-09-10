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
package com.backendless.messaging.events
{
	import flash.events.Event;
	
	import mx.rpc.events.FaultEvent;
	
	public class MessagesPoolFaultEvent extends Event
	{
		public static const FAULT:String = "onMessagesPooledFault";
		
		private var _fault:FaultEvent;
		
		public function MessagesPoolFaultEvent(faultValue:FaultEvent)
		{
			_fault = faultValue;
			super(FAULT);
		}

		public function get fault():FaultEvent
		{
			return _fault;
		}
	}
}