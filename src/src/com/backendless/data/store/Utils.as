package com.backendless.data.store
{
	import flash.utils.getQualifiedClassName;
	
	import mx.utils.ObjectUtil;

	public class Utils
	{
		public static function addClassName(dataObject:*, isRoot:Boolean ):void 
		{
			if( dataObject is Array )
			{
				for( var prop:* in dataObject )
					addClassName( dataObject[ prop ], false );
			}
			else if( !ObjectUtil.isSimple( dataObject ) )
			{
				var objInfo:Object = ObjectUtil.getClassInfo( dataObject );
				
				for each(var item:QName in objInfo.properties) 
				{
					var obj:* = dataObject[ item.localName ];
					
					if( obj != null && (!ObjectUtil.isSimple( obj ) || obj is Array) ) 
						addClassName( obj, false );
				}
				
				if( !isRoot && !dataObject.hasOwnProperty( "___class" ) )
				{
					if( !ObjectUtil.isDynamicObject( dataObject ) )
						throw new Error( "Cannot save/update object. Either declare '___class' property in all related objects. The property value must be the name of the class/table. Altenratively declare the class 'dynamic'" );
					
					var className:String  = getQualifiedClassName( dataObject );
					var dot:int = className.lastIndexOf( ":" );
					
					if( dot > -1 )
						className = className.substring( dot + 1 );
					
					dataObject[ "___class" ] = className;
				}					
			}
		}
	}
}