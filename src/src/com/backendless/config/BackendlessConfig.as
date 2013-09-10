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
	import com.backendless.errors.ConfigurationError;
	
	import mx.core.ByteArrayAsset;

	public final class BackendlessConfig
	{
		private static var _instance:BackendlessConfig;
		
		[Embed("/assets/config.xml", mimeType="application/octet-stream")]
		private static const Config:Class;
		
		private var _messaging:MessagingConfig = new MessagingConfig();
		
		public function BackendlessConfig(lock:BackendlessConfigLock):void
		{
			if(lock == null) {
				throw new Error("Config is a singleton and it is already initialized. Please read the documentation");
			}
			
			marshall();
		}
		
		public static function get instance():BackendlessConfig {
			if(_instance == null)
			{
				_instance = new BackendlessConfig(new BackendlessConfigLock());
			}
			
			return _instance;
		}
		
		private function marshall():void {
			try
			{
				var xmlConfig:XML = getXmlConfig();
				
				_messaging.marshall(xmlConfig.sections.services.messaging as XMLList);
				
			} catch(error:Error) {
				trace("Caughted error: " + error.message);
				throw new ConfigurationError("unable initialize the Backendless configuration file. Please refer to the Backendless documentation.");
			}
		}
		
		private function getXmlConfig():XML
		{
			var byteArrayAsset:ByteArrayAsset = ByteArrayAsset(new Config());
			return new XML(byteArrayAsset.readUTFBytes(byteArrayAsset.length));
		}

		public function get messaging():MessagingConfig
		{
			return _messaging;
		}
	}
}

class BackendlessConfigLock{}