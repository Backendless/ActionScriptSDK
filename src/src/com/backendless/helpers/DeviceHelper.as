package com.backendless.helpers
{
import flash.data.EncryptedLocalStore;
import flash.system.Capabilities;
import flash.utils.ByteArray;
import flash.utils.ByteArray;
import flash.utils.getDefinitionByName;

import mx.utils.UIDUtil;

public class DeviceHelper
	{
		public static const WP:String  = "WP";
		public static const IOS:String = "IOS";
		public static const ANDROID:String = "ANDROID";
		public static const UNKNOWN:String = "UNKNOWN";
        private static const DEVICE_ID_TAG:String = "BackendlessDeviceId";


		private static function checkDeviceType():String
		{
			const manufacturer:String = Capabilities.manufacturer.toUpperCase();
			if (manufacturer.search(IOS) > -1) return IOS;
			if (manufacturer.search(ANDROID) > -1) return ANDROID;
			return UNKNOWN;
		}

		private static function getUniqueDeviceID():String
		{
            if (ClassHelper.isAIR() == false) return null;

            var deviceId:ByteArray = EncryptedLocalStore.getItem(DEVICE_ID_TAG);
            if(!deviceId)
            {
                deviceId = UIDUtil.toByteArray( UIDUtil.createUID() );
                EncryptedLocalStore.setItem(DEVICE_ID_TAG, deviceId);
            }

            return UIDUtil.fromByteArray(deviceId);
		}

		// -----------------------
		//  Device Type
		// -----------------------
		public static const type:String = checkDeviceType();

		// -----------------------
		//  Device Type
		// -----------------------
		public static const uniqueDeviceID:String = getUniqueDeviceID();
	}
}