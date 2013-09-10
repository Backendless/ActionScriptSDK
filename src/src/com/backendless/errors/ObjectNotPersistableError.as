package com.backendless.errors
{
	public class ObjectNotPersistableError extends Error
	{
		public function ObjectNotPersistableError(message:*="", id:*=0)
		{
			super(message, id);
		}
	}
}