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
	/**
	 * ...
	 * @author bosworth99
	 */
	public class Events extends Content_Base implements IContent
	{
		//+++++++++++++++++++++++++++++ containers
		private var _btnCon				:Sprite;
		
		//+++++++++++++++++++++++++++++ graphics
		private var _img_texture 		:MovieClip; 
		private var _gfx_maskTexture	:Mask;
		private var _gfx_headerLine		:HeaderLine;
		private var _gfx_footer			:Footer;
		
		//+++++++++++++++++++++++++++++ butttons
		private var _img_banner			:MovieClip;
		private var _img_dakotaFront	:MovieClip;
		private var _img_dakotaBack		:MovieClip;
		private var _img_podium			:MovieClip;
		private var _img_award			:MovieClip;
		private var _img_signs			:MovieClip;
		
		private var _btn_banner			:ProductButton;
		private var _btn_dakotaFront	:ProductButton;
		private var _btn_dakotaBack		:ProductButton;
		private var _btn_podium			:ProductButton;
		private var _btn_award			:ProductButton;
		private var _btn_signs			:ProductButton;

		private var _btn_back			:BackButton;
		
		//+++++++++++++++++++++++++++++ text
		private var _mainTitle			:ComplexTextField;
		private var _mainText			:ComplexTextField;
		
		private var _camDirection		:String = "right";
		
		public function Events() 
		{
			super();
			init();
		}
				
		private function init():void
		{
			trace("Events.init()");
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
				y 			= 330;
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
			_gfx_footer.alpha 		= .6;
			_canvas.addChild(_gfx_footer);
			
			//---------------- buttons
			_btn_banner = new ProductButton(_img_banner, .85);
			with (_btn_banner) 
			{
				x			= 148;
				y			= 181;
				name		= "Banners";
			}
			_btnCon.addChild(_btn_banner);
			
			_btn_podium = new ProductButton(_img_podium, .77);
			with (_btn_podium) 
			{
				x			= 202;
				y			= 247;
				name		= "Podiums";
			}
			_btnCon.addChild(_btn_podium);
			
			_btn_dakotaFront = new ProductButton(_img_dakotaFront, .77);
			with (_btn_dakotaFront) 
			{
				x			= 134;
				y			= 281;
				name		= "Seating";
			}
			_btnCon.addChild(_btn_dakotaFront);
			
			_btn_dakotaBack = new ProductButton(_img_dakotaBack, .68);
			with (_btn_dakotaBack) 
			{
				x			= 252;
				y			= 375;
				name		= "Seating";
			}
			_btnCon.addChild(_btn_dakotaBack);
			
			_btn_signs	= new ProductButton(_img_signs, .92);
			with (_btn_signs) 
			{
				x			= 118;
				y			= 546;
				name		= "Signs";
			}
			_btnCon.addChild(_btn_signs);
			
			_btn_award = new ProductButton(_img_award, .77);
			with (_btn_award) 
			{
				x			= 333;
				y			= 576;
				name		= "Awards";
			}
			_btnCon.addChild(_btn_award);
			
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
				x			= 487;
				y			= 480;
				rotation	= -3.8;
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
				x			= 514;
				y			= 577;
				rotation	= -3.8;
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
				case "IMG_event_award":
					_img_award 		= new _library[index] as MovieClip;
					break;
				case "IMG_event_banner":
					_img_banner 	= new _library[index] as MovieClip;
					break;
				case "IMG_event_dakotaBack":
					_img_dakotaBack = new _library[index] as MovieClip;
					break;
				case "IMG_event_dakotaFront":
					_img_dakotaFront = new _library[index] as MovieClip;
					break;
				case "IMG_event_podium":
					_img_podium 	= new _library[index] as MovieClip;
					break;
				case "IMG_event_signs":
					_img_signs 		= new _library[index] as MovieClip;
					break;
				case "IMG_event_texture":
					_img_texture 	= new _library[index] as MovieClip;
					break;
			}
		}

		override public function animateContentIn():void
		{
			TweenLite.from(_img_texture, 	1, { delay:0.1,		y:_img_texture.y + 200,  	alpha:0 } );
			TweenLite.from(_gfx_headerLine, 1, { delay:0.8,		alpha:0 } );
			TweenLite.from(_gfx_footer, 	1, { delay:1.0,		alpha:0 } );
			TweenLite.from(_btn_banner, 	1, { delay:0.3,		x:_btn_banner.x - 50,		alpha:0 } );
			TweenLite.from(_btn_podium, 	1, { delay:0.7,		x:_btn_podium.x - 50, 		alpha:0 } );
			TweenLite.from(_btn_dakotaFront,1, { delay:0.9,		x:_btn_dakotaFront.x - 50, 	alpha:0 } );
			TweenLite.from(_btn_dakotaBack, 1, { delay:1.0,		x:_btn_dakotaBack.x - 50, 	alpha:0 } );
			TweenLite.from(_btn_signs, 		1, { delay:1.1,		x:_btn_signs.x - 50, 		alpha:0 } );
			TweenLite.from(_btn_award, 		1, { delay:1.2,		x:_btn_award.x - 50, 		alpha:0 } );
			TweenLite.from(_mainTitle, 		1, { delay:1.3,		x:_mainTitle.x + 25, 		alpha:0 } );
			TweenLite.from(_mainText, 		1, { delay:1.5,		x:_mainText.x + 25, 		alpha:0 } );
			TweenLite.from(_btn_back, 		1, { delay:1.6,		x:_btn_back.x-100, 			alpha:0, onComplete:animateInComplete } );
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
			
			TweenLite.to(_btn_back, 		.5, { delay:1.2,		alpha:0, onComplete:animateOutComplete  } );
			TweenLite.to(_img_texture, 		.5, { delay:1.1,		alpha:0 } );
			TweenLite.to(_gfx_headerLine, 	.5, { delay:1.0,		alpha:0 } );
			TweenLite.to(_gfx_footer, 		.5, { delay:1.0,		alpha:0 } );
			TweenLite.to(_btn_banner, 		.5, { delay:0.1,		alpha:0 } );
			TweenLite.to(_btn_podium, 		.5, { delay:0.2,		alpha:0 } );
			TweenLite.to(_btn_dakotaFront,	.5, { delay:0.3,		alpha:0 } );
			TweenLite.to(_btn_dakotaBack, 	.5, { delay:0.3,		alpha:0 } );
			TweenLite.to(_btn_signs, 		.5, { delay:0.5,		alpha:0 } );
			TweenLite.to(_btn_award, 		.5, { delay:0.6,		alpha:0 } );
			TweenLite.to(_mainTitle, 		.5, { delay:0.8,		alpha:0 } );
			TweenLite.to(_mainText, 		.5, { delay:0.9,		alpha:0 } );
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
			_img_texture.alpha 		= 1;
			_gfx_headerLine.alpha 	= 1;
			_gfx_footer.alpha 		= .6;
			_btn_banner.alpha 		= 1;
			_btn_podium.alpha 		= 1;
			_btn_dakotaFront.alpha 	= 1;
			_btn_dakotaBack.alpha 	= 1;
			_btn_signs.alpha 		= 1;
			_btn_award.alpha 		= 1;
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
	private var _line	:Sprite;
	public function HeaderLine()
	{
		var line:Sprite = new Sprite();
		var color:uint 	= 0x000000;
		
		var top:int 	= 465;
		var right:int 	= AppData.stageW + 50;
		var bottom:int 	= AppData.stageH;
		var left:int 	= -5;
		
		with (line) 
		{
			graphics.lineStyle(7, color, 1);
			graphics.moveTo		( right,			top	- 25									);
			graphics.lineTo		( left + 65, 		top + 25									);
			graphics.curveTo	( left, 			top + 25, 			left, 		top - 50 	);
		}
		this.addChild(line);
	}
}

class Mask extends Sprite
{
	public function Mask()
	{
		var base:Sprite = new Sprite();
		var color:uint 	= 0x00FF00;
		
		var top:int 	= 465;
		var right:int 	= AppData.stageW + 50;
		var bottom:int 	= AppData.stageH;
		var left:int 	= -5;
		
		with (base) 
		{
			graphics.beginFill(0x00FF00);
			graphics.moveTo		( left, 			bottom										);
			graphics.lineTo		( right,			bottom										);
			graphics.lineTo		( right,			top - 25									);
			graphics.lineTo		( left + 65, 		top + 25									);
			graphics.curveTo	( left, 			top + 25, 			left, 	top - 50		);
			graphics.lineTo		( left, 			bottom										);
			graphics.endFill();
		}
		this.addChild(base);
	}
}

class Footer extends Sprite
{
	public function Footer()
	{
		var base:Sprite = new Sprite();
		var color:uint 	= 0x76755C;
		
		var top:int 	= 515;
		var right:int 	= AppData.stageW+10;
		var bottom:int 	= AppData.stageH;
		var left:int 	= 500;
		
		with (base) 
		{
			graphics.beginFill(0x76755C);
			graphics.moveTo		( right,			top + 10									);
			graphics.lineTo 	( left, 			top + 40									);
			graphics.curveTo	( left - 50, 		top + 40, 		left - 60, 		top + 90	);
			graphics.lineTo		( left - 80, 		bottom										);
			graphics.lineTo		( right,			bottom										);
			graphics.lineTo		( right,			top + 10									);
			graphics.endFill();
		}
		this.addChild(base);
	}
}
