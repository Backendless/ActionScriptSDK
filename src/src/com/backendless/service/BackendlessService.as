package com.backendless.service
{
import flash.events.EventDispatcher;

import mx.rpc.Fault;

import mx.rpc.IResponder;
import mx.rpc.events.FaultEvent;

public class BackendlessService extends EventDispatcher
{
	protected function onFault(event:FaultEvent, responder:IResponder):void
	{
		if (responder != null)
		{
			var fault:Fault = event.fault;
			responder.fault(FaultEvent.createEvent(new Fault(fault.faultCode, fault.faultString, fault.faultDetail)));
		}

		dispatchEvent(event);
	}
}
}