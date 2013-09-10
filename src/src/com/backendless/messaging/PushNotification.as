package com.backendless.messaging
{
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
    import flash.system.Capabilities;

    [Event(name="givenToken", type="com.backendless.messaging.PushNotificationEvent")]
	[Event(name="notification", type="com.backendless.messaging.PushNotificationEvent")]
	[Event(name="permissionRefused", type="com.backendless.messaging.PushNotificationEvent")]

	public class PushNotification extends EventDispatcher
	{  
		public static const RECURRENCE_NONE:int   = 0;
		public static const RECURRENCE_DAILY:int  = 1;
		public static const RECURRENCE_WEEK:int   = 2;
		public static const RECURRENCE_MONTH:int  = 3;
		public static const RECURRENCE_YEAR:int   = 4;

		public static const LOGGING:String       = "LOGGING";
		public static const TOKEN_FAULT:String   = "TOKEN_FAILT";
		public static const NOTIFICATION:String  = "COMING_FROM_NOTIFICATION";
		public static const TOKEN_SUCCESS:String = "TOKEN_SUCCESS";

		private static var context:ExtensionContext = null;

		private var lastToken:String;

        public function PushNotification()
		{
			if (_instance == null)
			{
				_instance = this;
				if (isSupported == true)
				{
					// try to create ANE context for using push notification for both platforms -
					// Android and iOS. If context is null, notify about have to linkage ANE
					// library to project
                    trace( "Loading extension");

                    try
                    {
					context = ExtensionContext.createExtensionContext("com.backendless.BackendlessPN", null);
                    }
                    catch( err:Error )
                    {
                      trace( "Unable to load extension due to error " + err.toString() );
                    }

					if (context != null)
					{
                        trace( "ExtensionContext got initialized" );
						context.addEventListener(StatusEvent.STATUS, onStatus);
					}
					else
					{
                        trace( "Unable to get ExtensionContext" );
						throw new Error("Context is null. Please use ANE library for using push notification " +
							"('com.backendless.AirPushNotification')");
					}
				}
			}
			else
			{
				throw new Error("This is a singleton, use PushNotification.instance, do not call the constructor directly");
			}
		}
		
		
		public static function get isSupported():Boolean
		{
            return (Capabilities.manufacturer.search('iOS') > -1 || Capabilities.manufacturer.search('Android') > -1);
		}
		
        /**
		 *  Register application for push notifications. Needs Project id for Android Notifications.
		 *  The project id is the one the developer used to register to GCM.
		 *  @param projectId: project id to use.
		 */
		public function register(projectId:String = null, pushCallback:Function = null ):void
		{
			if (isSupported == true)
			{
                trace( "Calling registerPush" );
                context.actionScriptData = pushCallback;
				context.call("registerPush", projectId);
			}
		}
		
		public function setBadgeNumberValue(value:int):void
		{
			if (isSupported == true)
			{
				context.call("setBadgeNb", value);
			}
		}
		
		/**
		 * Sends a local notification to the device.
		 * @param message the local notification text displayed
		 * @param timestamp when the local notification should appear (in sec)
		 * @param title (Android Only) Title of the local notification
		 * @param recurrenceType
		 * 
		 */
		public function sendLocalNotification(message:String, timestamp:int, title:String, recurrenceType:int = RECURRENCE_NONE):void
		{
			trace("[Push Notification]", "sendLocalNotification");

			if (PushNotification.isSupported)
				context.call("sendLocalNotification", message, timestamp, title, recurrenceType);
		}
		
		
		public function setIsAppInForeground(value:Boolean):void
		{
          if (PushNotification.isSupported)
				context.call("setIsAppInForeground", value);
		}
		
        // onStatus()
        // Event handler for the event that the native implementation dispatches.
        //
        protected function onStatus(event:StatusEvent):void
		{
            trace( "in onStatus - " + event.code + ". Level - " + event.level );

			if (PushNotification.isSupported == true)
			{
				switch (event.code)
				{
					case TOKEN_SUCCESS:
						lastToken = event.level;
						dispatchEvent(new PushNotificationEvent(PushNotificationEvent.GIVEN_TOKEN, lastToken))
						break;
					case TOKEN_FAULT:
						var faultEvent:PushNotificationEvent = new PushNotificationEvent(PushNotificationEvent.REFUSE_TOKEN , lastToken);
						faultEvent.errorMessage = event.level;
						faultEvent.errorCode = "NativeCodeError";
						dispatchEvent(faultEvent);
						break;
					case NOTIFICATION:
                        trace( "in NOTIFICATION case." );
						var notificationEvent:PushNotificationEvent = new PushNotificationEvent(PushNotificationEvent.NOTIFICATION, lastToken);
						var data:String = event.level;

                            trace( "data = " + data );
						if (data != null)
						{
							try
							{
//								notificationEvent.parameters = decodeJson(data);
								notificationEvent.data = data;
                               // var callbackFn:Function = context.actionScriptData as Function;
                               // callbackFn.call( null,  event );
								dispatchEvent(notificationEvent);
							}
							catch (error:Error)
							{
								trace("[PushNotification Error]", "cannot parse the params string", event.level);
							}
						}
						break;
					case LOGGING:
						trace(event, event.level);
						break;
				}
			}
		}


		private static var _instance:PushNotification;
		public static function get instance():PushNotification
		{
			return _instance ? _instance : new PushNotification();
		}
	}
}