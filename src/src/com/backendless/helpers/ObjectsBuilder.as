package com.backendless.helpers
{
import com.backendless.BackendlessUser;
import com.backendless.errors.InvalidArgumentError;
import com.backendless.validators.ArgumentValidator;

import mx.core.ClassFactory;
import mx.utils.ObjectUtil;

[ExcludeClass]
public class ObjectsBuilder
{
	private static var builder:ClassFactory = new ClassFactory();

	public static function buildUser(source:Object = null):*
	{
		return updateUser(new BackendlessUser(), source);
	}

	public static function updateUser(target:BackendlessUser, source:Object = null):BackendlessUser
	{
		ArgumentValidator.notNull(target);
		if (source) for (var p:String in source)
			target.setProperty(p, source[p])
		return target;
	}

	public static function build(claz:Class, properties:Object = null):*
	{
		if (properties is claz) return properties;
		builder.generator = claz;
		return updateWith(builder.newInstance(), properties);
	}

	public static function updateWith(target:*, source:Object):*
	{
		ArgumentValidator.notNull(target);
		if (source)
		{
			var properties:Array = getProperties(source);
			for each (var property:String in properties)
			{
				if (property == "created" || !target.hasOwnProperty(property)) continue;
				try
				{
					target[property] = source[property];
				}
				catch (ex:Error)
				{
					// do nothing
					// property is read-only
					// skip it
				}
			}
		}
		return target;
	}

	private static function getProperties(instance:*):Array
	{
		var properties:Array = [];
		var classInfo:Object = ObjectUtil.getClassInfo(instance);
		for each (var property:QName in classInfo.properties)
		{
			properties.push(property.localName);
		}
		return properties;
	}
}
}
