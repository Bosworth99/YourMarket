package com.b99.display.content 
{
	import com.b99.app.*;
	import com.b99.composite.*;
	import com.b99.element.*;
	import com.b99.events.*;
	import com.b99.interfaces.*;
	import com.greensock.*;
	import com.greensock.plugins.*;
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	/**
	 * ...
	 * @author bosworth99
	 */
	public class Content_Base extends Sprite implements IContent
	{
		protected var _canvas		:Sprite
		protected var _screen		:MovieClip;
		protected var _library		:Array;
		protected var _libNames		:Array;
		protected var _name			:String;
		protected var _flyoutCon	:Sprite;
		protected var _productInfo	:ProductInfoFlyout;
		protected var _textureDS	:DropShadowFilter;
		protected var _objDS		:DropShadowFilter;
		
		private var _camDirection	:String;

		/* INTERFACE com.b99.interfaces.IContent */
		public function Content_Base() 
		{
			super();
			init();
		}
		private function init():void
		{
			TweenPlugin.activate([BlurFilterPlugin, DropShadowFilterPlugin]);
			_textureDS 	= new DropShadowFilter(10, 270, 0x000000, .3, 15, 15, 1, 2);
			_objDS		= new DropShadowFilter(3, 45, 0x000000, .3, 6, 6);
		}
		
		/**
		 * inherited in each content page
		 * Called from PageContent control class. 
		 * index is defined via DataContol.libraries.indexOf(location name);
		 * this index is targeted in the overridden assembleDisplayObject method in the subclass
		 * 
		 * @param	index : target index by which to address
		 * content and name library
		 */
		public function assignLibrary(index:uint):void
		{
			_library 	= AppData.libraryCon[index];
			_libNames 	= AppData.libraryNames[index];
			_name		= AppData.libraries[index];
			assembleDisplayObjects();
		}
		
		/**
		 * override in subclass 
		 */
		public function instantiateLibraryItem(index:uint ):void{}

		/**
		 * override in subclass
		 */
		public function assembleDisplayObjects():void
		{
			//instantiate all graphics from library. PageContent class adds to display list, 
			//if AppData.libraryloaded[index] = true
			//if page content assignment is attempted while ^ false = add loader ring.
		}
		
		/**
		 * override in subclass 
		 * standard animation transition, called at page content
		 */
		public function animateContentIn():void{}
		
		
		public function animateInComplete():void
		{
			addEventHandlers();
			this.dispatchEvent(new AppEvents(AppEvents.CHANGE_COMPLETE));
		}
		
		/**
		 * override in subclass 
		 */
		public function addEventHandlers():void{}
		
		/**
		 * override in subclass 
		 */
		public function animateContentOut():void{}
		
		
		public function animateOutComplete():void
		{
			this.dispatchEvent(new AppEvents(AppEvents.CHANGE_COMPLETE));
		}

		protected function productOver(e:MouseEvent):void 
		{
			if (_productInfo) 
			{
				_productInfo.destroy();
				_productInfo = null;
			}
			
			_productInfo = new ProductInfoFlyout(	AppData.nonProfitXML.content.scene.(@name == _name).text.pageContent.products.item.(@name == e.target.name).title, 
													AppData.nonProfitXML.content.scene.(@name == _name).text.pageContent.products.item.(@name == e.target.name).text
													);
													
			_flyoutCon.mouseChildren = false;
			_flyoutCon.mouseEnabled = false;
			
			_flyoutCon.addChild(_productInfo);									
		}
		
		protected function productOut(e:MouseEvent):void 
		{
			if (_productInfo) 
			{
				_productInfo.destroy();
				_productInfo = null;
			}
		}
		
		protected function productDown(e:MouseEvent):void 
		{
			trace("product clicked: " +  e.target.name );
			AppControl.addProductContent(e.target.name, _name );
		}
		
		protected function backDown(e:MouseEvent):void 
		{
			AppControl.removePageContent();
		}
		
		/**
		 * override in subclass 
		 */
		public function removeEventHandlers():void{}
		
		/**
		 * override in subclass 
		 */
		public function reset():void{}

		public function get camDirection():String { return _camDirection; }

	}
}