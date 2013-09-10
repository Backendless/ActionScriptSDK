package com.backendless.property
{
	public dynamic class AbstractProperty
	{
		private var _name:String;
		private var _required:Boolean;
		private var _type:String;
		private var _defaultValue:Object;
		
		public function get name():String
		{
			return _name;
		}
		
		public function set name(value:String):void
		{
			_name = value;
		}
		
		public function get isRequired():Boolean
		{
			return _required;
		}
		
		public function set required(value:Boolean):void
		{
			_required = value;
		}
		
		public function get type():String
		{
			return _type;
		}
		
		public function set type(value:String):void
		{
			_type = value;
		}

		public function get defaultValue():Object
		{
			return _defaultValue;
		}

		public function set defaultValue(value:Object):void
		{
			_defaultValue = value;
		}
	}
}