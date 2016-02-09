package com.b99.display.content 
{
	import com.b99.app.AppData;
	import com.b99.composite.BackButton;
	import com.b99.composite.BasicButton;
	import com.b99.composite.ProductButton;
	import com.b99.element.ComplexTextField;
	import com.b99.interfaces.*;
	import com.greensock.TweenLite;
	import flash.display.BlendMode;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.filters.DropShadowFilter;
	/**
	 * ...
	 * @author bosworth99
	 */
	public class Charity extends Content_Base implements IContent
	{
		//+++++++++++++++++++++++++++++ containers
		private var _btnCon				:Sprite;
		
		//+++++++++++++++++++++++++++++ graphics
		private var _img_texture 		:MovieClip; 
		private var _gfx_maskTexture	:Mask;
		private var _gfx_headerLine		:HeaderLine;
		private var _gfx_footer			:Footer;

		private var _img_fork			:MovieClip;
		private var _img_napkin			:MovieClip;
		
		//+++++++++++++++++++++++++++++ buttons
		private var _img_firstAid		:MovieClip;
		private var _img_foodServices	:MovieClip;
		private var _img_minuet			:MovieClip;
		private var _img_resLiving		:MovieClip;
		
		private var _btn_firstAid		:ProductButton;
		private var _btn_foodServices	:ProductButton;
		private var _btn_minuet			:ProductButton;
		private var _btn_resLiving		:ProductButton;

		private var _btn_back			:BackButton;

		//+++++++++++++++++++++++++++++ text
		private var _mainTitle			:ComplexTextField;
		private var _mainText			:ComplexTextField;
		
		//+++++++++++++++++++++++++++++ misc
		private var _camDirection		:String = "right";
		
//-----------------------------------------------------------------------------
//							constructor
//-----------------------------------------------------------------------------			
		
		public function Charity() 
		{
			super();
			init();
		}
				
		private function init():void
		{
			trace("Charity.init()");
		}

		override public function assembleDisplayObjects():void
		{
			for (var i:int = 0; i < _library.length; i++) 
			{
				instantiateLibraryItem(i);
			}

			//---------------- containers
			_canvas = new Sprite();
			this.addChild(_canvas);
			
			_btnCon	= new Sprite();
			this.addChild(_btnCon);
			
			_flyoutCon = new Sprite();
			this.addChild(_flyoutCon);
			
			//---------------- background
			with (_img_texture) 
			{
				x 			= -20;
				y 			= 311;
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
			_img_texture.mask 		= _gfx_maskTexture;

			_gfx_headerLine 		= new HeaderLine();
			_canvas.addChild(_gfx_headerLine);
			
			_gfx_footer				= new Footer();
			_gfx_footer.blendMode 	= BlendMode.MULTIPLY; 
			_gfx_footer.alpha 		= .7;
			_canvas.addChild(_gfx_footer);
			
			//---------------- buttons
			
			_btn_resLiving = new ProductButton(_img_resLiving, .65);
			with (_btn_resLiving) 
			{
				x			= 183;
				y			= 166;
				name		= "Residential Living";
			}
			_btnCon.addChild(_btn_resLiving);
			
			_btn_minuet = new ProductButton(_img_minuet, .68);
			with (_btn_minuet) 
			{
				x			= 167;
				y			= 325;
				name		= "Lounge Furniture";
			}
			_btnCon.addChild(_btn_minuet);
			
			_btn_foodServices = new ProductButton(_img_foodServices, .94);
			with (_btn_foodServices) 
			{
				x			= 122;
				y			= 503;
				name		= "Food Services";
			}
			_btnCon.addChild(_btn_foodServices);
			
			_btn_firstAid = new ProductButton(_img_firstAid, .60);
			with (_btn_firstAid) 
			{
				x			= 274;
				y			= 585;
				name		= "First Aid";
			}
			_btnCon.addChild(_btn_firstAid);
			
			//---------------- misc graphics
			
			with (_img_napkin)
			{
				x 			= 920;
				y 			= 565;
				scaleX 		= 1;
				scaleY 		= 1;
				rotation	= 15.8;
			}
			_img_napkin.filters = [_objDS]
			_canvas.addChild(_img_napkin);
			
			with (_img_fork)
			{
				x 			= 872;
				y 			= 467;
				scaleX 		= 1;
				scaleY 		= 1;
				rotation	= 7.8;
			}
			_img_fork.filters = [_objDS]
			_canvas.addChild(_img_fork);
			
			//---------------- text
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
				x			= 394;
				y			= 470;
				rotation	= -2;
			}						
			_canvas.addChild(_mainTitle);
			
			_mainText = new ComplexTextField(	
				AppData.nonProfitXML.content.scene.(@name == _name).text.pageContent.mainText,
				"verdana_text",
				AppData.nonProfitXML..scene.(@name == _name).text.pageContent.textColor,
				10,
				350,
				400,
				"none"
				);
			with (_mainText) 
			{
				x			= 396;
				y			= 564;
				rotation	= -2;
			}						
			_canvas.addChild(_mainText);
			
			_btn_back = new BackButton(AppData.nonProfitXML..scene.(@name == _name).text.pageContent.titleColor);
			with (_btn_back)
			{
				x 			= 0;
				y 			= 0;
			}
			_canvas.addChild(_btn_back);
		}	
		
		override public function instantiateLibraryItem(index:uint ):void
		{
			switch (_libNames[index]) 
			{
				case "IMG_charity_firstAid":
					_img_firstAid 		= new _library[index] as MovieClip;
					break;
				case "IMG_charity_foodServices":
					_img_foodServices 	= new _library[index] as MovieClip;
					break;
				case "IMG_charity_fork":
					_img_fork 			= new _library[index] as MovieClip;
					break;
				case "IMG_charity_minuet":
					_img_minuet 		= new _library[index] as MovieClip;
					break;
				case "IMG_charity_napkin":
					_img_napkin 		= new _library[index] as MovieClip;
					break;
				case "IMG_charity_residentialLiving":
					_img_resLiving 		= new _library[index] as MovieClip;
					break;
				case "IMG_charity_texture":
					_img_texture 		= new _library[index] as MovieClip;
					break;
			}
		}

		override public function animateContentIn():void
		{
			TweenLite.from(_img_texture, 		1, { delay:0.1,	x:_img_texture.x,  			y:_img_texture.y + 100,  	alpha:0 } );
			TweenLite.from(_gfx_headerLine, 	1, { delay:0.3,	alpha:0 } );
			TweenLite.from(_gfx_footer, 		1, { delay:0.5,	alpha:0 } );
			TweenLite.from(_btn_resLiving, 		1, { delay:0.7,	x:_btn_resLiving.x - 50,	alpha:0 } );
			TweenLite.from(_btn_minuet,			1, { delay:0.8,	x:_btn_minuet.x - 50, 		alpha:0 } );
			TweenLite.from(_btn_firstAid, 		1, { delay:1.0,	x:_btn_firstAid.x - 50,		alpha:0 } );
			TweenLite.from(_btn_foodServices, 	1, { delay:1.1,	x:_btn_foodServices.x - 50, alpha:0 } );
			TweenLite.from(_img_napkin, 		1, { delay:1.2,	x:_img_napkin.x + 50, 		alpha:0 } );
			TweenLite.from(_img_fork, 			1, { delay:1.3,	x:_img_fork.x + 50, 		alpha:0 } );
			TweenLite.from(_mainTitle, 			1, { delay:1.4,	y:_mainTitle.y + 50, 		alpha:0 } );
			TweenLite.from(_mainText, 			1, { delay:1.5,	y:_mainText.y + 50, 		alpha:0 } );
			TweenLite.from(_btn_back, 			1, { delay:1.6,	x:_btn_back.x-100, 			alpha:0, onComplete:animateInComplete } );
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
			
			TweenLite.to(_btn_back, 		.5, { delay:1.2,	alpha:0, onComplete:animateOutComplete   } );
			TweenLite.to(_img_texture, 		.5, { delay:1.2,	alpha:0 } );
			TweenLite.to(_gfx_headerLine, 	.5, { delay:1.1,	alpha:0 } );
			TweenLite.to(_gfx_footer, 		.5, { delay:1.0,	alpha:0 } );
			TweenLite.to(_btn_resLiving, 	.5, { delay:0.9,	alpha:0 } );
			TweenLite.to(_btn_minuet,		.5, { delay:0.8,	alpha:0 } );
			TweenLite.to(_btn_firstAid, 	.5, { delay:0.6,	alpha:0 } );
			TweenLite.to(_btn_foodServices, .5, { delay:0.5,	alpha:0 } );
			TweenLite.to(_img_napkin, 		.5, { delay:0.4,	alpha:0 } );
			TweenLite.to(_img_fork, 		.5, { delay:0.3,	alpha:0 } );
			TweenLite.to(_mainTitle, 		.5, { delay:0.2,	alpha:0 } );
			TweenLite.to(_mainText, 		.5, { delay:0.1,	alpha:0 } );
		}
		
//-----------------------------------------------------------------------------
//							destroy
//-----------------------------------------------------------------------------				

		override public function removeEventHandlers():void
		{
			_btnCon.removeEventListener(MouseEvent.MOUSE_OVER, 		productOver);
			_btnCon.removeEventListener(MouseEvent.MOUSE_OUT, 		productOut);
			_btnCon.removeEventListener(MouseEvent.MOUSE_DOWN, 		productDown);
			
			_btn_back.removeEventListener(MouseEvent.MOUSE_DOWN,	backDown);
		}	
					
		override public function reset():void
		{
			_img_texture.alpha 			= 1;
			_gfx_headerLine.alpha 		= 1;
			_gfx_footer.alpha 			= .7;
			_btn_resLiving.alpha 		= 1;
			_btn_minuet.alpha 			= 1;
			_btn_firstAid.alpha 		= 1;
			_btn_foodServices.alpha 	= 1;
			_img_napkin.alpha 			= 1;
			_img_fork.alpha 			= 1;
			_mainTitle.alpha 			= 1;
			_mainText.alpha 			= 1;
			_btn_back.alpha 			= 1;
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

class HeaderLine extends Sprite
{
	public function HeaderLine()
	{
		var line:Sprite = new Sprite();
		var color:uint 	= 0x000000;
		
		var top:int 	= 450;
		var right:int 	= AppData.stageW + 5;
		var bottom:int 	= AppData.stageH;
		var left:int 	= -5;
		
		with (line) 
		{ 
			graphics.lineStyle(7, color, 1);
			graphics.moveTo		( right,	top - 100								);
			graphics.curveTo	( right, 	top, 		right - 100, 	top 		);
			graphics.lineTo		( left, 	top + 35								);
		}
		this.addChild(line);
	}
}

class Footer extends Sprite
{
	public function Footer()
	{
		var base:Sprite = new Sprite();
		var color:uint 	= 0x888279;
		
		var top:int 	= 525;
		var right:int 	= 800;
		var bottom:int 	= AppData.stageH;
		var left:int 	= 0;

		with (base) 
		{
			graphics.beginFill(color);
			graphics.moveTo		( left, 		top + 35							);
			graphics.lineTo 	( right, 		top									);
			graphics.curveTo	( right + 40, 	top, 		right + 50,  top + 40 	);
			graphics.lineTo		( right + 65, 	bottom								);
			graphics.lineTo		( left, 		bottom								);
			graphics.lineTo		( left, 		top + 25							);
			graphics.endFill();
		}
		this.addChild(base);
	}
}

class Mask extends Sprite
{
	private var _base :Sprite;
	public function Mask()
	{
		var base:Sprite = new Sprite();
		var color:uint 	= 0x00FF00;
		
		var top:int 	= 450;
		var right:int 	= AppData.stageW + 5;
		var bottom:int 	= AppData.stageH;
		var left:int 	= -5;
		
		with (base) 
		{
			graphics.beginFill(color);
			graphics.moveTo		( left, 	bottom									);
			graphics.lineTo		( right,   	bottom									);
			graphics.lineTo		( right,	top - 100								);
			graphics.curveTo	( right, 	top, 		right - 100, 	top 		);
			graphics.lineTo		( left, 	top + 35								);
			graphics.lineTo		( left, 	bottom									);
			graphics.endFill();
		}
		this.addChild(base);
	}
}



