package com.backendless.geo
{
	public class BackendlessGeoQuery extends PointBase
	{
		private var _searchRectangle:Array = [];
		private var _radius:Number;
		private var _units:String;
		private var _categories:Array = [];
		private var _metadata:Object = {};
		private var _includeMeta:Boolean;
		private var _pageSize:int;
		private var _offset:int;
		
		public function get offset():int
		{
			return _offset;
		}

		public function set offset(value:int):void
		{
			_offset = value;
		}

		public function get pageSize():int
		{
			return _pageSize;
		}

		public function set pageSize(value:int):void
		{
			_pageSize = value;
		}

		public function get includeMeta():Boolean
		{
			return _includeMeta;
		}

		public function set includeMeta(value:Boolean):void
		{
			_includeMeta = value;
		}

		public function get metadata():Object
		{
			return _metadata;
		}

		public function set metadata(value:Object):void
		{
			_metadata = value;
		}

		public function get categories():Array
		{
			return _categories;
		}

		public function set categories(value:Array):void
		{
			_categories = value;
		}

		public function get units():String
		{
			return _units;
		}

		public function set units(value:String):void
		{
			_units = value;
		}

		public function get radius():Number
		{
			return _radius;
		}

		public function set radius(value:Number):void
		{
			_radius = value;
		}

		public function get searchRectangle():Array
		{
			return _searchRectangle;
		}

		public function set searchRectangle(value:Array):void
		{
			_searchRectangle = value;
		}

		public function addMetadata(key:*, value:*):void
		{
			if(key == null || value == null) {
				throw new Error("Neither null key nor null value is allowed");
			}
			if(_metadata == null) {
				_metadata = new Object();
			}
			
			_metadata[key] = value;
		}

	}
}