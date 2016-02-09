///////////////////////////////////////////////////////////////////////////////
//
//	com>b99>display>ProductContent.as
//
//	extends : sprite
//
//	intent	: 
//	Object for displaying product data - images, text, etc. 
//	Provide external links for products
//	Cycle between products in a given category.
//
///////////////////////////////////////////////////////////////////////////////

package com.b99.display
{
	import com.b99.app.AppControl;
	import com.b99.app.AppData;
	import com.b99.app.Main;
	import com.b99.composite.BackButton;
	import com.b99.composite.BasicButton;
	import com.b99.element.ComplexRoundRect;
	import com.b99.element.ComplexTextField;
	import com.b99.events.AppEvents;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author bosworth99
	 */
	
	public class ProductContent extends Sprite
	{
		private var _canvas	 		:Sprite;
		
		//++++++++++++++++++++++++ image GFX
		private var _GFX_backMask	:ComplexRoundRect;
		private var _GFX_container	:ComplexRoundRect;
		private var _GFX_gradient	:ComplexRoundRect;
		private var _GFX_linkLine	:ComplexRoundRect;
		private var _GFX_imgMask	:ComplexRoundRect;
		private var _GFX_imgFrame	:ComplexRoundRect;
		private var _IMG_product	:Bitmap;
		private var _GFX_loadStar	:MovieClip 	= new GFX_loaderRing();

		//+++++++++++++++++++++++++		textfields
		private var _title_product	:ComplexTextField;
		private var _text_product	:ComplexTextField;
		
		private var _productName	:String;
		private var _productCategory:String;
		
		//+++++++++++++++++++++++++		numerics
		private var _productID		:int;
		private var _categoryLength	:int;
		
		//+++++++++++++++++++++++++		clickables
		private var _btn_back		:BackButton;
		private var _btn_plus		:Sprite;
		private var _btn_minus		:Sprite;
		private var _btn_url1		:BasicButton;
		private var _btn_url2		:BasicButton;
		
		//+++++++++++++++++++++++++		const
		private const CON_WIDTH		:int = 700;
		private const CON_HEIGHT	:int = 450;
		private const DIST			:uint = 20;
		
		//+++++++++++++++++++++++++		booleans
		private var _imgHasLoaded	:Boolean = false;
		
//-----------------------------------------------------------------------------
//								constructor
//-----------------------------------------------------------------------------
		
		public function ProductContent():void
		{
			super();
			init();
		}
		
		private function init():void
		{
			assembleDisplayObjects();
		}
		
		public function activate(productName:String, productCategory:String):void
		{
			_productName 				= productName;
			_productCategory 			= productCategory;

			_productID 					= AppData.productXML.category.(@catName == _productCategory).product.(@name == _productName).productID;

			_categoryLength 			= AppData.productXML.category.(@catName == _productCategory).product.length();

			//initiate load of image - derived from the distinct productID.imgPath of the xml object 
			loadProductImage(AppData.productXML.category.(@catName == _productCategory).product[_productID].imgPath);	
			
			//set location title
			_title_product.set_text 	= AppData.productXML.category.(@catName == _productCategory).product[_productID].header;
			_text_product.set_text 		= AppData.productXML.category.(@catName == _productCategory).product[_productID].text;
			
			this.addChild(_canvas);
			//assign variables
			
			buildLinkButtons()
			animateIn();
			
			addEventHandlers();
			
			this.dispatchEvent(new AppEvents(AppEvents.PAGE_ADDED));
		}
		
		private function assembleDisplayObjects():void
		{
			_canvas			= new Sprite();

			//++++++++++++++++++++++ image stuff
			_GFX_backMask 	= new ComplexRoundRect(AppData.stageW, AppData.stageH, 0, "linear", [0x000000], [.8], [1], 270, 1, 0x000000, 0);
			_GFX_backMask.mouseEnabled 	= false;
			_GFX_backMask.buttonMode	= false;
			_canvas.addChild(_GFX_backMask);

			_GFX_gradient = new ComplexRoundRect(AppData.stageW, 100, 0, "linear", [0xFFFFFF, 0xFFFFFF], [.5, 0], [1, 255], 270, 0, 0xFFFFFF, 0);
			with (_GFX_gradient)
			{
				x 			= 0;
				y 			= AppData.stageH - 75;
			}
			_canvas.addChild(_GFX_gradient);

			_GFX_container = new ComplexRoundRect(CON_WIDTH, CON_HEIGHT, 25, "linear", [0xFFFFFF, 0xF0F0F0, 0xFFFFFF], [1, 1, 1], [1, 127, 255], 90, 2, 0xFFFFFF, 1);
			with (_GFX_container) 
			{
				x 			= (AppData.stageW / 2) - (_GFX_container.width/2);
				y 			= 80;
			}
			_canvas.addChild(_GFX_container);
			
			_GFX_imgMask 	= new ComplexRoundRect(CON_WIDTH, CON_HEIGHT, 25, "linear", [0x00FF00], [1], [1], 90, 0, 0xFFFFFF, 0);
			with (_GFX_container) 
			{
				x 			= (AppData.stageW / 2) - (_GFX_container.width/2);
				y 			= 80;
			} 
			
			_GFX_imgFrame 	= new ComplexRoundRect(CON_WIDTH, CON_HEIGHT, 25, "linear", [0x00FF00], [0], [1], 90, 3, 0xFFFFFF, 1);
			with (_GFX_imgFrame) 
			{
				x 			= (AppData.stageW / 2) - (_GFX_container.width/2);
				y 			= 80;
			} 
			_canvas.addChild(_GFX_imgFrame);
			
			//++++++++++++++++++++++ text stuff
			_title_product = new ComplexTextField("", "verdana_title", 0xFFFFFF, 20,20,500,"none");
			with (_title_product) 
			{
				x 			= 130;
				y 			= 40;
			}
			_title_product.filters = [new GlowFilter(0xFFFFFF, .3)];
			_canvas.addChild(_title_product);
			
			_text_product = new ComplexTextField("", "verdana_text", 0xFFFFFF, 12, 200, AppData.stageW - 265, "none");
			with (_text_product) 
			{
				x 			= 130;
				y 			= (_GFX_container.height + _GFX_container.y) + 20;
			}
			_canvas.addChild(_text_product);
			
			_GFX_linkLine 	= new ComplexRoundRect(450, 2, 0, "linear", [0xFFFFFF, 0xFFFFFF], [0, 1], [1, 255], 0, 0, 0xFFFFFF, 0);
			with (_GFX_linkLine)
			{
				x			= (AppData.stageW - 100) - _GFX_linkLine.width;
				y 			= (_GFX_container.height + _GFX_container.y) + 90;
			}
			_canvas.addChild(_GFX_linkLine);
			
			//++++++++++++++++++++++ clickables
			_btn_minus 		= new GFX_SideBar_Minus();
			with (_btn_minus) 
			{
				x 			= DIST;
				y			= AppData.stageH / 2;
				alpha		= .7;
				scaleX		= .75;
				scaleY		= .75;
				name 		= "minus";
				buttonMode 	= true;
			}
			_canvas.addChild(_btn_minus);
			
			_btn_plus 		= new GFX_SideBar_Plus();
			with (_btn_plus) 
			{
				x 			= AppData.stageW - DIST;
				y			= AppData.stageH / 2;
				alpha		= .7;
				scaleX		= .75;
				scaleY		= .75;
				name 		= "plus";
				buttonMode 	= true;
			}
			_canvas.addChild(_btn_plus);
			
			_btn_back 		= new BackButton(0xFFFFFF);
			with (_btn_back) 
			{
				x			= 0;
				y			= 0;
			}
			_canvas.addChild(_btn_back);
			
		}
		
//-----------------------------------------------------------------------------
//								link buttons
//-----------------------------------------------------------------------------
		
		private function buildLinkButtons():void
		{
			var link1:String = AppData.productXML.category.(@catName == _productCategory).product[_productID].urlTitle1 + " >";
			var link2:String = AppData.productXML.category.(@catName == _productCategory).product[_productID].urlTitle2 + " >";
			
			if ( link1.length > 2 ) 
			{
				_btn_url1 = new BasicButton("small", "trans", link1, "verdana_title", "bold");
				with (_btn_url1) 
				{
					x 			= (AppData.stageW - 100) - _btn_url1.width;
					y 			= (_GFX_linkLine.height + _GFX_linkLine.y) + 5;
					name		= "link1";
					
				}
				_canvas.addChild(_btn_url1);
				
				TweenLite.from(_btn_url1, 	1, { alpha:0, 	delay:.1 } );
				_btn_url1.addEventListener(MouseEvent.MOUSE_DOWN, 	linkDown, 	false, 0, 	true);
				
			}		
			if ( link2.length > 2) 
			{
				_btn_url2 = new BasicButton("small", "trans", link2, "verdana_title", "bold");
				with (_btn_url2) 
				{
					x 			= _btn_url1.x - (_btn_url2.width + 20);
					y 			= (_GFX_linkLine.height + _GFX_linkLine.y) + 5;
					name 		= "link2";
				}
				_canvas.addChild(_btn_url2);
				
				TweenLite.from(_btn_url2, 	1, { alpha:0, 	delay:.1 } );
				_btn_url2.addEventListener(MouseEvent.MOUSE_DOWN, 	linkDown, 	false, 0, 	true);
			}
		}
		
		private function killLinkButtons():void
		{
			if (_btn_url1) 
			{
				_btn_url1.removeEventListener(MouseEvent.MOUSE_DOWN, 	linkDown);
				_btn_url1.destroy();
				_btn_url1 = null;
			}
			if (_btn_url2) 
			{
				_btn_url2.removeEventListener(MouseEvent.MOUSE_DOWN, 	linkDown);
				_btn_url2.destroy();
				_btn_url2 = null;
			}
		}
		
//-----------------------------------------------------------------------------
//								loader
//-----------------------------------------------------------------------------
		
		private function loadProductImage(imgPath:String):void
		{
			_imgHasLoaded = false;
			
			//if the back button was clicked during a load, the _IMG_product might be hanging around. if it is, kill it.
			if (_IMG_product) {
				_IMG_product.filters = [];
				_GFX_container.removeChild(_IMG_product);
				_GFX_container.removeChild(_GFX_imgMask);
			}
			
			Main.dataLoader.addEventListener(AppEvents.IMAGE_LOADED, productImageLoaded, false, 0, true);
			Main.dataLoader.addEventListener(AppEvents.LOAD_ERROR, 	 imageLoadError, 	false, 0, true);
			Main.dataLoader.loadImage(imgPath);
			
			//add loader graphic
			with (_GFX_loadStar) 
			{
				x 	= _GFX_container.width / 2; 
				y 	= _GFX_container.height/ 2; 
			}
			_GFX_container.addChild(_GFX_loadStar);
			_GFX_loadStar.alpha	= 1;
			_GFX_loadStar.scaleX = 1;
			_GFX_loadStar.scaleY = 1;
			
			TweenLite.from(_GFX_loadStar, .4, {alpha:0, scaleX:.1, scaleY:.1, delay:.2});
		}
		
		private function imageLoadError(e:AppEvents):void 
		{
			Main.dataLoader.removeEventListener(AppEvents.IMAGE_LOADED, productImageLoaded);
			Main.dataLoader.removeEventListener(AppEvents.LOAD_ERROR, 	imageLoadError);
			
			//get image content from event argument
			_IMG_product = new Bitmap( new LoadFail(700, 450))
			_IMG_product.smoothing = true;
			
			//remove loader graphic as soon as load is complete	
			TweenLite.to(_GFX_loadStar, .3, {alpha:0, scaleX:2, scaleY:2,  onComplete: addProductImage } );
		}
		
		private function productImageLoaded(e:AppEvents):void 
		{
			Main.dataLoader.removeEventListener(AppEvents.IMAGE_LOADED, productImageLoaded);
			Main.dataLoader.removeEventListener(AppEvents.LOAD_ERROR, 	imageLoadError);
			
			//get image content from event argument
			_IMG_product = e.arg[0];
			
			//remove loader graphic as soon as load is complete	
			TweenLite.to(_GFX_loadStar, .3, {alpha:0, scaleX:.5, scaleY:.5,  onComplete: addProductImage } );
		}

		private function addProductImage():void
		{
			_GFX_container.removeChild(_GFX_loadStar);
			
			with (_IMG_product)  
			{
				x 			= (_GFX_container.width - _IMG_product.width) / 2;
				y 			= (_GFX_container.height - _IMG_product.height) / 2;
				alpha 		= 0;
			}
			_GFX_container.addChild(_IMG_product);
			
			_GFX_container.addChild(_GFX_imgMask);
			_IMG_product.mask = _GFX_imgMask;

			TweenLite.to(_IMG_product, 	.3, { alpha:1 } );
			
			_imgHasLoaded = true;
		}

//-----------------------------------------------------------------------------
//								animate in and out
//-----------------------------------------------------------------------------	
		
		private function animateIn():void
		{
			TweenLite.from(_GFX_backMask, 	1.0,{ delay:0.1,	alpha:0 } );
			TweenLite.from(_GFX_gradient, 	.5, { delay:0.3,	alpha:0 } );
			TweenLite.from(_GFX_container, 	.5, { delay:0.5,	x:_GFX_container.x - 200,	alpha:0 } );
			TweenLite.from(_GFX_imgFrame, 	.5, { delay:0.5,	x:_GFX_imgFrame.x - 200,	alpha:0 } );
			TweenLite.from(_title_product, 	.5, { delay:0.7,	x:_title_product.x - 25,  	alpha:0 } );
			TweenLite.from(_text_product, 	.5, { delay:0.1,	x:_text_product.x- 25,  	alpha:0 } );
			TweenLite.from(_GFX_linkLine, 	.5, { delay:0.9,	alpha:0 } );
			TweenLite.from(_btn_plus, 		.5, { delay:1.1,	x:_btn_plus.x + 100,  		alpha:0 } );
			TweenLite.from(_btn_minus, 		.5, { delay:1.1,	x:_btn_minus.x - 100,  		alpha:0 } );
			TweenLite.from(_btn_back, 		.5, { delay:1.3,	y:_btn_back.y - 50,  		alpha:0, onComplete:animateIn2 } );
		}
		
		private function animateIn2():void
		{
			TweenLite.to(_GFX_container, .5, { glowFilter: { color:0xFFFFFF, alpha:1, blurX:30, blurY:30 }} );
		}

		private function animateOut():void
		{
			TweenLite.to(_canvas, 	.5, { delay:0.1, alpha:0, onComplete:AppControl.removeProductContent });
		}
			
//-----------------------------------------------------------------------------
//								event handlers
//-----------------------------------------------------------------------------
			
		private function addEventHandlers():void
		{
			_btn_back.addEventListener		(MouseEvent.MOUSE_DOWN, 	backDown, 	false, 0, true);
			
			_btn_plus.addEventListener		(MouseEvent.MOUSE_OVER, 	sideOver, 	false, 0, true);
			_btn_plus.addEventListener		(MouseEvent.MOUSE_OUT, 		sideOut, 	false, 0, true);
			_btn_plus.addEventListener		(MouseEvent.MOUSE_DOWN, 	sideDown, 	false, 0, true);
			
			_btn_minus.addEventListener		(MouseEvent.MOUSE_OVER, 	sideOver, 	false, 0, true);
			_btn_minus.addEventListener		(MouseEvent.MOUSE_OUT, 		sideOut, 	false, 0, true);
			_btn_minus.addEventListener		(MouseEvent.MOUSE_DOWN, 	sideDown, 	false, 0, true);
		}
		
		private function removeEventHandlers():void
		{
			_btn_back.removeEventListener	(MouseEvent.MOUSE_DOWN, 	backDown);
			
			_btn_plus.removeEventListener	(MouseEvent.MOUSE_OVER, 	sideOver);
			_btn_plus.removeEventListener	(MouseEvent.MOUSE_OUT, 		sideOut);
			_btn_plus.removeEventListener	(MouseEvent.MOUSE_DOWN, 	sideDown);
			
			_btn_minus.removeEventListener	(MouseEvent.MOUSE_OVER, 	sideOver);
			_btn_minus.removeEventListener	(MouseEvent.MOUSE_OUT, 		sideOut);
			_btn_minus.removeEventListener	(MouseEvent.MOUSE_DOWN, 	sideDown);
		}
		
		private function sideOver(e:MouseEvent):void 
		{
			switch (e.target.name)
			{
				case "plus":
				{
					TweenLite.to(_btn_plus, .2, { x: AppData.stageW - 30, alpha:1 } );
					break;
				}
				case "minus":
				{
					TweenLite.to(_btn_minus, .2, { x: 30, alpha:1 } );
					break;
				}
			}
		}
		
		private function sideOut(e:MouseEvent):void 
		{
			switch (e.target.name)
			{
				case "plus":
				{
					TweenLite.to(_btn_plus, .2, {x: AppData.stageW - DIST, alpha:.7});
					break;
				}
				case "minus":
				{
					TweenLite.to(_btn_minus, .2, {x: DIST, alpha:.7 } );
					break;
				}
			}
		}
		
		private function sideDown(e:MouseEvent):void 
		{	
			if (_imgHasLoaded) {
				switchImg(e.target.name);	
				_imgHasLoaded = false;
			}
		}

		private function linkDown(e:MouseEvent):void 
		{
			var targetURL:String;
			switch (e.target.parent.name)
			{
				case "link1":
				{
					targetURL = AppData.productXML.category.(@catName == _productCategory).product[_productID].urlPath1;
					break;
				}
				case "link2":
				{
					targetURL = AppData.productXML.category.(@catName == _productCategory).product[_productID].urlPath2;
					break;
				}
			}
			var targetRequest:URLRequest = new URLRequest(targetURL);
			navigateToURL(targetRequest,"_new");
		}
		
		private function backDown(e:MouseEvent):void 
		{
			removeEventHandlers();
			animateOut();
		}
		
//-----------------------------------------------------------------------------
//								interaction
//-----------------------------------------------------------------------------

		private function switchImg(dir:String):void
		{
			if (dir == "plus") 
			{
				_productID++;
				if (_productID >= _categoryLength)
				{
					_productID = 0;
				}
			} 
			else if (dir == "minus")
			{
				_productID--;
				if (_productID < 0)
				{
					_productID = _categoryLength-1;
				}
			}
			switchAnimateOut();
		}
		
		private function switchAnimateOut():void
		{
			TweenLite.to(_text_product, 	.5, { delay:.1, alpha:0, 	blurFilter: { blurX:5, blurY:5,   remove:true }  });
			TweenLite.to(_title_product, 	.5, { delay:.3, alpha:0, 	blurFilter: { blurX:5, blurY:5,   remove:true }  });
			TweenLite.to(_IMG_product, 		.5, { delay:.5, alpha:0, 	blurFilter: { blurX:10, blurY:10, remove:true }, onComplete:loadNewImg });	
			
			if (_btn_url1) 
			{
				TweenLite.to(_btn_url1, 	.4, { alpha:0, 	blurFilter: { blurX:5, blurY:5,   remove:true},	delay:.3, onComplete:killLinkButtons });
			}
			if (_btn_url2) 
			{
				TweenLite.to(_btn_url2, 	.4, { alpha:0, 	blurFilter: { blurX:5, blurY:5,   remove:true},	delay:.3, onComplete:killLinkButtons });
			}
		}
		
		private function loadNewImg():void
		{
			_GFX_container.removeChild(_IMG_product);
			_IMG_product = null;
			
			loadProductImage( AppData.productXML.category.(@catName == _productCategory).product[_productID].imgPath )
			
			_title_product.set_text = AppData.productXML.category.(@catName == _productCategory).product[_productID].header;
			_text_product.set_text 	= AppData.productXML.category.(@catName == _productCategory).product[_productID].text;
			
			buildLinkButtons();
			switchAnimateIn();
		}
		
		private function switchAnimateIn():void
		{
			TweenLite.to(_title_product, .5, { alpha:1} );
			TweenLite.to(_text_product, .5, { alpha:1} );
		}	

		public function deactivate():void
		{
			this.removeChild(_canvas);
			
			killLinkButtons();
			resetPanel();
		}
		
//-----------------------------------------------------------------------------
//	reset final values
//-----------------------------------------------------------------------------

		private function resetPanel():void
		{	
			_text_product.set_text 		= "";
			
			_title_product.set_text 	= "";
			
			_btn_back.y 				= 0;
			
			_productCategory 			= "";
			_productID					= -1;
			_productName				= "";			
			
			_GFX_container.filters		= [];
			
			_canvas.alpha				= 1;
			
			dispatchExitEvent();
		}


		private function dispatchExitEvent():void
		{
			this.dispatchEvent(new AppEvents(AppEvents.PAGE_REMOVED));
		}
	}
}