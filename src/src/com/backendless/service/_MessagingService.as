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
package com.backendless.service
{
	import com.backendless.Backendless;
	import com.backendless.config.BackendlessConfig;
	import com.backendless.helpers.ClassHelper;
	import com.backendless.messaging.DeliveryOptions;
	import com.backendless.messaging.DeviceRegistration;
	import com.backendless.messaging.ISubscriptionResponder;
	import com.backendless.messaging.PublishOptions;
	import com.backendless.messaging.Subscription;
	import com.backendless.messaging.SubscriptionOptions;
	import com.backendless.messaging.PushNotification;
	import com.backendless.messaging.PushNotificationEvent;
	import com.backendless.rpc.BackendlessClient;

	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	import mx.collections.ArrayCollection;
	//import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.rpc.AsyncToken;
import mx.rpc.Fault;
import mx.rpc.IResponder;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;

	public class _MessagingService extends BackendlessService
	{
        public static const IOS:String = "IOS";
        public static const ANDROID:String = "ANDROID";
		private static const MESSAGING_SERVICE_SOURCE:String = "com.backendless.services.messaging.MessagingService";
		private static const DEVICE_SERVICE_SOURCE:String = "com.backendless.services.messaging.DeviceRegistrationService";

		public function _MessagingService():void
		{
		}

		private var channelName:String;
		private var responder:ISubscriptionResponder;
		private var timer:Timer;
		private var deviceRegistration:DeviceRegistration = new DeviceRegistration();

		private var _subscription:Subscription;

		public function get subscription():Subscription
		{
			return _subscription;
		}

		/**
		 *  Backendless.Messaging.registerDevice();
		 *  Backendless.Messaging.registerDevice(deviceRegistration:DeviceRegistration);
		 *
		 *  @param registration custom data for registration (optional).
		 *  @param async custom responder for user action after success function (optional).
		 *
		 *  @see com.backendless.messaging.DeviceRegistration
		 */
		public function registerDevice(deviceRegistration:DeviceRegistration,
			pushCallback:Function, async:IResponder = null):DeviceRegistration
		{
			// check using AIR
			if (ClassHelper.isAIR() == false)
			{
			//	Alert.show("Device registration is available only on mobile devices in applications compiled with the Adobe AIR SDK",
			//		"Warning", Alert.OK, FlexGlobals.topLevelApplication as Sprite);
				return null;
			}

            this.deviceRegistration = deviceRegistration ? deviceRegistration : new DeviceRegistration();

            if( this.deviceRegistration.os == IOS )
              handleIOSRegistration( pushCallback, async );
            else if(  this.deviceRegistration.os == ANDROID )
              handleAndroidRegistration( pushCallback, async );

			return this.deviceRegistration;
		}

		public function getDeviceRegistration(async:IResponder = null):AsyncToken
		{
			var token:AsyncToken = BackendlessClient.instance.invoke(DEVICE_SERVICE_SOURCE, "getDeviceRegistrationByDeviceId",
				[
					Backendless.appId,
					Backendless.version,
					deviceRegistration.deviceId
				], async);

			token.addResponder(
				new Responder(
					function(event:ResultEvent):void
					{
						trace(event.result);
					},
					function(event:FaultEvent):void
					{
						onFault(event, async);
					}
				)
			);

			return token;
		}

		public function unregisterDevice(async:IResponder = null):AsyncToken
		{
			var token:AsyncToken = BackendlessClient.instance.invoke(DEVICE_SERVICE_SOURCE, "unregisterDevice",
				[
					Backendless.appId,
					Backendless.version,
					deviceRegistration.deviceId
				], async);

			token.addResponder(
				new Responder(
					function(event:ResultEvent):void
					{
						deviceRegistration.expiration = null;
						deviceRegistration.channels = null;
					},
					function(event:FaultEvent):void
					{
						onFault(event, async);
					}
				)
			);

			return token;
		}

      /**
    		 *  Message Subscription.
    		 *  <p>Subscribing to a channel may be done differently for different clients. To simplify
    		 *  the process of subscription for a developer, the client side should automatically
    		 *  determine the correct port or endpoint for a channel. As a result, the client should
    		 *  ask the server for the proper connection attributes before the actual subscription takes
    		 *  place.</p>
    		 *
    		 *  <p><b>Note</b>: Message subscription requires application initialization:</p>
    		 *  @example
    		 *	  Backendless.initApp(appId, secretKey, versionNum);
    		 *
    		 *  @param channelName The name of channel for subscribing.
    		 *  @param responder The subscription responder
    		 *  @param subscriptionOptions The params for subscribing (optional).
    		 *  @param async:IResponder (optional).
    		 *
    		 *  @see com.backendless.messaging.ISubscriptionResponder
    		 *  @see com.backendless.messaging.SubscriptionOptions
    		 */
    		public function subscribe( responder:ISubscriptionResponder,
    			subscriptionOptions:SubscriptionOptions = null, async:IResponder = null):AsyncToken
    		{
    			return subscribeToChannel( "default", responder, subscriptionOptions, async );
    		}

		/**
		 *  Message Subscription.
		 *  <p>Subscribing to a channel may be done differently for different clients. To simplify
		 *  the process of subscription for a developer, the client side should automatically
		 *  determine the correct port or endpoint for a channel. As a result, the client should
		 *  ask the server for the proper connection attributes before the actual subscription takes
		 *  place.</p>
		 *
		 *  <p><b>Note</b>: Message subscription requires application initialization:</p>
		 *  @example
		 *	  Backendless.initApp(appId, secretKey, versionNum);
		 *
		 *  @param channelName The name of channel for subscribing.
		 *  @param responder The subscription responder
		 *  @param subscriptionOptions The params for subscribing (optional).
		 *  @param async:IResponder (optional).
		 *
		 *  @see com.backendless.messaging.ISubscriptionResponder
		 *  @see com.backendless.messaging.SubscriptionOptions
		 */
		public function subscribeToChannel(channelName:String, responder:ISubscriptionResponder,
			subscriptionOptions:SubscriptionOptions = null, async:IResponder = null):AsyncToken
		{
			this.responder = responder;
			this.channelName = channelName;
			var token:AsyncToken = BackendlessClient.instance.invoke(MESSAGING_SERVICE_SOURCE, "subscribeForPollingAccess",
				[
					Backendless.appId,
					Backendless.version,
					channelName,
					subscriptionOptions
				],
				new Responder(onSubscribeResult, onSubscribeFault));
			token.addResponder(async);
			return token;
		}

		public function unsubscribe(responder:IResponder = null):void
		{
			//subscription.cancelSubscription(responder);
			cleanup();

            if( responder != null )
              responder.result( null );
		}

		/**
		 *  Message Publishing to custom channel.
		 *
		 *  <p><b>Note</b>: Message publishing requires application initialization:</p>
		 *  @example
		 *	  Backendless.initApp(appId, secretKey, versionNum);
		 *
		 *  @param channelName
		 *  @param message
		 *  @param publishInfo
		 *  @param deliveryOptions
		 *  @param async
		 *
		 *  @see com.backendless.messaging.PublishOptions
		 *  @see com.backendless.messaging.DeliveryOptions
		 */
		public function publishToChannel(channelName:String, message:*, publishInfo:PublishOptions = null,
			 deliveryOptions:DeliveryOptions = null, async:IResponder = null):AsyncToken
		{
			var token:AsyncToken = BackendlessClient.instance.invoke(MESSAGING_SERVICE_SOURCE, "publish",
				[
					Backendless.appId,
					Backendless.version,
					channelName,
					message,
					null == publishInfo ? new PublishOptions() : publishInfo,
					deliveryOptions
				]
			);
			token.addResponder(async);

			return token;
		}

		/**
		 *  Message Publishing to default channel.
		 *
		 *  <p><b>Note</b>: Message publishing requires application initialization:</p>
		 *  @example
		 *	  Backendless.initApp(appId, secretKey, versionNum);
		 *
		 *  @param message
		 *  @param publishInfo
		 *  @param deliveryOptions
		 *  @param async
		 *
		 *  @see com.backendless.messaging.PublishOptions
		 *  @see com.backendless.messaging.DeliveryOptions
		 */
		public function publish(message:*, publishInfo:PublishOptions = null, deliveryOptions:DeliveryOptions = null,
			async:IResponder = null):AsyncToken
		{
			return publishToChannel( "default", message, publishInfo, deliveryOptions, async);
		}

		/**
		 *  Cancel Scheduled Message.
		 *
		 *  <p><b>Note</b>: Cancel scheduled message requires application initialization:</p>
		 *  @example
		 *	  Backendless.initApp(appId, secretKey, versionNum);
		 *
		 *  @param messageId The scheduled message ID to cancel.
		 *  @param async
		 */
		public function cancel(messageId:String, async:IResponder = null):AsyncToken
		{
			var token:AsyncToken = BackendlessClient.instance.invoke(MESSAGING_SERVICE_SOURCE, "cancel",
				[
					Backendless.appId,
					Backendless.version,
					messageId
				]
			);
			token.addResponder(async);
			return token;
		}

		private function initTimer():void
		{
			timer = new Timer(BackendlessConfig.instance.messaging.pollingDelay);
			timer.addEventListener(TimerEvent.TIMER, onTimerEvent);
			timer.start();
		}

		private function pollMessages():void
		{
			BackendlessClient.instance.invoke(MESSAGING_SERVICE_SOURCE, "pollMessages",
				[
					Backendless.appId,
					Backendless.version,
					channelName,
					subscription.subscriptionId
				],
				new Responder(onMessagesPolledResult, onMessagesPooledFault));
		}

		private function cleanup():void
		{
          if( timer != null )
          {
			timer.stop();
			timer.reset();
          }

		  _subscription = null;
		}

        private function handleIOSRegistration( pushCallback:Function,  async:IResponder ):void
        {

        }

        private function handleAndroidRegistration( pushCallback:Function,  async:IResponder ):void
        {
            PushNotification.instance.addEventListener(PushNotificationEvent.NOTIFICATION, function( evt:PushNotificationEvent ):void
            {
                pushCallback.call( null, evt );
            });

            PushNotification.instance.addEventListener(PushNotificationEvent.REFUSE_TOKEN, function( evt:PushNotificationEvent ):void
            {
                var fault:Fault = new Fault( evt.errorCode, evt.errorMessage );
                onFault( new FaultEvent( evt.type, evt.bubbles, evt.cancelable, fault, null, null ), async );
            });

            PushNotification.instance.addEventListener(PushNotificationEvent.GIVEN_TOKEN, function( evt:PushNotificationEvent ):void
            {
               trace( "received token " + evt.token );
               deviceRegistration.deviceToken = evt.token;

               var token:AsyncToken = BackendlessClient.instance.invoke(DEVICE_SERVICE_SOURCE, "registerDevice",
                    [
                        Backendless.appId,
                        Backendless.version,
                        deviceRegistration
                    ], async);

               token.addResponder(
                    new Responder(
                        onDeviceRegistered,
                        function(event:FaultEvent):void
                        {
                            onFault(event, async);
                        }
                    )
                );
            });

          PushNotification.instance.register(deviceRegistration.gcmSenderId, pushCallback );
        }

		protected function onGivenTokenSuccess(event:PushNotificationEvent):void
		{
			deviceRegistration.deviceToken = event.token;
		}

		protected function onGivenTokenFault(event:PushNotificationEvent):void
		{
			deviceRegistration.deviceToken = null;
			trace("get token failed :", event.errorCode, ":", event.errorMessage);
		}

		protected function onDeviceRegistered(event:ResultEvent):void
		{
			deviceRegistration.id = event.result as String;
		}

		protected function onSubscribeResult(event:ResultEvent):void
		{
			_subscription = new Subscription(event.result as String);

			initTimer();
		}

		private function onSubscribeFault(event:FaultEvent):void
		{
			trace("onSubscribeFault: " + event);
		}

		private function onMessagesPolledResult(event:ResultEvent):void
		{
            var result:Array = event.result as Array;

			if( result.length > 0 )
			    responder.received(new ArrayCollection(result));

			timer.start();
		}

		private function onMessagesPooledFault(event:FaultEvent):void
		{
			responder.error(event);

			timer.start(); // this is a stub. has to be processed correctly
		}

		private function onTimerEvent(event:TimerEvent):void
		{
			pollMessages();
			timer.reset();
		}
	}
}