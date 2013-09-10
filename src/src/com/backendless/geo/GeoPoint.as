package com.backendless.geo
{

	[RemoteClass(alias="com.backendless.geo.model.GeoPoint")]
	public class GeoPoint extends PointBase
	{
		private var _objectId:String;
		private var _categories:Array;                                                                                                                 
		private var _metadata:Object = {};

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


		public function addCategory(category:GeoCategory):void
		{
			if(_categories == null) {
				_categories = [];
			}
			_categories.push(category.name);
		}
		
		public function addMetadata(value:Metadata):void
		{
			_metadata[value.key] = value.value;
		}
	}
}