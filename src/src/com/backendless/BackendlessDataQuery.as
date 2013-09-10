package com.backendless
{
	public class BackendlessDataQuery
	{
		private var _properties:Array = [];
		private var _whereClause:String;
		private var _queryOptions:QueryOptions = new QueryOptions;
		private var _columnNamesMap:Object = new Object();
		
		public function get valid():Boolean {
			return true;
		}

		public function get properties():Array
		{
			return _properties;
		}

		public function set properties(value:Array):void
		{
			_properties = value;
		}

		public function get whereClause():String
		{
			return _whereClause;
		}

		public function set whereClause(value:String):void
		{
			_whereClause = value;
		}

		public function get queryOptions():QueryOptions
		{
			return _queryOptions;
		}

		public function set queryOptions(value:QueryOptions):void
		{
			_queryOptions = value;
		}

		public function get columnNamesMap():Object
		{
			return _columnNamesMap;
		}

		public function set columnNamesMap(value:Object):void
		{
			_columnNamesMap = value;
		}

	}
}