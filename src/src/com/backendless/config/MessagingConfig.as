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
package com.backendless.config
{
	import com.backendless.errors.InvalidArgumentError;

	internal class MessagingConfig
	{
		private var _pollingDelay:Number = 1 * 1000;
		private var _allowedConnectionFaults:Number = 5;
		private var _reconnectionDelay:Number = 1 * 1000;
		
		public function get pollingDelay():Number
		{
			return _pollingDelay;
		}

		public function get allowedConnectionFaults():Number
		{
			return _allowedConnectionFaults;
		}

		public function get reconnectionDelay():Number
		{
			return _reconnectionDelay;
		}

		internal function marshall(section:XMLList):void
		{
			setPoolingDelay(parseNumber(section.pooling_delay, true));
			setAllowedConnectionFaults(parseNumber(section.allowed_connection_faults, false));
			setReconnectionDelay(parseNumber(section.reconnection_delay, false));
		}
		
		private function setPoolingDelay(value:Number):void
		{
			_pollingDelay = value;
		}
		
		private function setAllowedConnectionFaults(value:Number):void
		{
			_allowedConnectionFaults = (1 > value) ? 0 : value;
		}
		
		private function setReconnectionDelay(value:Number):void
		{
			_reconnectionDelay =  (1 > value) ? 0 : value;
		}
		
		private function parseNumber(candidate:XMLList, unsigned:Boolean):Number
		{
			var result:Number = Number(candidate);
			
			if(isNaN(result))
			{
				throw new InvalidArgumentError("Configuration::Passed argument is not valid.");
			}
			
			if(unsigned && 0 > result)
			{
				throw new InvalidArgumentError("Configuration::Value less than 1 is not allowed");
			}
			
			return result;
		}
	}
}