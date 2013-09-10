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
	public class PublishOptions
	{
		private var _publisherId:String;
		private var _subtopic:String;
		private var _headers:Object;

		public function set publisherId(value:String):void
		{
			_publisherId = value;
		}

		public function set subtopic(value:String):void
		{
			_subtopic = value;
		}

		public function set headers(value:Object):void
		{
			_headers = value;
		}

        public function get publisherId():String
        {
            return _publisherId;
        }

        public function get subtopic():String
        {
            return _subtopic;
        }

        public function get headers():Object
        {
            return _headers;
        }

        public function addHeader(key:*, value:*):void
		{
			if(key == null || value == null) {
				throw new Error("Neither null key nor null value is allowed");
			}
			if(_headers == null) {
				_headers = new Object();
			}
			
			_headers[key] = value;
		}
	}
}