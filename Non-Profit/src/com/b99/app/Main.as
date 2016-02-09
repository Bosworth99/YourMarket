///////////////////////////////////////////////////////////////////////////////
//
//	com>b99>app>Main.as
//
//	extends : sprite
//
//	top level class
//	instantiate main controllers
//
///////////////////////////////////////////////////////////////////////////////

package com.b99.app
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import com.b99.utils.*;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author bosworth99
	 */
	public class Main extends Sprite 
	{
		//++++++++++++++++++++++ class references
		public static var appDisplay 	:AppDisplay;
		public static var dataLoader	:DataLoader;

		//++++++++++++++++++++++ 
		public static var mainStage		:Stage;
		public static var isTest		:Boolean;
		
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//									constructor
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		public function Main():void 
		{
			if (stage) 
			{ 
				init();
			}
			else
			{
				this.addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
			}
		}
		
		private function init(e:Event = null):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);

			activate();
		}
		
		private function activate():void 
		{
			//hello
			this.ready();
			AppData.ready();
			AppControl.ready();
			
			//assign vars
			mainStage = stage;	

			this.utilities();
			
			//activateApplication
			entryPoint();
		}
		
		private function ready():void
		{
			trace("Main.ready()")
		}
		
		private function entryPoint():void
		{
			trace("Main.entryPoint()")
			
			//display
			appDisplay = new AppDisplay();
			this.addChild(appDisplay);
			
			//data
			dataLoader = new DataLoader();
			
			//controlling logic
			AppControl.entryPoint();
		}

		private function utilities():void
		{
			isTest = false;
			
			//system resource useage
			Utility.memorize(); 
			
			//check framerate
			Utility.deltaTimer();
		}
		
//-----------------------------------------------------------------------------
//		end
//-----------------------------------------------------------------------------
	
	}
}