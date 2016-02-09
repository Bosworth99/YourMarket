///////////////////////////////////////////////////////////////////////////////
//
//	com>b99>app>AppControl.as
//
//	extends : EventDispatcher
//	role	: Subject
//
//	AppControl is not instantiated
//	static methods to define app logic and control
//	all calls to change the state of the app runs through this class
//	provides macro control to the appdisplay class
//
//	primary points of communication: 
//	AppDisplay 	- control of display objects
//	AppData		- control of variables
//	DataLoader	- control of external loads
//
///////////////////////////////////////////////////////////////////////////////

package com.b99.app 
{
	import com.b99.events.AppEvents;
	import com.b99.utils.Utility;
	import com.greensock.TweenLite;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	
	import com.b99.app.*;
	import com.b99.utils.DataLoader;

	/**
	 * ...
	 * @author bosworth99
	 */
	public class AppControl extends Object
	{
		private static var _targetIndex	:int = -1;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//									constructor (static)
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++		
		public function AppControl() 
		{
			super();
		}

		public static function ready():void 
		{
			trace("AppControl.ready()");
		}

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//									data / asset loads
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++			
		

		/**
		 * called at the start of runtime, after main has instantiated the 
		 * essentials. all other activation events are directed here
		 * 
		 * first, we assign a couple variables used throughout the class
		 * and then we instigate the loading of external xml 
		 * (without which there is no app)
		 * 
		 */
		public static function entryPoint():void
		{	
			Main.dataLoader.addEventListener(AppEvents.XML_LOADED, AppControl.onDataLoad, false, 0, true);
			Main.dataLoader.loadXML();
		}
		
		/**
		 * when xml has loaded, direct dataloader to parse XML, prepping load of all external assets
		 * 
		 * synchronously, initialize internal data, and assemble the display, prepping for the dependent
		 * load of external assets. These two steps are independant of external assets.
		 * 
		 * @param	e
		 */
		private static function onDataLoad(e:AppEvents):void 
		{
			Main.dataLoader.removeEventListener(AppEvents.XML_LOADED, AppControl.onDataLoad);
			Main.dataLoader.addEventListener(AppEvents.XML_PARSED, AppControl.onDataParsed, false, 0, true);
			Main.dataLoader.parseXML();
			
			AppControl.initializeData();
			AppControl.initializeDisplay();
		}
		
		/**
		 * when xml has been distributed, activate the load sequence
		 * 
		 * @param	e
		 */
		private static function onDataParsed(e:AppEvents):void
		{
			Main.dataLoader.removeEventListener(AppEvents.XML_PARSED, AppControl.onDataParsed);
			Main.dataLoader.loadExternalLibraries();
		}

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//									Activate Application
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

		/**
		 * assign top level variables and data structure during intialization
		 * all variable control run through AppData
		 * 
		 * ### update
		 * when trying to plant the final project into the page within a NO_SCALE preloader
		 * and and a outer div of varying size, i had to force the stageH and stageW to fixed
		 * numbers. This is fine, as the layout isn't liquid, anyway. but what was happeing is the 
		 * child swf was registering the stage size of the parent (something less than 960x700) and 
		 * registering that as the placement of "many" objects (anything based on AppData.stageX). 
		 * when planted on the page, however, the effect was that of a full layout (960x700) with 
		 * contents displayed at whatever the smaller size was. In effect, a small portion of 
		 * content in the upper left corner of a white block. 
		 * 
		 * At the SHOW_ALL default, the loaded content was scaling correctly, but the content was 
		 * mis-registering.
		 * 
		 * ugh. wasted two days figuring that out...
		 * 
		 */
		private static function initializeData():void
		{
			//AppData.stageH = Main.mainStage.stageHeight;
			//AppData.stageW = Main.mainStage.stageWidth;
			
			AppData.stageH = 700;
			AppData.stageW = 960;
		}

		/**
		 * tell appDisplay descendants to populate the display list
		 * when complete, activate app logic
		 */
		private static function initializeDisplay():void
		{
			Main.appDisplay.addEventListener(AppEvents.APP_READY, AppControl.activateApplication, false, 0, true);
			Main.appDisplay.assembleDisplayLayers();
		}
		
		/**
		 * when appDisplay has populated, add swfinit listener (this registers 
		 * whatever is in the url) assign the initial location in the responding 
		 * function
		 * @param	e
		 */
		private static function activateApplication(e:AppEvents):void
		{	
			trace("AppControl.activateApplication")
			Main.appDisplay.removeEventListener(AppEvents.APP_READY, AppControl.activateApplication);

			Main.appDisplay.navigation.addEventListener(AppEvents.APP_READY, AppControl.activateNavigation, false, 0, true);
			Main.appDisplay.userInferace.assembleNavObjects();
			Main.appDisplay.navigation.assembleNavigation();
		}

		/**
		 * event fired from navigation, once display has assembled.
		 * 
		 * 
		 */
		private static function activateNavigation(e:AppEvents):void
		{
			Main.appDisplay.navigation.removeEventListener(AppEvents.APP_READY, AppControl.activateNavigation);
			
			Main.appDisplay.overlay.addBars();
			Main.appDisplay.navigation.entryPoint();
			Main.appDisplay.removeIntroMask();
			
			AppControl.readyStateChange("plus");
		}
		
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//							 SWFaddress linking
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++			
		
		/**
		 * readyStateChange is called from userInterface
		 * 
		 * here we are changing the target panel at the centralNavigation scene
		 * useing a simple counter to ascend and descend the AppData.navLocations 
		 * array
		 * 
		 * once the targetIndex is defined, define the AppData.newLocation string 
		 * which, will, in turn be used throughout the application for correct 
		 * content display
		 * 
		 * @param	dir
		 */
		public static function readyStateChange(dir:String):void
		{	
			AppData.oldLocation = AppData.newLocation;
			
			switch (dir) 
			{
				case "plus":
				{
					_targetIndex ++;
					if (_targetIndex >=	AppData.navLocations.length) 
					{
						_targetIndex = 0;
					}
					break;
				}
				case "minus":
				{
					_targetIndex --;
					if (_targetIndex < 0 ) 
					{
						_targetIndex = AppData.navLocations.length -1;
					}
					break;
				}
			}

			AppData.newLocation = AppData.navLocations[_targetIndex];
			AppControl.activateStateChange();
			
			//Main.appDisplay.msgTxt.set_text = "AppData.newLocation: " + AppData.newLocation;
			trace("AppControl.readyStateChange( " + AppData.newLocation + " ) and the targetIndex is " +_targetIndex);
		}

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//							 navigation transition
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++	

		/**
		 * once AppData.newLocation has 
		 * been set activateStateChange is called. which instigates transition 
		 * cycles in dependents. if pageContent is currently displayed, remove 
		 * it first, and then activate the transition
		 * 
		 * all transitions have two parts, activated by listeners and 
		 * dispatched events events are dispatched (usually) when transition 
		 * animation has concluded
		 * 
		 * this two part cycle allows for conditional actions before or after 
		 * transition animations (such as activating and deactivating event 
		 * listeners)
		 */
		
		private static function activateStateChange():void
		{
			Main.appDisplay.userInferace.removePanelInfo();
			Main.appDisplay.userInferace.deactivateNavEvents();
				
			Main.appDisplay.navigation.addEventListener(AppEvents.CHANGE_COMPLETE, AppControl.stateChangeComplete, false, 0, true);
			Main.appDisplay.navigation.activatePanelTransition(_targetIndex); 
		}
		
		/**
		 * listened event fires at end of nav transition. when it does, activate UI clickables,
		 * and if the library for the current location has loaded, add the panel info
		 * 
		 * @param	e
		 */
		
		private static function stateChangeComplete(e:AppEvents):void
		{
			Main.appDisplay.navigation.removeEventListener(AppEvents.CHANGE_COMPLETE, AppControl.stateChangeComplete);
			Main.appDisplay.userInferace.activateNavEvents();
			
			if (AppData.libraryLoaded[_targetIndex]) 
			{
				if (!Main.appDisplay.userInferace.infoExists) 
				{
					Main.appDisplay.userInferace.addPanelInfo();
				}
			}
		}
		
		/**
		 * when external library has loaded, check it against the targetIndex content
		 * if the current target is the loaded index, add panel info.
		 * 
		 * @param	index
		 */
		
		public static function onLibraryLoad(index):void
		{
			if (index == _targetIndex) 
			{
				if (!Main.appDisplay.userInferace.infoExists) 
				{
					Main.appDisplay.userInferace.addPanelInfo();
				}
			}
		}
		
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//							 page content transition
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++					
		
		/**
		 * addPageContent triggered by panel info clicker
		 * 
		 * set pageIsUp = true to test against when making future transistions
		 * if pageIsUp is true, activate removePageContent before making panel transition
		 */
		public static function addPageContent():void
		{
			Main.appDisplay.userInferace.removePanelInfo();
			Main.appDisplay.userInferace.deactivateNavButtons();
			
			Main.appDisplay.pageContent.addEventListener(AppEvents.PAGE_ADDED, AppControl.addPageComplete, false, 0, true);
			Main.appDisplay.pageContent.addPageContent();
			
			Main.appDisplay.navigation.activatePageContent();
		}
		
		private static function addPageComplete(e:AppEvents):void
		{
			Main.appDisplay.pageContent.removeEventListener(AppEvents.PAGE_ADDED, AppControl.addPageComplete);
		}

		/**
		 * removePageContent triggered by page content back button
		 * 
		 * run remove content sequence in currently displayed content
		 * run remove content sequence in centralNavigation
		 */
		public static function removePageContent(e:MouseEvent = null):void
		{	
			Main.appDisplay.pageContent.addEventListener(AppEvents.PAGE_REMOVED, AppControl.removePageComplete, false, 0, true);
			
			Main.appDisplay.pageContent.removePageContent();
			Main.appDisplay.navigation.deactivatePageContent();
		}
		
		/**
		 * when remove content sequences are complete, add panel info and reactivate nav buttons
		 * set page up to false
		 * 
		 * @param	e
		 */
		private static function removePageComplete(e:AppEvents):void
		{
			Main.appDisplay.pageContent.removeEventListener(AppEvents.PAGE_REMOVED, AppControl.removePageComplete);
			
			Main.appDisplay.userInferace.addPanelInfo();
			Main.appDisplay.userInferace.activateNavButtons();
		}
		
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//							 product information transition
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++		

		public static function addProductContent(productName:String, productCategory:String):void
		{
			Main.appDisplay.productContent.addEventListener(AppEvents.PAGE_ADDED, productContentAdded, false, 0, true);
			Main.appDisplay.productContent.activate( productName, productCategory );
		}

		public static function productContentAdded(e:AppEvents):void
		{
			Main.appDisplay.productContent.removeEventListener(AppEvents.PAGE_ADDED, productContentAdded);
		}

		public static function removeProductContent():void
		{
			Main.appDisplay.productContent.addEventListener(AppEvents.PAGE_REMOVED, productContentRemoved, false, 0, true);
			Main.appDisplay.productContent.deactivate();
		}
		
		public static function productContentRemoved(e:AppEvents):void
		{
			Main.appDisplay.productContent.removeEventListener(AppEvents.PAGE_REMOVED, productContentRemoved);
		}

	}
}