package com.backendless.errors
{
	public class ConfigurationError extends Error
	{
		public function ConfigurationError(message:*="", id:*=0)
		{
			super(message, id);
		}
	}
}