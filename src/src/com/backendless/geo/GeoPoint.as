package com.backendless.geo
{

	[RemoteClass(alias="com.backendless.geo.model.GeoPoint")]
	public class GeoPoint extends PointBase
	{
		private var _objectId:String;
		private var _categories:Array;                                                                                                                 
		private var _metadata:Object = {};
		private var _distance:Number;

		public function get objectId():String
		{
			return _objectId;
		}

		public function set objectId(value:String):void
		{
			_objectId = value;
		}

		public function get categories():Array
		{
			return _categories;
		}

		public function set categories(value:Array):void
		{
			_categories = value;
		}

		public function get metadata():Object
		{
			return _metadata;
		}

		public function set metadata(value:Object):void
		{
			_metadata = value;
		}
		
		public function get distance():Number
		{
			return _distance;
		}
		
		public function set distance( value:Number ):void
		{
			this._distance = value;
		}

		public function addCategory( categoryName:String ):void
		{
			if(_categories == null) {
				_categories = [];
			}
			_categories.push(categoryName);
		}
		
		public function addMetadata(value:Metadata):void
		{
			_metadata[value.key] = value.value;
		}
		
		public function set ___class( value:String ):void
		{
			
		}
	}
}