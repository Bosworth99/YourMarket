///////////////////////////////////////////////////////////////////////////////
//
//	com>b99>app>AppData.as
//
//	extends : Object
//	
//	Container class for variables
//
///////////////////////////////////////////////////////////////////////////////

package com.b99.app 
{
	/**
	 * ...
	 * @author bosworth99
	 */
	public class AppData extends Object
	{
		//------------------- app vars
		static private var _stageH			:int;
		static private var _stageW			:int;
		
		//------------------- xml
		static private var _nonProfitXML	:XML;
		static private var _productXML		:XML;
		
		//------------------- utils
		static private var _isFancy			:Boolean = true;
		
		static private var _fps				:int = 0;
		static private var _deltaTime		:Number = 0;
		
		//------------------- navigation
		
		/**
		 * @private 
		 * store string representation of scene locations
		 * address _navLocations to determine transition target
		 */
		static private var _navLocations	:Array = [];
		/**
		 * @private 
		 * where navigation was
		 */
		static private var _oldLocation		:String;
		/**
		 * @private 
		 * where navigation is
		 */
		static private var _newLocation		:String;
		
		//------------------- boolean
		static private var _pageIsUp		:Boolean
		
		
		//------------------- external swfs
		/**
		 * @private
		 * list of external swfs to load
		 */
		static private var _libraryRefs		:Array = [];
		/**
		 * @private
		 * test whether the library has been loaded
		 */
		static private var _libraryLoaded	:Array = [];
		/**
		 * @private
		 * list of ASSET_DEF strings - name of external library to target
		 */
		static private var _libraries		:Array = [];
		/**
		 * @private
		 * array of arrays, each containing class references to the assets now 
		 * loaded from external swfs
		 */
		static private var _libraryCon		:Array = [];
		/**
		 * @private
		 * array of arrays, each containing strings related to the class references
		 * "IMG_vol_texture"  =>  [Class IMG_vol_texture]
		 */
		static private var _libraryNames	:Array = [];
		
		
		
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//									constructor (static)
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++																														
		public function AppData() 
		{
			super();
		}
		
		public static function ready():void 
		{
			trace("AppData.ready()");
		}
		
	//---------------------- stage
		static public function get stageH():int { return _stageH; }
		static public function set stageH(value:int):void 
		{
			_stageH = value;
		}
		
		static public function get stageW():int { return _stageW; }
		static public function set stageW(value:int):void 
		{
			_stageW = value;
		}
		
	//----------------------- xml data
		static public function get nonProfitXML():XML { return _nonProfitXML; }
		static public function set nonProfitXML(value:XML):void 
		{
			_nonProfitXML = value;
		}
		
		static public function get productXML():XML { return _productXML; }
		static public function set productXML(value:XML):void 
		{
			_productXML = value;
		}
		
	//----------------------- nav locations
		static public function get navLocations():Array { return _navLocations; }
		static public function set navLocations(value:Array):void 
		{
			_navLocations = value;
		}
		
		static public function get oldLocation():String { return _oldLocation; }
		static public function set oldLocation(value:String):void 
		{
			_oldLocation = value;
		}
		
		static public function get newLocation():String { return _newLocation; }
		static public function set newLocation(value:String):void 
		{
			_newLocation = value;
		}
		
		static public function get pageIsUp():Boolean { return _pageIsUp; }
		static public function set pageIsUp(value:Boolean):void 
		{
			_pageIsUp = value;
		}
		
	//------------------------ external libraries	
				

		static public function get libraryRefs():Array { return _libraryRefs; }
		static public function set libraryRefs(value:Array):void 
		{
			_libraryRefs = value;
		}
		
		static public function get libraryLoaded():Array { return _libraryLoaded; }
		static public function set libraryLoaded(value:Array):void 
		{
			_libraryLoaded = value;
		}
		
		static public function get libraries():Array { return _libraries; }
		static public function set libraries(value:Array):void 
		{
			_libraries = value;
		}
		
		static public function get libraryCon():Array { return _libraryCon; }
		static public function set libraryCon(value:Array):void 
		{
			_libraryCon = value;
		}
		
		static public function get libraryNames():Array { return _libraryNames; }
		static public function set libraryNames(value:Array):void 
		{
			_libraryNames = value;
		}

		
	//------------------------ utils
		static public function get isFancy():Boolean { return _isFancy; }
		static public function set isFancy(value:Boolean):void 
		{
			_isFancy = value;
		}
		
		static public function get fps():int { return _fps; }
		static public function set fps(value:int):void 
		{
			_fps = value;
		}
		
		static public function get deltaTime():Number { return _deltaTime; }
		static public function set deltaTime(value:Number):void 
		{
			_deltaTime = value;
		}
	}
}