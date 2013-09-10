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
    import mx.rpc.IResponder;

    public class Subscription
    {
        public function Subscription(subscriptionId:String = null)
        {
            this.subscriptionId = subscriptionId;
        }


        //Current sdk implementation doesn't support subscription cancelling from the Subscription instance
        /*public function cancelSubscription(responder:IResponder = null):Boolean
        {
            return false;
        }*/

        // ------------------------------
        //  Subscription Id
        // ------------------------------
        private var _subscriptionId:String;
        /**
         *  The subscription Id by subscription to defined channel.
         */
        public function get subscriptionId():String
        {
            return _subscriptionId;
        }
        /**
         *  @private
         */
        public function set subscriptionId(value:String):void
        {
            _subscriptionId = value;
        }
    }
}
