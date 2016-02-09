///////////////////////////////////////////////////////////////////////////////
//
//	com>b99>app>AppDisplay.as
//
//	extends : Sprite
//	role`	: Observer
//
//	provides overcontrol of display list
//	controls adding / removing items from the display list
//
//	main points of communication:
//	AppControl
//	
//
///////////////////////////////////////////////////////////////////////////////

package com.b99.app 
{
	import com.b99.display.CentralNavigation;
	import com.b99.display.Overlay;
	import com.b99.display.PageContent;
	import com.b99.display.ProductContent;
	import com.b99.display.UserInterface;
	import com.b99.element.ComplexTextField;
	import com.b99.events.AppEvents;
	import com.greensock.*;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author bosworth99
	 */
	public class AppDisplay extends Sprite
	{
		private var _navigation		:CentralNavigation;
		private var _productContent	:ProductContent;
		private var _pageContent	:PageContent;
		private var _userInferace	:UserInterface;
		private var _overlay		:Overlay;
		private var _introMask		:Sprite;
		private var _canvas			:Sprite;	
		private var _msgTxt			:ComplexTextField;
		
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//									constructor
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		public function AppDisplay() 
		{
			super();
			init()
		}
		
		private function init():void
		{
			_msgTxt 				= new ComplexTextField("", "verdana_text", 0xFF0000, 12, 600, 400);
			_msgTxt.mouseChildren	= false;
			_msgTxt.mouseEnabled	= false;
			_msgTxt.buttonMode		= false;
			_msgTxt.x 				= 50;
			_msgTxt.y 				= 50;
			this.addChild(_msgTxt);
			
			trace("AppDisplay.init()")
		}
		
		public function assembleDisplayLayers():void
		{
			//parent container
			_canvas 				= new Sprite();
			this.addChild(_canvas);
			
			//3d layer
			_navigation 			= new CentralNavigation();
			_canvas.addChild(_navigation);
			
			//page content
			_pageContent 			= new PageContent();
			_canvas.addChild(_pageContent);
			
			//product content
			_productContent 		= new ProductContent();
			_canvas.addChild(_productContent);
			
			//Overlay
			_overlay 				= new Overlay();
			_canvas.addChild(_overlay);
			
			//UI
			_userInferace 			= new UserInterface();
			_canvas.addChild(_userInferace);
			
			_introMask = new Sprite();
			with (_introMask) 
			{
				graphics.beginFill(0xFFFFFF, 1);
				graphics.drawRect(0, 0, AppData.stageW, AppData.stageH);
				graphics.endFill();
			}
			_canvas.addChild(_introMask);
			
			this.setChildIndex(_msgTxt, this.numChildren-1);
			
			//assign app level scrollRect
			this.scrollRect = new Rectangle(0, 0, AppData.stageW, AppData.stageH);
			
			//wait for display list to populate, tell AppControl to add interactivity
			this.dispatchEvent(new AppEvents(AppEvents.APP_READY));
		}

		public function removeIntroMask():void
		{
			TweenLite.to(_introMask, 1, { delay:.5, alpha:0, onComplete: function() { _canvas.removeChild(_introMask); _introMask = null; }} );
		}
		
//-----------------------------------------------------------------------------
//								getters
//-----------------------------------------------------------------------------	

		public function get navigation():CentralNavigation { return _navigation; }
		public function get productContent():ProductContent { return _productContent; }
		public function get pageContent():PageContent { return _pageContent; }
		public function get userInferace():UserInterface { return _userInferace; }
		public function get overlay():Overlay { return _overlay; }
		public function get msgTxt():ComplexTextField { return _msgTxt; }

//-----------------------------------------------------------------------------
//		end 
//-----------------------------------------------------------------------------
		
	}
}