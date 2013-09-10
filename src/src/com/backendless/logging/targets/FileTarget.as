package com.backendless.logging.targets
{
import com.backendless.validators.ArgumentValidator;

import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;

import mx.core.mx_internal;
import mx.logging.targets.LineFormattedTarget;

use namespace mx_internal; 

public class FileTarget extends LineFormattedTarget
{

	private var logFile:File;
	private var fileStream:FileStream;

	/**
	 * @param location path to log file. relative to application storage directory
	 */
	public function FileTarget(location:String)
	{
		logFile = File.applicationStorageDirectory.resolvePath(location);
		ArgumentValidator.notNull(logFile, "cant create file " + location);
		fileStream = new FileStream();
		includeCategory = true;
		includeDate = true;
		includeLevel = true;
		includeTime = true;
	}

	override mx_internal function internalLog(message:String):void
	{
		try
		{
			fileStream.open(logFile, FileMode.APPEND);
			fileStream.writeUTFBytes(message);
			fileStream.writeUTFBytes("\n");
			fileStream.close();
		}
		catch (err:Error)
		{
			trace(err.getStackTrace());
		}
	}
}
}