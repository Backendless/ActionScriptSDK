package com.backendless.helpers
{
import com.backendless.errors.InvalidArgumentError;

import flash.system.Capabilities;
	import flash.utils.getQualifiedClassName;
	
	public final class ClassHelper
	{
		public static const SYSTEM_QUALIFIED_SEPARATOR:String = "::";
		public static const REQUIRED_QUALIFIED_SEPARATOR:String = ".";

		public static function isAIR():Boolean
		{
			return Capabilities.playerType == "Desktop";
		}
		
		public static function getCanonicalClassName(candidate:*):String {
			if(candidate == null) {
				return null;
			}
			return getQualifiedClassName(candidate).replace(SYSTEM_QUALIFIED_SEPARATOR, REQUIRED_QUALIFIED_SEPARATOR);
		}

		public static function getCanonicalShortClassName(candidate:*):String
		{
			if(!candidate) return null;
			if (candidate is Class)
			{
				var qualifiedClassName:String = getQualifiedClassName(candidate);
				var isInSystemFormat:Boolean = qualifiedClassName.indexOf(SYSTEM_QUALIFIED_SEPARATOR) != -1;
				var separator:String = isInSystemFormat ? SYSTEM_QUALIFIED_SEPARATOR : REQUIRED_QUALIFIED_SEPARATOR;
				var split:Array = qualifiedClassName.split(separator);
				if (split.length == 0) throw new InvalidArgumentError("invalid class name");
				return split[split.length - 1];
			}
			
			var s:String = String(candidate["constructor"]);
			return s.substring(7, s.length - 1);
		}
	}
}