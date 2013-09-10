package com.backendless.upload.events
{
	import flash.events.Event;
	
	public class FileUploadFaultEvent extends Event
	{
		public static const FILE_UPLOAD_FAULT:String = "fileUploadFaultEvent";
		
		private var _actionId:String;
		private var _message:String;
		private var _cause:Event;
		
		public function FileUploadFaultEvent(actionIdValue:String, message:String, cause:Event = null)
		{
			_actionId = actionIdValue;
			_message = message;
			_cause = cause;
			super(FILE_UPLOAD_FAULT);
		}
		
		public function get actionId():String
		{
			return _actionId;
		}
		
		public function get message():String
		{
			return _message;
		}
		
		public function get cause():Event
		{
			return _cause;
		}
	}
}