package com.b99.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author bosworth99
	 */
	public class AppEvents extends Event
	{
		public static const APP_READY		:String = "application ready";
		public static const XML_LOADED		:String = "XML has loaded";
		public static const XML_PARSED		:String = "XML has been parsed";
		public static const CHANGE_COMPLETE	:String = "state change complete";
		public static const PAGE_ADDED		:String = "page content added";
		public static const PAGE_REMOVED	:String = "page content removed";
		public static const INFO_ADDED		:String = "pane info added";
		public static const INFO_REMOVED	:String = "pane info removed";
		public static const LIBRARY_LOADED	:String = "external library loaded";
		public static const IMAGE_LOADED	:String = "external image loaded";
		public static const LOAD_ERROR		:String = "external load failed";
		
		public var arg:*;
		
		public function AppEvents(type:String, bubbles:Boolean = false, cancelable:Boolean = false, ...a:*) 
		{
			super(type, bubbles, cancelable);
			arg = a;
		}
		
		override public function clone():Event 
		{
			return new AppEvents(type, bubbles, cancelable, arg);
		}
		
	}
}
// use of custom event
//
//addEventListener(AppEvents.CHANGE_COMPLETE, changeComplete, false, 0, true);
//
//in responding class, any any extra parameters:
//var testParams:Array = new Array("one", "two");
//this.dispatchEvent(new AppEvents(AppEvents.CHANGE_COMPLETE, false, false, testParams, "hello", 12));
//
//private function changeComplete(e:AppEvents):void
//{ 
//	-- catch them via indexes
// trace(e.arg[0]); // one,two
// trace(e.arg[1]); // hello
// trace(e.arg[2]); // 12
//removeEventListener(AppEvents.CHANGE_COMPLETE, stateChangeComplete);
//}

