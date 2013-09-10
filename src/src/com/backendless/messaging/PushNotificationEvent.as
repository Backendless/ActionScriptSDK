package com.backendless.messaging
{
	import flash.events.Event;
	
	public class PushNotificationEvent extends Event
	{
		public static const GIVEN_TOKEN:String = "givenToken";
		public static const REFUSE_TOKEN:String = "refuseToken";
		public static const NOTIFICATION:String = "notification";

		public var token : String;
		public var errorCode : String;
		public var errorMessage : String;
		public var data:Object;
		
		public function PushNotificationEvent(type:String, token:String,
			bubbles:Boolean = false, cancelable:Boolean = false)
		{
			this.token = token;
			super(type, bubbles, cancelable);
		}

		override public function clone():Event
		{
			var event:PushNotificationEvent = new PushNotificationEvent(type, token, bubbles, cancelable);
			event.errorCode = errorCode;
			event.errorMessage = errorMessage;
			event.data = data;
			return event;
		}
	}
}