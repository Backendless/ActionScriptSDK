package com.backendless.validators
{
	import com.backendless.errors.InvalidArgumentError;
	
	public class ArgumentValidator
	{
		private static const DEFAULT_NULL:String = "the value can't be null";
		private static const DEFAULT_EMPTY:String = "the value can't be empty";
		private static const DEFAULT_NEGATIVE:String = "the value can't be negative";
		private static const DEFAULT_VALIDATE:String = "the value not passed validation";
			
		
		public static function notNull(property:*, message:String = null):void
		{
			if (property == null)
				throw new InvalidArgumentError((null == message) ? DEFAULT_NULL : message);
		}
	
		public static function notEmpty(property:*, message:String = null):void
		{
			if (property == "")
				throw new InvalidArgumentError((null == message) ? DEFAULT_EMPTY : message);
		}
	
		public static function notNegative(value:Number, message:String = null):void
		{
			if (value < 0)
				throw new InvalidArgumentError((null == message) ? DEFAULT_NEGATIVE : message);
		}
	
		public static function validate(value:*, validateFunction:Function, message:String = null):void
		{
			if (!validateFunction(value))
				throw new InvalidArgumentError((null == message) ? DEFAULT_VALIDATE : message);
		}
	}
}