package com.backendless.errors
{
	public class ConnectError extends Error
	{
		public function ConnectError(message:*="", id:*=0)
		{
			super(message, id);
		}
	}
}