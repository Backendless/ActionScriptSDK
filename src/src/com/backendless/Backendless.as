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
package com.backendless
{
    import com.backendless.core.backendless;
    import com.backendless.messaging.Message;
    import com.backendless.property.AbstractProperty;
    import com.backendless.property.ObjectProperty;
    import com.backendless.property.UserProperty;
    import com.backendless.rpc.BackendlessClient;
    import com.backendless.service._FileService;
    import com.backendless.service._GeoService;
    import com.backendless.service._MediaService;
    import com.backendless.service._MessagingService;
    import com.backendless.service._PersistenceService;
    import com.backendless.service._UserService;
	import com.backendless.geo.GeoCategory;
	import com.backendless.geo.GeoPoint;
	
    import flash.net.registerClassAlias;

  import mx.utils.RpcClassAliasInitializer;

  import mx.utils.StringUtil;

    use namespace backendless;

	public class Backendless
	{
		//public static const SITE_URL:String = "http://localhost:9000/";
		//public static var SITE_URL:String = "http://tc.themidnightcoders.com:9090/";
      public static var SITE_URL:String = "https://api.backendless.com/";
		//public static const SITE_URL:String = "http://tc.themidnightcoders.com:9000/";

		public static function get AMF_ENDPOINT():String
		{
			return StringUtil.substitute(AMF_ENDPOINT_TEMPLATE, SITE_URL, version);
		}
	
		public static const APPLICATION_ID_HEADER:String = "application-id";
		public static const SECRET_KEY_HEADER:String = "secret-key";
		public static const APPLICATION_TYPE_HEADER:String = "application-type";
		public static const API_VERSION_HEADER:String = "appVersion";
	
		public static const LOGGED_IN_KEY:String = "user-token";
		public static const USER_TOKEN_KEY:String = "logged-in";
		public static const SESSION_TIME_OUT_KEY:String = "session-time-out";
	
		private static const AMF_ENDPOINT_TEMPLATE:String = "{0}{1}/binary";
	
		private static const APPLICATION_TYPE:String = "AS";
	
		private static var _appId:String;
		private static var _secretKey:String;
		private static var _version:String;
	
		private static var _headers:Object;
	
		private static const _userService:_UserService = new _UserService();
		private static const _persistenceService:_PersistenceService = new _PersistenceService();
		private static const _geoService:_GeoService = new _GeoService();
		private static const _messagingService:_MessagingService = new _MessagingService();
		private static const _fileService:_FileService = new _FileService();
        private static const _mediaService:_MediaService = new _MediaService();
	
		/**
		 * Initializes the application instance with its all required dependencies
		 *
		 * @param appId - an application id.
		 *         The id represents the registered application and it can be retreived through the application console
		 * @param secretKey - an application secret key.
		 *         The key enables access to the functionality of the SDK and can be retreived through the application console
		 * @param versionNum - the application version number. The version number identifies the current application version
		 *         and represents a snapshot of the configuration settings, set of schemas, user properties, etc.
		 *
		 */
		public static function initApp(appId:String, secretKey:String, versionNum:String):void 
		{
			_appId = appId;
			_secretKey = secretKey;
			_version = versionNum;
	
			_headers = {};
			_headers[APPLICATION_TYPE_HEADER] = APPLICATION_TYPE;
			_headers[APPLICATION_ID_HEADER] = _appId;
			_headers[SECRET_KEY_HEADER] = _secretKey;

            RpcClassAliasInitializer.registerClassAliases();

			registerClassAlias( "com.backendless.services.users.property.AbstractProperty", AbstractProperty );
			registerClassAlias( "com.backendless.services.users.property.UserProperty", UserProperty );
			registerClassAlias( "com.backendless.services.persistence.ObjectProperty", ObjectProperty );
			registerClassAlias( "com.backendless.services.messaging.Message", Message );
			registerClassAlias( "com.backendless.geo.model.GeoCategory", GeoCategory );
			registerClassAlias( "com.backendless.geo.model.GeoPoint", GeoPoint );
				
			BackendlessClient.instance.backendless::initChannel();
		}
	
		public static function get appId():String
		{
			return _appId;
		}
	
		public static function get version():String
		{
			return _version;
		}
	
		public static function get headers():Object
		{
			return _headers;
		}
	
		public static function get UserService():_UserService
		{
			return _userService;
		}
		
		public static function get Data():_PersistenceService
		{
			return _persistenceService;
		}		
	
		public static function get PersistenceService():_PersistenceService
		{
			return _persistenceService;
		}
	
		public static function get GeoService():_GeoService
		{
			return _geoService;
		}
	
		public static function get Messaging():_MessagingService
		{
			return _messagingService;
		}
	
		public static function get FileService():_FileService
		{
			return _fileService;
		}

        public static function get MediaService():_MediaService
        {
            return _mediaService;
        }
	
		backendless static function setUserToken(userToken:String):void
		{
			_headers[LOGGED_IN_KEY] = userToken;
		}

		backendless static function removeUserToken():void
		{
			delete _headers[LOGGED_IN_KEY];
		}

	}
}