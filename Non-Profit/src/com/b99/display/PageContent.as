///////////////////////////////////////////////////////////////////////////////
//
//	com>b99>display>PageContent.as
//
//	extends : sprite
//
//	container layer for page contents
//
///////////////////////////////////////////////////////////////////////////////

package com.b99.display 
{
	import com.b99.app.AppControl;
	import com.b99.app.AppData;
	import com.b99.display.content.*;
	import com.b99.events.AppEvents;
	import com.b99.interfaces.IContent;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author bosworth99
	 */
	public class PageContent extends Sprite
	{
		private var _tempContent	:IContent;
		private var _tempLoader		:IContent;
		
		private var _operations		:Operations;
		private var _volunteer		:Volunteer;
		private var _aboutCI		:AboutCI;
		private var _charity		:Charity;
		private var _fundraising	:Fundraising;
		private var _outreach		:Outreach;
		private var _preservation	:Preservation;
		private var _service		:Service;
		private var _events			:Events;

		public function PageContent() 
		{
			super();
			init();
		}
		private function init():void
		{
			trace("PageContent.init();");
		}
	
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//							  assemble content
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

		/**
		 * target assembleContent during loader process
		 * ready content for addition to display list and animation
		 * 
		 * define tempIndex from the ASSET_DEF name (name of the location)
		 * use tempIndex in the Content_Base, and thus each extended page content
		 * during assembleDisplayObject sequence
		 * 
		 * @param	location
		 */
		
		public function assembleContent(location:String):void
		{
			trace("PageContent.assembleContent(" + location + ")");
			
			switch (location) 
			{
				case "Operations":
				{
					_operations 	= new Operations();
					_tempLoader 	= _operations;
					break;
				}
				case "Volunteer":
				{
					_volunteer 		= new Volunteer();
					_tempLoader 	= _volunteer;
					break;
				}
				case "Events":
				{
					_events 		= new Events();
					_tempLoader 	= _events;
					break;
				}
				case "Fundraising":
				{
					_fundraising 	= new Fundraising();
					_tempLoader 	= _fundraising;
					break;
				}
				case "Charity":
				{
					_charity 		= new Charity();
					_tempLoader 	= _charity;
					break;
				}
				case "Preservation":
				{
					_preservation 	= new Preservation();
					_tempLoader 	= _preservation;
					break;
				}
				case "Outreach":
				{
					_outreach 		= new Outreach();
					_tempLoader 	= _outreach;
					break;
				}
				case "AboutCI":
				{
					_aboutCI 		= new AboutCI();
					_tempLoader 	= _aboutCI;
					break;
				}
				case "Service":
				{
					_service 		= new Service();
					_tempLoader 	= _service;
					break;
				}
			}	
			
			var tempIndex:int = AppData.libraries.indexOf(location, 0);
			_tempLoader.assignLibrary(tempIndex);
		}
		
		
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//							  add to display list
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++		

		/**
		 * called during runtime
		 * if library has loaded, target the intended pageContent, 
		 * add to display and activate animation
		 * @param	location
		 */	
		public function addPageContent():void
		{
			trace("PageContent.addPageContent(" + AppData.newLocation + ")");

			switch (AppData.newLocation) 
			{
				case "Operations":
				{
					_tempContent = _operations;
					break;
				}
				case "Volunteer":
				{
					_tempContent = _volunteer;
					break;
				}
				case "Events":
				{
					_tempContent = _events;
					break;
				}
				case "Fundraising":
				{
					_tempContent = _fundraising;
					break;
				}
				case "Charity":
				{
					_tempContent = _charity;
					break;
				}
				case "Preservation":
				{
					_tempContent = _preservation;
					break;
				}
				case "Outreach":
				{
					_tempContent = _outreach;
					break;
				}
				case "AboutCI":
				{
					_tempContent = _aboutCI;
					break;
				}
				case "Service":
				{
					_tempContent = _service;
					break;
				}
			}	

			this.addChild(_tempContent as DisplayObject);
			
			Sprite(_tempContent).addEventListener(AppEvents.CHANGE_COMPLETE, pageContentAdded, false, 0, true);
			_tempContent.animateContentIn();
		}
		
		private function pageContentAdded(e:AppEvents):void 
		{
			Sprite(_tempContent).removeEventListener(AppEvents.CHANGE_COMPLETE, pageContentAdded);
			this.dispatchEvent(new AppEvents(AppEvents.PAGE_ADDED));
		}

		public function removePageContent():void
		{
			Sprite(_tempContent).addEventListener(AppEvents.CHANGE_COMPLETE, pageContentRemoved, false, 0, true);
			_tempContent.animateContentOut();
		}
		
		private function pageContentRemoved(e:AppEvents):void 
		{
			Sprite(_tempContent).removeEventListener(AppEvents.CHANGE_COMPLETE, pageContentRemoved);
			
			this.removeChild(_tempContent as DisplayObject);
			_tempContent.reset();
			
			this.dispatchEvent(new AppEvents(AppEvents.PAGE_REMOVED));
		}
		
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//							  misc
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++	

		public function camDirection():String { return _tempContent.camDirection; }
		
	}
}