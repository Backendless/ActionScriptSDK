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
	[RemoteClass(alias="com.backendless.services.messaging.Message")]
	public class Message
	{
		private var _messageId:String;
		private var _headers:Object;
		private var _data:Object;
		private var _publisherId:String;
		private var _timestamp:Number;
		
		
		public function get messageId():String
		{
			return _messageId;
		}

		public function get headers():Object
		{
			return _headers;
		}

		public function get data():Object
		{
			return _data;
		}

		public function get publisherId():String
		{
			return _publisherId;
		}

		public function get timestamp():Number
		{
			return _timestamp;
		}

        public function set messageId( value:String ):void
        {
            _messageId = value;
        }

        public function set headers( value:Object ):void
        {
            _headers = value;
        }

        public function set data( value:Object ):void
        {
            _data = value;
        }

        public function set publisherId( value:String ):void
        {
            _publisherId = value;
        }

        public function set timestamp( value:Number ):void
        {
            _timestamp = value;
        }
    }
}