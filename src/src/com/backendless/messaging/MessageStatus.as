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
package com.backendless.messaging
{
	[RemoteClass(alias="com.backendless.services.messaging.MessageStatus")]
	public class MessageStatus
	{
		
		public static const MESSAGE_FAILED:String = "FAILED";
		public static const MESSAGE_PUBLISHED:String = "PUBLISHED";
		public static const MESSAGE_SCHEDULED:String = "SCHEDULED";
        public static const MESSAGE_CANCELLED:String = "CANCELLED";

		private var _messageId:String;
		private var _status:String;

		
		public function get messageId():String
		{
			return _messageId;
		}

		public function set messageId(value:String):void
		{
			_messageId = value;
		}

		public function get status():String
		{
			return _status;
		}

		public function set status(value:String):void
		{
			_status = value;
		}
	}
}