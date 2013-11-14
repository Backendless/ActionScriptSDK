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
	import com.backendless.Backendless;
	
	import mx.messaging.MessageAgent;
	import mx.messaging.channels.AMFChannel;
	import mx.messaging.messages.IMessage;
	
	/**
	 * Extends the AMFChannel channel in order to pass the custom headers
	 * 
	 * the BackendlessChannel class ovverides the send(agent:MessageAgent, message:IMessage):void
	 * function and provides custom <i>application-id</i> and <i>secret-key</i> headers to authenticate
	 * a call
	 * 
	 * @author Cyril Deba
	 */
	public class BackendlessChannel extends AMFChannel
	{
		public function BackendlessChannel(id:String=null, uri:String=null)
		{
			super(id, uri);
		}
		
		public override function send(agent:MessageAgent, message:IMessage):void 
		{
			message.headers = Backendless.headers;
			super.send(agent, message);
		}
	}
}