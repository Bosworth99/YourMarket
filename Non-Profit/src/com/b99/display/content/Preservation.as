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
	public class Preservation extends Content_Base implements IContent
	{
		//+++++++++++++++++++++++++++++ containers
		private var _btnCon				:Sprite;
		
		//+++++++++++++++++++++++++++++ graphics
		private var _img_texture 		:MovieClip; 
		private var _gfx_maskTexture	:Mask;
		private var _gfx_headerLine		:HeaderLine;
		private var _gfx_footer			:Footer;

		private var _img_ivy			:MovieClip;
		
		//+++++++++++++++++++++++++++++ buttons
		private var _img_janitorial		:MovieClip;	
		private var _img_signage		:MovieClip;	
		private var _img_outdoorFurn	:MovieClip;	
		private var _img_recycleBins	:MovieClip;	

		private var _btn_janitorial		:ProductButton;	
		private var _btn_signage		:ProductButton;	
		private var _btn_outdoorFurn	:ProductButton;	
		private var _btn_recycleBins	:ProductButton;	

		private var _btn_back			:BackButton;

		//+++++++++++++++++++++++++++++ text
		private var _mainTitle			:ComplexTextField;
		private var _mainText			:ComplexTextField;
		
		//+++++++++++++++++++++++++++++ misc
		private var _camDirection		:String = "left";
		
//-----------------------------------------------------------------------------
//							constructor
//-----------------------------------------------------------------------------		
			
		public function Preservation() 
		{
			super();
			init();
		}
				
		private function init():void
		{
			trace("Preservation.init()");
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
			
			_btn_recycleBins = new ProductButton(_img_recycleBins, 1.0);
			with (_btn_recycleBins) 
			{
				x			= 773;
				y			= 174;
				name		= "Recycle Bins";
			}
			_btnCon.addChild(_btn_recycleBins);
			
			_btn_outdoorFurn = new ProductButton(_img_outdoorFurn, .97);
			with (_btn_outdoorFurn) 
			{
				x			= 795;
				y			= 307;
				name		= "Outdoor";
			}
			_btnCon.addChild(_btn_outdoorFurn);
			
			_btn_janitorial = new ProductButton(_img_janitorial, .73);
			with (_btn_janitorial) 
			{
				x			= 875;
				y			= 536;
				name		= "Janitorial";
			}
			_btnCon.addChild(_btn_janitorial);
			
			_btn_signage = new ProductButton(_img_signage, .94);
			with (_btn_signage) 
			{
				x			= 700;
				y			= 586;
				name		= "Signage";
			}
			_btnCon.addChild(_btn_signage);
				
			//---------------- misc graphics
			with (_img_ivy)
			{
				x 			= 69;
				y 			= 624;
				scaleX 		= 1;
				scaleY 		= 1;
				rotation	= 13;
			}
			_img_ivy.filters = [_objDS]
			_canvas.addChild(_img_ivy);
			
			
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
				x			= 170;
				y			= 485;
				rotation	= -2;
			}						
			_canvas.addChild(_mainTitle);
			
			_mainText = new ComplexTextField(	
				AppData.nonProfitXML.content.scene.(@name == _name).text.pageContent.mainText,
				"verdana_text",
				AppData.nonProfitXML..scene.(@name == _name).text.pageContent.textColor,
				10,
				350,
				380,
				"none"
				);
			with (_mainText) 
			{
				x			= 185;
				y			= 569;
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
				case "IMG_preserve_ivy":
					_img_ivy	 		= new _library[index] as MovieClip;
					break;
				case "IMG_preserve_janitorial":
					_img_janitorial 	= new _library[index] as MovieClip;
					break;
				case "IMG_preserve_recycleBins":
					_img_recycleBins 	= new _library[index] as MovieClip;
					break;
				case "IMG_preserve_outdoorFurniture":
					_img_outdoorFurn 	= new _library[index] as MovieClip;
					break;
				case "IMG_preserve_signage":
					_img_signage 		= new _library[index] as MovieClip;
					break;
				case "IMG_preserve_texture":
					_img_texture 		= new _library[index] as MovieClip;
					break;
			}
		}

		override public function animateContentIn():void
		{
			TweenLite.from(_img_texture, 		1, { delay:0.1,	y:_img_texture.y + 100,  	alpha:0 } );
			TweenLite.from(_gfx_headerLine, 	1, { delay:0.3,	alpha:0 } );
			TweenLite.from(_gfx_footer, 		1, { delay:0.5,	alpha:0 } );
			TweenLite.from(_btn_janitorial, 	1, { delay:0.7,	x:_btn_janitorial.x + 50, 	alpha:0 } );
			TweenLite.from(_btn_signage,		1, { delay:0.8,	x:_btn_signage.x + 50, 		alpha:0 } );
			TweenLite.from(_btn_outdoorFurn, 	1, { delay:0.9,	x:_btn_outdoorFurn.x + 50, 	alpha:0 } );
			TweenLite.from(_btn_recycleBins, 	1, { delay:1.0,	x:_btn_recycleBins.x + 50,	alpha:0 } );
			TweenLite.from(_img_ivy, 			1, { delay:1.2,	x:_img_ivy.x - 50, 			alpha:0 } );
			TweenLite.from(_mainTitle, 			1, { delay:1.4,	x:_mainTitle.x + 50, 		alpha:0 } );
			TweenLite.from(_mainText, 			1, { delay:1.5,	x:_mainText.x + 50, 		alpha:0 } );
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
			
			TweenLite.to(_btn_back, 		.5, { delay:1.2,	alpha:0, onComplete:animateOutComplete  } );
			TweenLite.to(_img_texture, 		.5, { delay:1.1,	alpha:0 } );
			TweenLite.to(_gfx_headerLine, 	.5, { delay:1.0,	alpha:0 } );
			TweenLite.to(_gfx_footer, 		.5, { delay:0.9,	alpha:0 } );
			TweenLite.to(_btn_janitorial, 	.5, { delay:0.8,	alpha:0 } );
			TweenLite.to(_btn_signage,		.5, { delay:0.7,	alpha:0 } );
			TweenLite.to(_btn_outdoorFurn, 	.5, { delay:0.6,	alpha:0 } );
			TweenLite.to(_btn_recycleBins, 	.5, { delay:0.5,	alpha:0 } );
			TweenLite.to(_img_ivy, 			.5, { delay:0.4,	alpha:0 } );
			TweenLite.to(_mainTitle, 		.5, { delay:0.3,	alpha:0 } );
			TweenLite.to(_mainText, 		.5, { delay:0.2,	alpha:0 } );
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
			_btn_janitorial.alpha 		= 1;
			_btn_signage.alpha 			= 1;
			_btn_outdoorFurn.alpha 		= 1;
			_btn_recycleBins.alpha 		= 1;
			_img_ivy.alpha 				= 1;
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

class Footer extends Sprite
{
	public function Footer()
	{
		var base:Sprite = new Sprite();
		var color:uint 	= 0x9c958c;
		
		var top:int 	= 525;
		var right:int 	= AppData.stageW + 30;
		var bottom:int 	= AppData.stageH;
		var left:int 	= 200;

		with (base) 
		{
			graphics.beginFill(color);
			graphics.moveTo		( right, 		bottom									);
			graphics.lineTo		( right, 		top - 100								);
			graphics.curveTo	( right, 		top, 		right - 75, 	top 		);
			graphics.lineTo		( left, 		top + 30								);
			graphics.curveTo	( left - 75, 	top + 30, 	left - 90, 		top + 95 	);
			graphics.lineTo		( left - 110, 	bottom									);
			graphics.lineTo		( right, 		bottom									);
			graphics.endFill();
		}
		this.addChild(base);
	}
}

class HeaderLine extends Sprite
{
	public function HeaderLine()
	{
		var line:Sprite = new Sprite();
		var color:uint 	= 0x000000;
		
		var top:int 	= 460;
		var right:int 	= AppData.stageW + 5;
		var bottom:int 	= AppData.stageH;
		var left:int 	= -5;
		
		with (line) 
		{
			graphics.lineStyle(7, color, 1);
			graphics.moveTo		( right,		top - 100							);
			graphics.curveTo	( right, 		top, 		right - 100, 	top 	);
			graphics.lineTo		( left + 80, 	top + 35							);
			graphics.curveTo	( left, 		top + 35, 	left, 		top-40		);
		}
		this.addChild(line);
	}
}

class Mask extends Sprite
{
	private var _base :Sprite;
	public function Mask()
	{
		var base:Sprite = new Sprite();
		var color:uint 	= 0x00FF00;
		
		var top:int 	= 460;
		var right:int 	= AppData.stageW + 5;
		var bottom:int 	= AppData.stageH;
		var left:int 	= -5;
		
		with (base) 
		{
			graphics.beginFill(color);
			graphics.moveTo		( left, 		bottom								);
			graphics.lineTo		( right,   		bottom								);
			graphics.lineTo		( right,		top - 100							);
			graphics.curveTo	( right, 		top, 		right - 100, 	top 	);
			graphics.lineTo		( left + 80, 	top + 35							);
			graphics.curveTo	( left, 		top + 35, 	left, 		top-40		);
			graphics.lineTo		( left, 		bottom								);
			graphics.endFill();
		}
		this.addChild(base);
	}
}


