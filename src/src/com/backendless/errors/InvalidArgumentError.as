package com.backendless.errors
{
	public class InvalidArgumentError extends Error
	{
		public function InvalidArgumentError(message:*="", id:*=0)
		{
			super(message, id);
		}
	}
}