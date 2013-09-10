package com.backendless.geo
{
	[RemoteClass(alias="com.backendless.geo.model.GeoCategory")]
	public class GeoCategory
	{
		public static const CLASS_NAME:String = "com.backendless.geo.model.GeoCategory";
		
		private var _objectId:String;                                                                                                                               
		private var _name:String;                                                                                                                             
		private var _geopoints:Array; 

		public function get objectId():String
		{
			return _objectId;
		}

		public function set objectId(value:String):void
		{
			_objectId = value;
		}

		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}

		public function get geopoints():Array
		{
			return _geopoints;
		}

		public function set geopoints(value:Array):void
		{
			_geopoints = value;
		}
		
		public function addPoint(point:GeoPoint):void
		{
			if(_geopoints == null) {
				_geopoints = [];
			}
			
			_geopoints.push(point);
		}
	}
}