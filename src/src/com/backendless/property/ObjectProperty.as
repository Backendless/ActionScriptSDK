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
package com.backendless.property
{
	[RemoteClass(alias="com.backendless.services.persistence.ObjectProperty")]
	public class ObjectProperty extends AbstractProperty
	{
		private var _relatedTable:String;
		
		
		public function get relatedTable():String
		{
			return _relatedTable;
		}

		public function set relatedTable(value:String):void
		{
			_relatedTable = value;
		}


	}
}