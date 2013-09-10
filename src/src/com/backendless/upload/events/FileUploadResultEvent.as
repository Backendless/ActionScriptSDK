package com.backendless.upload.events
{
	import com.backendless.messaging.Message;
	
	import flash.events.Event;
	
	public class FileUploadResultEvent extends Event
	{
		public static const FILE_UPLOAD_RESULT:String = "fileUploadResultEvent";
		
		private var _actionId:String;
		private var _message:String;
		
		public function FileUploadResultEvent(actionIdValue:String, resultMessage:String)
		{
			_actionId = actionIdValue;
			_message = resultMessage;
			
			super(FILE_UPLOAD_RESULT);
		}
		
		public function get actionId():String
		{
			return _actionId;
		}
		
		public function get message():String
		{
			return _message;
		}
	}
}