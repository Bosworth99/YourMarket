package com.b99.display.content 
{
	import com.b99.app.*;
	import com.b99.composite.*;
	import com.b99.element.*;
	import com.b99.events.*;
	import com.b99.interfaces.*;
	import com.greensock.*;
	import flash.display.*;
	import flash.events.*;
	import flash.filters.DropShadowFilter;
	/**
	 * ...
	 * @author bosworth99
	 */
	public class Volunteer extends Content_Base implements IContent
	{
		private var _btn_back		:BackButton;
		
		private var _btnCon			:Sprite;
		
		private var _img_texture 	:MovieClip; 
		private var _gfx_maskTexture:Mask;
		private var _gfx_header		:Header;
		
		private var _img_shirt2		:MovieClip; 
		private var _img_pen		:MovieClip; 
		private var _img_patches	:MovieClip; 
		private var _img_lanyard	:MovieClip; 
		
		private var _gfx_maskLanyard:Mask;
		
		private var _btn_badge		:ProductButton;
		private var _btn_shirt2		:ProductButton;
		private var _btn_patches	:ProductButton;
		
		//+++++++++++++++++++++++++++++ text
		private var _mainTitle		:ComplexTextField;
		private var _mainText		:ComplexTextField;
		
		//++++++++++++++++++++++++++++++ misc
		private var _camDirection	:String = "right";
		
//-----------------------------------------------------------------------------
//							constructor
//-----------------------------------------------------------------------------		

		public function Volunteer() 
		{
			super();
			init();
		}
		
		private function init():void
		{
			trace("Volunteer.init()");
		}
		/* INTERFACE com.b99.interfaces.IContent */
		override public function assembleDisplayObjects():void
		{
			for (var i:int = 0; i < _library.length; i++) 
			{
				instantiateLibraryItem(i);
			}
			
			_canvas = new Sprite();
			this.addChild(_canvas);
			
			_btnCon	= new Sprite();
			this.addChild(_btnCon);
			
			_flyoutCon = new Sprite();
			this.addChild(_flyoutCon);
			
			with (_img_texture) 
			{
				x 			= 0;
				y 			= 64.5;
			}
			_canvas.addChild(_img_texture);
			_img_texture.filters = [_textureDS];
			
			_gfx_maskTexture = new Mask();
			with (_gfx_maskTexture) 
			{
				x			= 0;
				y			= 0;
			}
			_canvas.addChild(_gfx_maskTexture);
			_img_texture.mask = _gfx_maskTexture;
			
			_gfx_header		= new Header();
			with (_gfx_header) 
			{
				x 			= 0;
				y			= -2;
				alpha		= .8;
			}
			_canvas.addChild(_gfx_header);
			
			_gfx_maskLanyard = new Mask();
			with (_gfx_maskLanyard) 
			{
				x			= 0;
				y			= 0;
			}
			_canvas.addChild(_gfx_maskLanyard);
			
			_btn_shirt2 = new ProductButton(_img_shirt2, .98);
			with (_btn_shirt2) 
			{
				x 			= 222;
				y 			= 131;
				name		= "Embroidered Shirts";
			}
			_btnCon.addChild(_btn_shirt2);
			
			with (_img_pen) 
			{
				x			= 914.5;
				y			= 423;
				scaleX		= .80;
				scaleY		= .80;
				rotation	= 11;
			}
			_canvas.addChild(_img_pen);
			_img_pen.filters = [_objDS];
			
			_btn_patches = new ProductButton(_img_patches, 1.06);
			with (_btn_patches) 
			{
				x			= 227;
				y			= 346;
				name		= "Patches";
			}
			_btnCon.addChild(_btn_patches);
			
			_btn_badge = new ProductButton(_img_lanyard, .88);
			with (_btn_badge) 
			{
				x			= 203;
				y 			= 485;
				name		= "Lanyards";
			}
			_btnCon.addChild(_btn_badge);
			_btn_badge.mask = _gfx_maskLanyard;
											
			_mainTitle = new ComplexTextField(	
				AppData.nonProfitXML.content.scene.(@name == _name).text.pageContent.mainTitle,
				"kaufmann",
				AppData.nonProfitXML..scene.(@name == _name).text.pageContent.titleColor,
				70,
				100,
				420,
				"none"
				);
			with (_mainTitle) 
			{
				x			= 461;
				y			= 479;
				rotation	= 2.8;
			}						
			_canvas.addChild(_mainTitle);
			
			_mainText = new ComplexTextField(	
				AppData.nonProfitXML.content.scene.(@name == _name).text.pageContent.mainText,
				"verdana_text",
				AppData.nonProfitXML..scene.(@name == _name).text.pageContent.textColor,
				10,
				300,
				400,
				"none"
				);
			with (_mainText) 
			{
				x			= 472;
				y			= 562;
				rotation	= 2.8;
			}						
			_canvas.addChild(_mainText);
			
			_btn_back = new BackButton(AppData.nonProfitXML..scene.(@name == _name).text.pageContent.titleColor);
			with (_btn_back)
			{
				x = 0;
				y = 0;
			}
			_canvas.addChild(_btn_back);
		}	
	
		override public function instantiateLibraryItem(index:uint ):void
		{
			switch (_libNames[index]) 
			{
				case "IMG_vol_texture":
					_img_texture 	= new _library[index] as MovieClip;
					break;
				case "IMG_vol_shirt2":
					_img_shirt2 	= new _library[index] as MovieClip;
					break;
				case "IMG_vol_pen":
					_img_pen 		= new _library[index] as MovieClip;
					break;
				case "IMG_vol_patches":
					_img_patches 	= new _library[index] as MovieClip;
					break;
				case "IMG_vol_lanyard":
					_img_lanyard 	= new _library[index] as MovieClip;
					break;
			}
		}
		
		override public function animateContentIn():void
		{
			TweenLite.from(_img_texture, 	1, { delay:0.1,		x:_img_texture.x,  		y:_img_texture.y + 200,  	alpha:0 } );
			TweenLite.from(_gfx_header, 	1, { delay:0.8,		x:_gfx_header.x,  		  							alpha:0 } );
			TweenLite.from(_btn_shirt2, 	1, { delay:0.3,		x:_btn_shirt2.x - 50, 	 							alpha:0 } );
			TweenLite.from(_btn_patches, 	1, { delay:0.7,		x:_btn_patches.x - 50, 								alpha:0 } );
			TweenLite.from(_img_lanyard, 	1, { delay:0.9,		x:_img_lanyard.x - 50, 	 							alpha:0 } );
			TweenLite.from(_btn_badge, 		1, { delay:1.2,		x:_btn_badge.x - 50, 								alpha:0 } );
			TweenLite.from(_mainTitle, 		1, { delay:1.3,		x:_mainTitle.x + 50, 								alpha:0 } );
			TweenLite.from(_mainText, 		1, { delay:1.5,		x:_mainText.x + 50, 								alpha:0 } );
			TweenLite.from(_btn_back, 		1, { delay:1.7,		x:_btn_back.x-100, 									alpha:0 } );
			TweenLite.from(_img_pen, 		1, { delay:1.7,		x:_img_pen.x + 25, 		y:_img_pen.y + 25, 			alpha:0, onComplete:animateInComplete } );
			
		}
		
//-----------------------------------------------------------------------------
//							eventHandlers
//-----------------------------------------------------------------------------				
		
		override public function addEventHandlers():void
		{
			_btnCon.addEventListener(MouseEvent.MOUSE_OVER, 	productOver, 	false, 0, true);
			_btnCon.addEventListener(MouseEvent.MOUSE_OUT, 		productOut,  	false, 0, true);
			_btnCon.addEventListener(MouseEvent.MOUSE_DOWN, 	productDown, 	false, 0, true);
			
			_btn_back.addEventListener(MouseEvent.MOUSE_DOWN,	backDown, 		false, 0, true);
		}
				
//-----------------------------------------------------------------------------
//							animate out
//-----------------------------------------------------------------------------				
		
		override public function animateContentOut():void
		{
			removeEventHandlers();
			
			TweenLite.to(_btn_back, 		.5, { delay:1.2,	alpha:0, onComplete:animateOutComplete } );
			TweenLite.to(_img_texture, 		.5, { delay:1.1,	alpha:0 } );
			TweenLite.to(_gfx_header, 		.5, { delay:0.5,	alpha:0 } );
			TweenLite.to(_btn_shirt2, 		.5, { delay:0.9,	alpha:0 } );
			TweenLite.to(_btn_patches, 		.5, { delay:0.5,	alpha:0 } );
			TweenLite.to(_img_lanyard, 		.5, { delay:0.3,	alpha:0 } );
			TweenLite.to(_btn_badge, 		.5, { delay:0.1,	alpha:0 } );
			TweenLite.to(_mainTitle, 		.5, { delay:0.1,	alpha:0 } );
			TweenLite.to(_mainText, 		.5, { delay:0.1,	alpha:0 } );
			TweenLite.to(_img_pen, 			.5, { delay:0.1,	alpha:0 } );
		}
	
//-----------------------------------------------------------------------------
//							destroy
//-----------------------------------------------------------------------------				

		override public function removeEventHandlers():void
		{
			_btnCon.removeEventListener(MouseEvent.MOUSE_OVER, 	productOver);
			_btnCon.removeEventListener(MouseEvent.MOUSE_OUT, 	productOut);
			_btnCon.removeEventListener(MouseEvent.MOUSE_DOWN, 	productDown);
			
			_btn_back.removeEventListener(MouseEvent.MOUSE_DOWN,	backDown);
		}
		
		override public function reset():void
		{
			_img_texture.alpha 	= 1 ;
			_gfx_header.alpha	= .8 ;
			_btn_shirt2.alpha 	= 1 ;
			_btn_patches.alpha 	= 1 ;
			_img_lanyard.alpha 	= 1 ;
			_btn_badge.alpha 	= 1 ;
			_mainTitle.alpha 	= 1 ;
			_mainText.alpha 	= 1 ;
			_img_pen.alpha 		= 1 ;
			_btn_back.alpha 	= 1 ;
		}

//-----------------------------------------------------------------------------
//							get n set
//-----------------------------------------------------------------------------					

		override public function get camDirection():String { return _camDirection; }
	}
}

//-----------------------------------------------------------------------------
//
//	draw graphics
//
//-----------------------------------------------------------------------------

import com.b99.app.AppData;
import flash.display.*;
class Header extends Sprite
{
	private var _base 	:Sprite;
	private var _line	:Sprite;
	
	public function Header()
	{
		_base = new Sprite();
		with (_base) 
		{
			graphics.beginFill(0xFFFFFF);
			graphics.moveTo		( -5, 					525									);
			graphics.lineTo		( 0, 					350									);
			graphics.curveTo	( 0, 					450, 		100, 				450	);
			graphics.lineTo		( AppData.stageW - 50, 	500 								);
			graphics.curveTo	( AppData.stageW + 50,	500, 		AppData.stageW + 50,600 );
			graphics.lineTo		( AppData.stageW + 50,	675									);
			graphics.curveTo	( AppData.stageW + 50,	575, 		AppData.stageW - 50,575 );
			graphics.lineTo		( 0,					525									);
			graphics.endFill();
		}
		this.addChild(_base);
		
		_line = new Sprite();
		with (_line) 
		{
			graphics.lineStyle(7, 0x000000, 1);
			graphics.moveTo		( -5, 					350									);
			graphics.curveTo	( 0, 					450, 		100, 				450	);
			graphics.lineTo		( AppData.stageW - 50, 	500 								);
			graphics.curveTo	( AppData.stageW + 50,	500, 		AppData.stageW + 50,601 );
		}
		this.addChild(_line);
	}
}

class Mask extends Sprite
{
	private var _base :Sprite;
	
	public function Mask()
	{
		_base = new Sprite();
		with (_base) 
		{
			graphics.beginFill(0x00FF00);
			graphics.moveTo		( 0, 				AppData.stageH							);
			graphics.lineTo		( AppData.stageW+50,AppData.stageH							);
			graphics.lineTo		( AppData.stageW+50,600										);
			graphics.curveTo	( AppData.stageW+50,500, 			AppData.stageW-50, 500  );
			graphics.lineTo		( 100, 				450										);
			graphics.curveTo	( 0, 				450, 			0, 				   350	);
			graphics.lineTo		( 0, 				AppData.stageH							);
			graphics.endFill();
		}
		this.addChild(_base);
	}
}




