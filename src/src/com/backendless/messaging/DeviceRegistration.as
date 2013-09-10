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
	import com.backendless.helpers.DeviceHelper;
import com.backendless.service._MessagingService;

import flash.system.Capabilities;

	[RemoteClass(alias="com.backendless.management.DeviceRegistrationDto")]
	public class DeviceRegistration
	{
		[Transient]
		public var gcmSenderId:String;

        public function DeviceRegistration():void
        {
            if( Capabilities.manufacturer.search('iOS') > -1 )
              this._os = _MessagingService.IOS;
            else if( Capabilities.manufacturer.search('Android') > -1 )
              this._os = _MessagingService.ANDROID;
        }

		private var _id:String;
		public function get id():String
		{
			return _id;
		}

		public function set id(value:String):void
		{
			_id = value;
		}

		private var _deviceId:String = DeviceHelper.uniqueDeviceID;
		public function get deviceId():String
		{
			return _deviceId;
		}
		
		public function set deviceId( value:String ):void
		{
			this._deviceId = value;
		}

		private var _os:String = DeviceHelper.type;
		public function get os():String
		{
			return _os;
		}

        public function set os( value:String ):void
        {
            this._os = value;
        }

		private var _osVersion:String = Capabilities.manufacturer;
		public function get osVersion():String
		{
			return _osVersion;
		}

		private var _deviceToken:String;
		public function get deviceToken():String
		{
			return _deviceToken;
		}

		public function set deviceToken(value:String):void
		{
			_deviceToken = value;
		}

		private var _expiration:Date;
		public function get expiration():Date
		{
			return _expiration;
		}

		public function set expiration(value:Date):void
		{
			_expiration = value;
		}

		private var _channels:Array;
		public function get channels():Array
		{
			return _channels;
		}

		public function set channels(value:Array):void
		{
			_channels = value;
		}
    }
}