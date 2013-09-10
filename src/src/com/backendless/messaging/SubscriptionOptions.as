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
    public final class SubscriptionOptions
    {
        public function SubscriptionOptions(subtopicValue:String = null, selectorValue:String = null)
        {
            this.subtopic = subtopicValue;
            this.selector = selectorValue;
        }

        // ------------------------------
        //  Subtopic
        // ------------------------------
        private var _subtopic:String;
        /**
         *  String value - name of the subtopic to subscribe to
         */
        public function get subtopic():String
        {
            return _subtopic;
        }
        /**
         *  @private
         */
        public function set subtopic(value:String):void
        {
            _subtopic = value;
        }

        // ------------------------------
        //  Selector
        // ------------------------------
        private var _selector:String;
        /**
         *  String query in the SQL-92 format (the where clause).
         */
        public function get selector():String
        {
            return _selector;
        }
        /**
         *  @private
         */
        public function set selector(value:String):void
        {
            _selector = value;
        }

        // ------------------------------
        //  Subscriber Id
        // ------------------------------
        private var _subscriberId:String;
        /**
         *  String value identifying subscriber.
         */
        public function get subscriberId():String
        {
            return _subscriberId;
        }
        /**
         *  @private
         */
        public function set subscriberId(value:String):void
        {
            _subscriberId = value;
        }
    }
}