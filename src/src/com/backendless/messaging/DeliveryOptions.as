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
    [RemoteClass(alias="com.backendless.services.messaging.DeliveryOptions")]
    public class DeliveryOptions
    {
        public static const PUSHPOLICY_ALSO:int = 0;
        public static const PUSHPOLICY_ONLY:int = 1;

        public static const IOS:int = 1;
        public static const ANDROID:int = 1 << 1;
        public static const WP:int = 1 << 2;
        public static const ALL:int = IOS | ANDROID | WP;

        // accepts a list of registered device IDs to deliver the message to
        private var _pushSinglecast:Array = [];
        // accepts a mask value used by Backendless to route the message
        // to the registered devices with the specified operating system.
        // The mask value may consist of the following values:
        // DeliveryOptions.IOS, DeliveryOptions.ANDROID, DeliveryOptions.WP
        // and DeliveryOptions.ALL
        private var _pushBroadcast:int = ALL;
        // the value indicates whether the message is both a pub/sub message
        // AND a push notification or only a push notification. Acceptable
        // values are: DeliveryOptions.PUSHPOLICY_ALSO and DeliveryOptions.PUSHPOLICY_ONLY
        private var _pushPolicy:int = PUSHPOLICY_ALSO;
        // sets the time when the message should be published
        private var _publishAt:Date;
        // sets the interval as the number of milliseconds repeated message publications.
        // When a value is set Backendless re-publishes the message with the interval.
        private var _repeatEvery:Number;
        // sets the time when the message republishing configured with "repeatEvery" should stop
        private var _repeatExpiresAt:Date;

        public function DeliveryOptions()
        {
        }


        public function get repeatExpiresAt():Date
        {
            return _repeatExpiresAt;
        }

        public function set repeatExpiresAt(value:Date):void
        {
            _repeatExpiresAt = value;
        }

        public function get repeatEvery():Number
        {
            return _repeatEvery;
        }

        public function set repeatEvery(value:Number):void
        {
            _repeatEvery = value;
        }

        public function get publishAt():Date
        {
            return _publishAt;
        }

        public function set publishAt(value:Date):void
        {
            _publishAt = value;
        }

        public function get pushSinglecast():Array
        {
            return _pushSinglecast;
        }

        public function set pushSinglecast(value:Array):void
        {
            _pushSinglecast = value;
        }

        public function get pushBroadcast():int
        {
            return _pushBroadcast;
        }

        public function set pushBroadcast(value:int):void
        {
            _pushBroadcast = value;
        }

        public function get pushPolicy():int
        {
            return _pushPolicy;
        }

        public function set pushPolicy(value:int):void
        {
            _pushPolicy = value;
        }
    }
}