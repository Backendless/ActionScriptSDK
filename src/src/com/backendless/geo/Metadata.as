package com.backendless.geo
{
	[RemoteClass(alias="com.backendless.geo.model")]
	public class Metadata
	{
		private var _id:Number;
		private var _key:String;
		private var _value:String;
		
		private var _geoPoint:GeoPoint;
		
		
		public function get id():Number
		{
			return _id;
		}

		public function set id(value:Number):void
		{
			_id = value;
		}

		public function get key():String
		{
			return _key;
		}

		public function set key(value:String):void
		{
			_key = value;
		}

		public function get value():String
		{
			return _value;
		}

		public function set value(value:String):void
		{
			_value = value;
		}

		public function get geoPoint():GeoPoint
		{
			return _geoPoint;
		}

		public function set geoPoint(value:GeoPoint):void
		{
			_geoPoint = value;
		}


	}
}