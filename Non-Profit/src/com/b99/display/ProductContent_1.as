///////////////////////////////////////////////////////////////////////////////
//
//	com>b99>display>ProductContent.as
//
//	extends : sprite
//
///////////////////////////////////////////////////////////////////////////////

package com.b99.display
{
	import com.b99.app.AppData;
	import com.b99.composite.BasicButton;
	import com.b99.element.ComplexRoundRect;
	import com.b99.element.ComplexTextField;
	import com.greensock.easing.*;
	import com.greensock.plugins.*;
	import com.greensock.TweenLite;
	import fl.motion.Color;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.filters.GlowFilter;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.xml.*;

	
	
	/**
	 * ...
	 * @author bosworth99
	 */
	
	public class ProductContent extends Sprite
	{
		
	//+++++++++++++++++++++++++		xml object
		private var _xml_product	:XML;
	
	//+++++++++++++++++++++++++ 	graphics
		private var _canvas			:Sprite;
		
		private var _img_product	:Bitmap;
		private var _img_backMask	:ComplexRoundRect;
		private var _img_container	:ComplexRoundRect;
		private var _img_gradient	:ComplexRoundRect;
		private var _linkLine		:ComplexRoundRect;
		private var _loadStar		:MovieClip 	= new GFX_loaderRing();
		
		private var _gfx_blackbar	:ComplexRoundRect;
		private var _gfx_whitebar 	:ComplexRoundRect;
		
	//+++++++++++++++++++++++++ 	buttons
		private var _btn_back		:BasicButton;
		private var _btn_url1		:BasicButton;
		private var _btn_url2		:BasicButton;
		private var _btn_rSwitch	:Sprite = new Cursor_R();
		private var _btn_lSwitch	:Sprite = new Cursor_L();
	
	//+++++++++++++++++++++++++		textfields
		private var _title_product	:ComplexTextField;
		private var _text_product	:ComplexTextField;
		
		private var _loadPercent	:ComplexTextField;
	
	//+++++++++++++++++++++++++   	String
		private var _productName	:String;
		private var _productCategory:String;
		
	//+++++++++++++++++++++++++		numerics
		private var _productID		:int;
		private var _categoryLength	:int;
		private var _startAlpha		:Number = 0;

	//+++++++++++++++++++++++++		loaders
	
	
	//+++++++++++++++++++++++++		booleans
		private var _imgHasLoaded	:Boolean;
	
//-----------------------------------------------------------------------------
//	initiatialize 
//-----------------------------------------------------------------------------
		/**
		 * @private constructor
		 * 
		 * @param	main:Main		 - reference to main class, get xml from it
		 */
		public function Product_Panel() 
		{
			super();
			init();
		}
		private function init():void
		{
			
			//assign xml data
			_xml_product 		= AppData.productXML
			
			//misc initialization
			TweenPlugin.activate([GlowFilterPlugin, BlurFilterPlugin, DropShadowFilterPlugin]);
			
			//activate scene construction
			assembleDisplayObjects();
		}

//-----------------------------------------------------------------------------
//	construct scene
//-----------------------------------------------------------------------------

		private function assembleDisplayObjects():void
		{
			_canvas = new Sprite();
			this.addChild(_canvas);
			
			_img_backMask = new ComplexRoundRect(AppData.stageW, AppData.stageH, 0, "linear", [0x000000], [.7], [1], 270, 1, 0x000000, 0);
			_img_backMask.alpha = _startAlpha;
			_canvas.addChild(_img_backMask);
			
			_gfx_blackbar = new ComplexRoundRect(300, AppData.stageH, 0, "linear", [0x000000, 0x4B4B4B, 0x000000], [.7, .5, .7], [1, 127, 255], 270, 2, 0x000000, 0);
			with (_gfx_blackbar) 
			{
				x = 250;
				y = 0;
				alpha = _startAlpha
			}
			_gfx_blackbar.filters = [new BlurFilter(30,0,2)];
			_canvas.addChild(_gfx_blackbar);
			
			_gfx_whitebar = new ComplexRoundRect(150, AppData.stageH, 0, "linear", [0xE6E6E6, 0xFFFFFF, 0xEBEBEB], [.2, .1, .2], [1, 127, 255], 270, 2, 0xFFFFFF, 0);
			with (_gfx_whitebar) 
			{
				x = 275;
				y = 0;
				alpha = _startAlpha
			}
			_gfx_whitebar.filters = [new BlurFilter(50,0,2)];
			_canvas.addChild(_gfx_whitebar);

			with (_img_halfTone) 
			{
				x 			= -50;
				y 			= 650;
				scaleX 		= 1.5
				scaleY 		= -1.5;
				rotation 	= 2;
				transform.colorTransform = _color_halfTone;
				alpha 		= _startAlpha;
			}
			_canvas.addChild(_img_halfTone);
			
			_img_gradient = new ComplexRoundRect(AppData.stageW, 100, 0, "linear", [0xFFFFFF, 0xFFFFFF], [.5, 0], [1, 255], 270, 0, 0xFFFFFF, 0);
			with (_img_gradient)
			{
				x 			= 0;
				y 			= AppData.stageH - 75;
				alpha 		= _startAlpha;
			}
			_canvas.addChild(_img_gradient);

			_img_container = new ComplexRoundRect(AppData.stageW - 200, AppData.stageH - 200, 25, "linear", [0xFFFFFF, 0xF0F0F0, 0xFFFFFF], [1, 1, 1], [1, 127, 255], 90, 2, 0xFFFFFF, 1);
			with (_img_container) 
			{
				x 			= -600;
				y 			= 60;
				alpha 		= _startAlpha;
			}
			_canvas.addChild(_img_container);

			_title_product = new ComplexTextField("", "verdana_title", 0xFFFFFF, 20,0,0,"none");
			with (_title_product) 
			{
				x 			= 0;
				y 			= 25;
				alpha 		= _startAlpha;
			}
			_title_product.filters = [new GlowFilter(0xFFFFFF, .3)];
			_canvas.addChild(_title_product);
			
			_text_product = new ComplexTextField("", "verdana_text", 0xFFFFFF, 12, 200, 525, "none");
			with (_text_product) 
			{
				x 			= 50;
				y 			= 415;
				alpha 		= _startAlpha;
			}
			_canvas.addChild(_text_product);
			
			_linkLine 		= new ComplexRoundRect(450, 2, 0, "linear", [0xFFFFFF, 0xFFFFFF], [0, 1], [1, 255], 0, 0, 0xFFFFFF, 0);
			with (_linkLine)
			{
				x			= (AppData.stageW - 100) - _linkLine.width;
				//y			= _text_product.y + _text_product.height;
				y 			= 495
				
				alpha		= _startAlpha;
			}
			_canvas.addChild(_linkLine);
			
			_btn_back = new BasicButton("small","light", "close");
			with (_btn_back) 
			{
				x 			= 700;
				y 			= 30;
				alpha 		= _startAlpha;
			}
			_canvas.addChild(_btn_back);
			
			//_btn_rSwitch = new BasicButton("med", "dark" , ">");
			with (_btn_rSwitch) 
			{
				x 			= AppData.stageW;
				y 			= 225;
				alpha 		= _startAlpha;
				scaleY		= 1.2;
				useHandCursor = true;
				buttonMode	= true;
			}
			_canvas.addChild(_btn_rSwitch);
			
			//_btn_lSwitch = new BasicButton("med", "dark" , "<");
			with (_btn_lSwitch) 
			{
				x 			= 0;
				y 			= 225;
				alpha 		= _startAlpha;
				scaleY		= 1.2;
				useHandCursor = true;
				buttonMode	= true;
			}
			_canvas.addChild(_btn_lSwitch);
		}

		private function buildLinkButtons():void
		{
			var link1:String = _xml_product.category.(@catName == _productCategory).product[_productID].urlTitle1 + " >";
			var link2:String = _xml_product.category.(@catName == _productCategory).product[_productID].urlTitle2 + " >";
			
			if ( link1.length > 2 ) 
			{
				_btn_url1 = new BasicButton("small", "trans", link1, "verdana_title", "bold");
				with (_btn_url1) 
				{
					x 			= (AppData.stageW - 100) - _btn_url1.width;
					y 			= 500;
					alpha 		= 0;
				}
				_canvas.addChild(_btn_url1);	
			}		
			if ( link2.length > 2) 
			{
				_btn_url2 = new BasicButton("small", "trans", link2, "verdana_title", "bold");
				with (_btn_url2) 
				{
					x 			= _btn_url1.x - (_btn_url2.width + 20);
					y 			= 500;
					alpha 		= 0;
				}
				_canvas.addChild(_btn_url2);
			}
		}
		
		private function killLinkButtons():void
		{
			if (_btn_url1) 
			{
				_btn_url1.destroy();
				_canvas.removeChild(_btn_url1);
				_btn_url1 = null;
			}
			if (_btn_url2) 
			{
				_btn_url2.destroy();
				_canvas.removeChild(_btn_url2);
				_btn_url2 = null;
			}
		}
		
//-----------------------------------------------------------------------------
//	activate panel
//-----------------------------------------------------------------------------
		/**
		 * 
		 * @param	productName: String - derived from name attribute of clicked item - aligns with xml
		 * @param	productCategory: String - derived from target scene assigned when nav button is clicked
		 */
		public function activate_product_panel(productName:String, productCategory:String):void 
		{		
			_productName 				= productName;
			_productCategory 			= productCategory;
			_productID 					= _xml_product.category.(@catName == _productCategory).product.(@name == _productName).productID;
			
			//adjust categoryLength to accomodate img switching
			_categoryLength 			= _xml_product.category.(@catName == _productCategory).product.length();

			//initiate load of image - derived from the distinct productID.imgPath of the xml object 
			loadImg(_xml_product.category.(@catName == _productCategory).product[_productID].imgPath)	
			
			//set location title
			_title_product.set_text 	= _xml_product.category.(@catName == _productCategory).product[_productID].textHeader;
			_text_product.set_text 		= _xml_product.category.(@catName == _productCategory).product[_productID].textHeaderText;
			
			buildLinkButtons()
			
			//initiate animation
			animate_in();
		}
		
		
//-----------------------------------------------------------------------------
//	img load sequence
//-----------------------------------------------------------------------------

		/**
		 * @private load sequence is called when the panel is first added to stage (on click of a product button)
		 * 			load sequence is called again when the user clicks left or right buttons on the product panel itself 
		 * 
		 * @param	targetImg:String; image path derived from xml
		 */
		private function loadImg(targetImgPath:String):void
		{
			//if the back button was clicked during a load, the _img_product might be hanging around. if it is, kill it.
			if (_img_product) {
				_img_container.removeChild(_img_product);
				_img_product = null;
			}
			
			//initiate load
			_imgLoader = new LoadDisplayObject(targetImgPath, false);
			_imgLoader.addEventListener("displayObjectLoaded", imgLoadComplete, false, 0, true);
		
			//add loader graphic
			with (_loadStar) 
			{
				x 					= (_img_container.width / 2) - (_loadStar.width / 2); 
				y 					= (_img_container.height/ 2) - (_loadStar.height / 2); 
				alpha 				= 0;
				scaleX 				= .1;
				scaleY 				= .1;
			}
			_img_container.addChild(_loadStar);
			TweenLite.to(_loadStar, .4, {alpha:1, scaleX:1, scaleY:1, delay:.2});
		}
		private function imgLoadComplete(e:Event):void 
		{
			_imgLoader.removeEventListener("displayObjectLoaded", imgLoadComplete);
		
			//remove loader graphic as soon as load is complete	
			TweenLite.to(_loadStar, .2, {alpha:0, scaleX:.1, scaleY:.1,  onComplete: add_product_image});
		}
		
		private function add_product_image():void
		{
			_img_container.removeChild(_loadStar);
			
			//assign value to _img_product graphic, add to display list
			_img_product = new Bitmap();
			_img_product = Bitmap(_imgLoader.loaderContent);
			with (_img_product) 
			{
				x 					= (_img_container.width - _img_product.width) / 2;
				y 					= (_img_container.height - _img_product.height) / 2;
				alpha 				= 0;
			}
			_img_container.addChild(_img_product);
			TweenLite.to(_img_product, 	.3, { alpha:1, dropShadowFilter: { color:0x000000, alpha:.4, blurX:10, blurY:10, angle:90, distance:2}, onComplete:loadSequenceComplete } );
		}
		
		private function loadSequenceComplete():void
		{
			_imgHasLoaded = true;
		}
		
//-----------------------------------------------------------------------------
//	animate in
//-----------------------------------------------------------------------------
		
		private function animate_in():void 
		{
			TweenLite.to(_img_backMask, 	.5,	{ 							alpha:.8, 	delay:0 } );
			TweenLite.to(_img_gradient, 	.5, {							alpha:1,  	delay:.2 } );
			TweenLite.to(_img_halfTone, 	.7, { x: -50, y:600,			alpha:.3, 	delay:.3 } );
			TweenLite.to(_img_container, 	.4, { x:100, 					alpha:1, 	delay:.4 } );
			TweenLite.to(_title_product, 	.4, { x:120, 				 	alpha:1, 	delay:.5 } );
			TweenLite.to(_text_product, 	.4, { x:120, 				 	alpha:1, 	delay:.6 } );
			TweenLite.to(_btn_rSwitch, 		.4, { x:AppData.stageW - 60, 	alpha:1, 	delay:.7 } );
			TweenLite.to(_btn_lSwitch, 		.4, { x:60, 				 	alpha:1, 	delay:.9 } );
			TweenLite.to(_linkLine, 		.4, { 				 			alpha:1, 	delay:.9 } );
			TweenLite.to(_gfx_blackbar, 	.5,	{ x:350,					alpha:.9, 	delay:1  } );
			TweenLite.to(_gfx_whitebar, 	.5,	{ x:375,					alpha:.9, 	delay:1  } );
			
			
			if (_btn_url1) 
			{
				TweenLite.to(_btn_url1, 	.3, { alpha:1, 	delay:.9} );
			}
			if (_btn_url2) 
			{
				TweenLite.to(_btn_url2, 	.3, { alpha:1, 	delay:.9} );
			}
			
			TweenLite.to(_btn_back, 		.4, { x:610, 	alpha:1, 	delay:1, onComplete: animate_in_stage2 } );
		}
		
		private function animate_in_stage2():void
		{
			TweenLite.to(_img_container, 	.5, { glowFilter: { color:0xFFFFFF, alpha:1, blurX:30, blurY:30 }} );
			TweenLite.to(_img_halfTone, 	.5, { glowFilter: { color:0xFFFFFF, alpha:1, blurX:20, blurY:20 }, onComplete:add_listeners } );
		}

//-----------------------------------------------------------------------------
//	addlisteners
//-----------------------------------------------------------------------------

		private function add_listeners():void
		{
			_canvas.addEventListener(Event.ENTER_FRAME, shiftGFX, false, 0, true);
			
			_btn_back.addEventListener(MouseEvent.MOUSE_DOWN, 		btn_back_click, 	false, 0, 	true);
			
			_btn_rSwitch.addEventListener(MouseEvent.MOUSE_DOWN, 	btn_rSwitch_click, 	false, 0, 	true);
			_btn_lSwitch.addEventListener(MouseEvent.MOUSE_DOWN, 	btn_lSwitch_click, 	false, 0, 	true);
			_btn_rSwitch.addEventListener(MouseEvent.MOUSE_OVER, 	btn_switch_over, 	false, 0, 	true);
			_btn_lSwitch.addEventListener(MouseEvent.MOUSE_OVER, 	btn_switch_over, 	false, 0, 	true);
			_btn_rSwitch.addEventListener(MouseEvent.MOUSE_OUT, 	btn_switch_out, 	false, 0, 	true);
			_btn_lSwitch.addEventListener(MouseEvent.MOUSE_OUT, 	btn_switch_out, 	false, 0, 	true);
			
			if (_btn_url1) 
			{
				_btn_url1.addEventListener(MouseEvent.MOUSE_DOWN, 		btn_url1_click, 	false, 0, 	true);
			}
			if (_btn_url2) 
			{
				_btn_url2.addEventListener(MouseEvent.MOUSE_DOWN, 		btn_url2_click, 	false, 0, 	true);
			}
		}
		
		private function btn_switch_out(e:MouseEvent):void 
		{
			TweenLite.to(e.target, .2, {glowFilter: { color:0xFFFFFF, alpha:.5, blurX:0, blurY:0, remove:true }} );
		}
		
		private function btn_switch_over(e:MouseEvent):void 
		{
			TweenLite.to(e.target, .5, {glowFilter: { color:0xFFFFFF, alpha:.9, blurX:10, blurY:10}} );
		}
		
//-----------------------------------------------------------------------------
//	interaction
//-----------------------------------------------------------------------------
		
		private function btn_lSwitch_click(e:MouseEvent):void 
		{	
		//if the _img_product has finished loading, allow the switch
			if (_imgHasLoaded) {
				switch_img("left");	
				_imgHasLoaded = false;
			}
		}
		private function btn_rSwitch_click(e:MouseEvent):void 
		{	
		//if the _img_product has finished loading, allow the switch
			if (_imgHasLoaded) {
				switch_img("right");
				_imgHasLoaded = false;
			}
		}
		private function btn_url1_click(e:MouseEvent):void 
		{
			var targetURL:String = _xml_product.category.(@catName == _productCategory).product[_productID].urlPath1;
			var targetRequest:URLRequest = new URLRequest(targetURL);
			navigateToURL(targetRequest,"_new");
		}
		private function btn_url2_click(e:MouseEvent):void 
		{
			var targetURL:String = _xml_product.category.(@catName == _productCategory).product[_productID].urlPath2;
			var targetRequest:URLRequest = new URLRequest(targetURL);
			navigateToURL(targetRequest,"_new");
		}

		private function btn_back_click(e:MouseEvent):void 
		{
			_canvas.removeEventListener(Event.ENTER_FRAME, shiftGFX);
			
			killLinkButtons();
			remove_listeners();
		}

//-----------------------------------------------------------------------------
//	programmatic animation
//-----------------------------------------------------------------------------			
		private function shiftGFX(e:Event):void 
		{
			_gfx_whitebar.x		-= (_gfx_whitebar.x - (mouseX - (_gfx_whitebar.width / 2)))  / 150;
			_gfx_blackbar.x 	-= (_gfx_blackbar.x - (_gfx_whitebar.x - (_gfx_blackbar.width / 2))) / 125;
			
			if (_gfx_whitebar.x <= _img_container.x) 
			{
				_gfx_whitebar.x = _img_container.x;
			} 
			else if ((_gfx_whitebar.x + _gfx_whitebar.width) >= (_img_container.x + _img_container.width)) 
			{
				_gfx_whitebar.x = (_img_container.x + _img_container.width) - _gfx_whitebar.width;
			}
		}
		
//-----------------------------------------------------------------------------
//	switch sequence
//-----------------------------------------------------------------------------		
		
		private function switch_img(dir:String):void
		{
			if (dir == "right") 
			{
				_productID++;
				if (_productID >= _categoryLength)
				{
					_productID = 0;
				}
			} 
			else if (dir == "left")
			{
				_productID--;
				if (_productID < 0)
				{
					_productID = _categoryLength-1;
				}
			}
			switch_animate_out();
		}
		
		private function switch_animate_out():void
		{
			TweenLite.to(_text_product, 	.4, { alpha:0, 	blurFilter: { blurX:5, blurY:5,   remove:true }, delay:.1 });
			TweenLite.to(_title_product, 	.4, { alpha:0, 	blurFilter: { blurX:5, blurY:5,   remove:true }, delay:.3 });
			TweenLite.to(_img_product, 		.5, { alpha:0, 	blurFilter: { blurX:25, blurY:25, remove:true }, delay:.7, onComplete:load_new_img });	
			
			if (_btn_url1) 
			{
				TweenLite.to(_btn_url1, 	.4, { alpha:0, 	blurFilter: { blurX:5, blurY:5,   remove:true},	delay:.3, onComplete:killLinkButtons });
			}
			if (_btn_url2) 
			{
				TweenLite.to(_btn_url2, 	.4, { alpha:0, 	blurFilter: { blurX:5, blurY:5,   remove:true},	delay:.3, onComplete:killLinkButtons });
			}
			
		}
		
		private function load_new_img():void
		{
			_img_container.removeChild(_img_product);
			_img_product = null;
			
			loadImg(_xml_product.category.(@catName == _productCategory).product[_productID].imgPath);
			
			_title_product.set_text 	= _xml_product.category.(@catName == _productCategory).product[_productID].textHeader;
			_text_product.set_text 		= _xml_product.category.(@catName == _productCategory).product[_productID].textHeaderText;
			
			buildLinkButtons();
			switch_animate_in();
		}
		
		private function switch_animate_in():void
		{
			TweenLite.to(_title_product, 	.3, { alpha:1} );
			TweenLite.to(_text_product, 	.3, { alpha:1} );
			
			if (_btn_url1) 
			{
				TweenLite.to(_btn_url1, 	.5, { alpha:1, 	delay:.1 } );
				_btn_url1.addEventListener(MouseEvent.MOUSE_DOWN, 		btn_url1_click, 	false, 0, 	true);
			}
			if (_btn_url2) 
			{
				TweenLite.to(_btn_url2, 	.5, { alpha:1, 	delay:.1 } );
				_btn_url2.addEventListener(MouseEvent.MOUSE_DOWN, 		btn_url2_click, 	false, 0, 	true);
			}
		}	
//-----------------------------------------------------------------------------
//	EXIT scene sequence
//-----------------------------------------------------------------------------
		private function remove_listeners():void
		{
			_btn_back.removeEventListener		(MouseEvent.MOUSE_DOWN, 	btn_back_click);
			
			if (_btn_url1) 
			{
				_btn_url1.removeEventListener	(MouseEvent.MOUSE_DOWN, 	btn_url1_click);
			}
			if (_btn_url2) 
			{
				_btn_url2.removeEventListener	(MouseEvent.MOUSE_DOWN, 	btn_url2_click);
			}

			_btn_rSwitch.removeEventListener	(MouseEvent.MOUSE_DOWN, 	btn_rSwitch_click);
			_btn_lSwitch.removeEventListener	(MouseEvent.MOUSE_DOWN, 	btn_lSwitch_click);
			_btn_rSwitch.removeEventListener	(MouseEvent.MOUSE_OVER, 	btn_switch_over);
			_btn_lSwitch.removeEventListener	(MouseEvent.MOUSE_OVER, 	btn_switch_over);
			_btn_rSwitch.removeEventListener	(MouseEvent.MOUSE_OUT, 		btn_switch_out);
			_btn_lSwitch.removeEventListener	(MouseEvent.MOUSE_OUT, 		btn_switch_out);
			
			animate_out();
		}
//-----------------------------------------------------------------------------
//	animate out
//-----------------------------------------------------------------------------
		private function animate_out():void
		{
			if (_img_product) {
				TweenLite.to(_img_product, 		.5, { alpha:0, delay:.2, blurFilter: {blurX:20, blurY:20, remove:true }, onComplete:animate_out_stage2 } );
			} 
			else 
			{
				animate_out_stage2();
			}
		}
		
		private function animate_out_stage2():void
		{
			if (_img_product) {
				_img_container.removeChild(_img_product);
				_img_product = null;
			}
			
			if (_btn_url1) 
			{
				TweenLite.to(_btn_url1, 	.3, { alpha:_startAlpha, 	delay:.2, onComplete:killLinkButtons } );
			}
			if (_btn_url2) 
			{
				TweenLite.to(_btn_url2, 	.3, { alpha:_startAlpha, 	delay:.2, onComplete:killLinkButtons } );
			}
			
			TweenLite.to(_btn_back, 		.3, { x:800, 				alpha:_startAlpha, 	delay:.1} );
			TweenLite.to(_btn_lSwitch, 		.3, { x:0, 					alpha:_startAlpha, 	delay:.1} );
			TweenLite.to(_btn_rSwitch, 		.3, { x:AppData.stageW, 	alpha:_startAlpha, 	delay:.1} );
			TweenLite.to(_text_product, 	.3, {  						alpha:_startAlpha, 	delay:.3} );
			TweenLite.to(_linkLine, 		.3, {  						alpha:_startAlpha, 	delay:.3} );
			TweenLite.to(_title_product, 	.3, {  						alpha:_startAlpha, 	delay:.3} );
			TweenLite.to(_img_container, 	.3, { 						alpha:_startAlpha, 	delay:.4} );
			
			TweenLite.to(_img_container, 	.5, { 						alpha:_startAlpha,  delay:.7, blurFilter: {blurX:20, blurY:20, remove:true }} );
			
			TweenLite.to(_img_halfTone, 	.4, { x: -50, 		y:650,	alpha:_startAlpha, 	delay:.7 } );
			TweenLite.to(_gfx_blackbar, 	.4,	{ 						alpha:_startAlpha, 	delay:.7 } );
			TweenLite.to(_gfx_whitebar, 	.4,	{ 						alpha:_startAlpha, 	delay:.7 } );
			TweenLite.to(_img_gradient, 	.4, {						alpha:_startAlpha,  delay:.8 } );
			TweenLite.to(_img_backMask, 	.4,	{ 						alpha:_startAlpha, 	delay:.9, onComplete: reset_panel } );
		}		

//-----------------------------------------------------------------------------
//	reset final values
//-----------------------------------------------------------------------------

		private function reset_panel():void
		{	
			_img_container.x			= -600,	
			
			_title_product.x 			= 50;
			_text_product.set_text 		= "";
			
			
			_text_product.x 			= 0;
			_title_product.set_text 	= "";
			
			_productCategory 			= "";
			_productID					= -1;
			_productName				= "";
			
			dispatch_exit_event();
		}

		public function dispatch_exit_event():void 
		{
			this.dispatchEvent(new Event("product panel exit event"));
		}
	}
}