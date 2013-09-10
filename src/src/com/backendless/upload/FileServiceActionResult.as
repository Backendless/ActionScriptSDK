package com.backendless.upload
{
	[RemoteClass(alias="com.backendless.services.file.FileServiceActionResult")]
	public class FileServiceActionResult
	{
		private var _error:Boolean;
		private var _message:String;
		
		
		public function get error():Boolean
		{
			return _error;
		}

		public function set error(value:Boolean):void
		{
			_error = value;
		}

		public function get message():String
		{
			return _message;
		}

		public function set message(value:String):void
		{
			_message = value;
		}
	}
}