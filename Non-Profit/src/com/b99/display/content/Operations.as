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
	import flash.filters.DropShadowFilter;
	/**
	 * ...
	 * @author bosworth99
	 */
	public class Operations extends Content_Base implements IContent
	{
		//+++++++++++++++++++++++++++++ containers
		private var _btnCon				:Sprite;
		
		//+++++++++++++++++++++++++++++ graphics
		private var _img_texture 		:MovieClip; 
		private var _gfx_maskTexture	:Mask;
		private var _gfx_headerLine		:HeaderLine;
		private var _gfx_footer			:Footer;
		
		private var _img_pen			:MovieClip;
		
		//+++++++++++++++++++++++++++++ butttons
		private var _img_volition		:MovieClip;
		private var _img_snap			:MovieClip;
		private var _img_stratus		:MovieClip;
		private var _img_signage		:MovieClip;
		
		private var _btn_volition		:ProductButton;
		private var _btn_stratus		:ProductButton;
		private var _btn_signage		:ProductButton;
		
		private var _btn_back			:BackButton;
		
		//+++++++++++++++++++++++++++++ text
		private var _mainTitle			:ComplexTextField;
		private var _mainText			:ComplexTextField;
		
		private var _camDirection		:String = "left";
//-----------------------------------------------------------------------------
//							constructor
//-----------------------------------------------------------------------------	
		
		public function Operations() 
		{
			super();
			init();
		}
				
		private function init():void
		{
			trace("Operations.init()");
		}

		override public function assembleDisplayObjects():void
		{
			//---------------- library items
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
				x 			= -15;
				y 			= 300;
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
			_gfx_footer.alpha 		= .5;
			_canvas.addChild(_gfx_footer);
	
			with (_img_pen) 
			{
				x			= 30;
				y			= 410;
				scaleX		= .75; 
				scaleY 		= .75;
				rotation	= 9.0;
			}
			_img_pen.filters = [new DropShadowFilter(5, 45, 0x000000, .5, 5, 5)];
			_canvas.addChild(_img_pen);
			
			//---------------- buttons
			_btn_volition = new ProductButton(_img_volition, 1.01);
			with (_btn_volition) 
			{
				x 			= 783;
				y 			= 184;
				name		= "Office Systems";
			}
			_btnCon.addChild(_btn_volition);
			
			_btn_stratus = new ProductButton(_img_stratus, 1.06);
			with (_btn_stratus) 
			{
				x 			= 729;
				y 			= 346;
				name		= "Ergonomic Seating";
			}
			_btnCon.addChild(_btn_stratus);
			
			_btn_signage = new ProductButton(_img_signage, .92);
			with (_btn_signage) 
			{
				x 			= 707;
				y 			= 569;
				name		= "Indoor Signage";
			}
			_btnCon.addChild(_btn_signage);
			
			_btn_back = new BackButton(AppData.nonProfitXML..scene.(@name == _name).text.pageContent.titleColor);
			with (_btn_back)
			{
				x = 0;
				y = 0;
			}
			_canvas.addChild(_btn_back);

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
				x			= 167;
				y			= 486;
				rotation	= -3.0;
			}						
			_canvas.addChild(_mainTitle);
			
			_mainText = new ComplexTextField(	
				AppData.nonProfitXML.content.scene.(@name == _name).text.pageContent.mainText,
				"verdana_text",
				AppData.nonProfitXML..scene.(@name == _name).text.pageContent.textColor,
				10,
				300,
				400,
				"none",
				6
				);
			with (_mainText) 
			{
				x			= 98;
				y			= 573;
				rotation	= -3.0;
			}						
			_canvas.addChild(_mainText);
			
		}	
		
		override public function instantiateLibraryItem(index:uint ):void
		{
			switch (_libNames[index]) 
			{
				case "IMG_operate_texture":
					_img_texture 	= new _library[index] as MovieClip;
					break;
				case "IMG_operate_volition":
					_img_volition 	= new _library[index] as MovieClip;
					break;	
				//case "IMG_operate_snap":
					//_img_snap 		= new _library[index] as MovieClip;
					//break;
				case "IMG_operate_stratus":
					_img_stratus 	= new _library[index] as MovieClip;
					break;	
				case "IMG_operate_signage":
					_img_signage 	= new _library[index] as MovieClip;
					break;	
				case "IMG_operate_pen":
					_img_pen 		= new _library[index] as MovieClip;
					break;	
			}
		}

		override public function animateContentIn():void
		{
			TweenLite.from(_img_texture, 	1, { delay:0.1,		y:_img_texture.y + 200,  	alpha:0 } );
			TweenLite.from(_gfx_headerLine, 1, { delay:0.5,		alpha:0 } );
			TweenLite.from(_gfx_footer, 	1, { delay:0.9,		alpha:0 } );
			TweenLite.from(_btn_volition, 	1, { delay:0.3,		x:_btn_volition.x + 50, alpha:0 } );
			TweenLite.from(_btn_stratus, 	1, { delay:0.9,		x:_btn_stratus.x + 50,  alpha:0 } );
			TweenLite.from(_btn_signage, 	1, { delay:1.1,		x:_btn_signage.x + 50, 	alpha:0 } );
			TweenLite.from(_mainTitle, 		1, { delay:1.3,		x:_mainTitle.x - 35, 	alpha:0 } );
			TweenLite.from(_mainText, 		1, { delay:1.5,		x:_mainText.x - 35, 	alpha:0 } );
			TweenLite.from(_btn_back, 		1, { delay:1.6,		x:_btn_back.x-100, 		alpha:0 } );
			TweenLite.from(_img_pen, 		1, { delay:1.7,		x:_img_pen.x - 25, 		y:_img_pen.y + 50, 			alpha:0, onComplete:animateInComplete } );
		
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
			TweenLite.to(_img_texture, 		.5, { delay:1.2,	alpha:0 } );
			TweenLite.to(_gfx_headerLine, 	.5, { delay:1.1,	alpha:0 } );
			TweenLite.to(_gfx_footer, 		.5, { delay:1.0,	alpha:0 } );
			TweenLite.to(_btn_volition, 	.5, { delay:0.9,	alpha:0 } );
			TweenLite.to(_btn_stratus, 		.5, { delay:0.6,	alpha:0 } );
			TweenLite.to(_btn_signage, 		.5, { delay:0.5,	alpha:0 } );
			TweenLite.to(_mainTitle, 		.5, { delay:0.4,	alpha:0 } );
			TweenLite.to(_mainText, 		.5, { delay:0.3,	alpha:0 } );
			TweenLite.to(_img_pen, 			.5, { delay:0.1,	alpha:0 } );
			
			
		}
		
		override public function removeEventHandlers():void
		{
			_btnCon.removeEventListener(MouseEvent.MOUSE_OVER, 	productOver);
			_btnCon.removeEventListener(MouseEvent.MOUSE_OUT, 	productOut);
			_btnCon.removeEventListener(MouseEvent.MOUSE_DOWN, 	productDown);
			
			_btn_back.removeEventListener(MouseEvent.MOUSE_DOWN,	backDown);
		}
		
		override public function reset():void
		{
			_img_texture.alpha 		= 1;
			_img_pen.alpha 			= 1;
			_gfx_headerLine.alpha 	= 1;
			_gfx_footer.alpha 		= .5;
			_btn_volition.alpha 	= 1;
			_btn_stratus.alpha 		= 1;
			_btn_signage.alpha 		= 1;
			_mainTitle.alpha 		= 1;
			_mainText.alpha 		= 1;
			_btn_back.alpha 		= 1;
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
		var color	:uint 	= 0x000000;
		var top		:int 	= 440;
		var right	:int 	= AppData.stageW + 50;
		var bottom	:int 	= AppData.stageH;
		var left	:int 	= -5;
		
		var line	:Sprite = new Sprite();
		with (line) 
		{
			graphics.lineStyle  ( 7, color, 1);
			graphics.moveTo		( right,			top										);
			graphics.lineTo		( left + 75, 		top + 50								);
			graphics.curveTo	( left, 			top + 50, 			left, 	top - 25 	);
		}
		this.addChild(line);
	}
}

class Footer extends Sprite
{
	private var _base 	:Sprite;	
	public function Footer()
	{
		var color	:uint 	= 0x545C7E;
		var top		:int 	= 540;
		var right	:int 	= 500;
		var bottom	:int 	= AppData.stageH;
		var left	:int 	= -5;
		
		var base	:Sprite = new Sprite();
		with (base) 
		{
			graphics.beginFill(color);
			graphics.moveTo		( left, 			top + 25								);
			graphics.lineTo 	( right, 			top										);
			graphics.curveTo	( right + 40, 		top, 		right + 50,   top + 40		);
			graphics.lineTo		( right + 75, 		bottom									);
			graphics.lineTo		( left, 			bottom									);
			graphics.lineTo		( left, 			top + 25								);
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
		var color	:uint 	= 0x00FF00;
		var top		:int 	= 440;
		var right	:int 	= AppData.stageW + 50;
		var bottom	:int 	= AppData.stageH;
		var left	:int 	= -5;
		
		var base:Sprite = new Sprite();
		with (base) 
		{
			graphics.beginFill	(color);
			graphics.moveTo		( left, 			bottom							);
			graphics.lineTo		( right,			bottom							);
			graphics.lineTo		( right,			top								);
			graphics.lineTo		( left + 75, 		top + 50						);
			graphics.curveTo	( left, 			top + 50, 	left, 	top - 25	);
			graphics.lineTo		( left, 			bottom							);
			graphics.endFill();
		}
		this.addChild(base);
	}
}
