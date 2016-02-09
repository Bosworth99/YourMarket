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
	public class Fundraising extends Content_Base implements IContent
	{
		//+++++++++++++++++++++++++++++ containers
		private var _btnCon				:Sprite;
		
		//+++++++++++++++++++++++++++++ graphics
		private var _img_texture 		:MovieClip; 
		private var _gfx_maskTexture	:Mask;
		private var _gfx_headerLine		:HeaderLine;
		private var _gfx_footer			:Footer;
		
		private var _img_foldingChair	:MovieClip;
		private var _img_foldingTable	:MovieClip;
		private var _img_promoItems		:MovieClip;
		private var _img_screenPrinting	:MovieClip;
		
		private var _btn_foldingTable	:ProductButton;
		private var _btn_promoItems		:ProductButton;
		private var _btn_screenPrinting	:ProductButton;

		private var _btn_back			:BackButton;

		//+++++++++++++++++++++++++++++ text
		private var _mainTitle			:ComplexTextField;
		private var _mainText			:ComplexTextField;
		
		private var _camDirection		:String = "left";

//-----------------------------------------------------------------------------
//							constructor
//-----------------------------------------------------------------------------			

		public function Fundraising() 
		{
			super();
			init();
		}
				
		private function init():void
		{
			trace("Fundraising.init()");
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
			_gfx_footer.alpha 		= .6;
			_canvas.addChild(_gfx_footer);
			
			
			_btn_foldingTable = new ProductButton(_img_foldingTable, .87);
			with (_btn_foldingTable) 
			{
				x			= 750; 
				y			= 466;
				name		= "Folding Chairs";
			}
			_btnCon.addChild(_btn_foldingTable);
			
			_btn_screenPrinting = new ProductButton(_img_screenPrinting, .85);
			with (_btn_screenPrinting) 
			{
				x			= 698;
				y			= 388;
				name		= "Screen Printing";
			}
			_btnCon.addChild(_btn_screenPrinting);
			
			_btn_promoItems = new ProductButton(_img_promoItems, .82);
			with (_btn_promoItems) 
			{
				x			= 784;
				y			= 201;
				name		= "Promotional Items";
			}
			_btnCon.addChild(_btn_promoItems);

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
				x			= 32;
				y			= 500;
				rotation	= -3.3;
			}						
			_canvas.addChild(_mainTitle);
			
			_mainText = new ComplexTextField(	
				AppData.nonProfitXML.content.scene.(@name == _name).text.pageContent.mainText,
				"verdana_text",
				AppData.nonProfitXML..scene.(@name == _name).text.pageContent.textColor,
				10,
				300,
				430,
				"none"
				);
			with (_mainText) 
			{
				x			= 48;
				y			= 590;
				rotation	= -3.3;
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
				case "IMG_fund_foldingTable":
					_img_foldingTable 	= new _library[index] as MovieClip;
					break;
				case "IMG_fund_promoItems":
					_img_promoItems 	= new _library[index] as MovieClip;
					break;
				case "IMG_fund_screenPrinting":
					_img_screenPrinting = new _library[index] as MovieClip;
					break;
				case "IMG_fund_texture":
					_img_texture 		= new _library[index] as MovieClip;
					break;
			}
		}
			
		override public function animateContentIn():void
		{
			TweenLite.from(_img_texture, 		1, { delay:0.1,	y:_img_texture.y + 200,  	alpha:0 } );
			TweenLite.from(_gfx_headerLine, 	1, { delay:0.3,	alpha:0 } );
			TweenLite.from(_gfx_footer, 		1, { delay:0.5,	alpha:0 } );
			TweenLite.from(_btn_promoItems, 	1, { delay:0.7,	x:_btn_promoItems.x + 50, 	alpha:0 } );
			TweenLite.from(_btn_foldingTable,	1, { delay:0.8,	x:_btn_foldingTable.x + 50, alpha:0 } );	
			TweenLite.from(_btn_screenPrinting, 1, { delay:0.9,	x:_btn_screenPrinting.x +50,alpha:0 } );
			TweenLite.from(_mainTitle, 			1, { delay:1.1,	x:_mainTitle.x - 25, 		y:_mainTitle.y + 25, 		alpha:0 } );
			TweenLite.from(_mainText, 			1, { delay:1.3,	x:_mainText.x - 25, 		y:_mainText.y + 25, 		alpha:0 } );
			TweenLite.from(_btn_back, 			1, { delay:1.3,	x:_btn_back.x-100, 			alpha:0, onComplete:animateInComplete } );
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
			
			TweenLite.to(_img_texture, 		.5, { delay:1.1,	alpha:0, onComplete:animateOutComplete } );
			TweenLite.to(_btn_back, 		.5, { delay:0.6,	alpha:0 } );
			TweenLite.to(_gfx_headerLine, 	.5, { delay:1.0,	alpha:0 } );
			TweenLite.to(_gfx_footer, 		.5, { delay:0.9,	alpha:0 } );
			TweenLite.to(_btn_promoItems, 	.5, { delay:0.8,	alpha:0 } );
			TweenLite.to(_btn_foldingTable,	.5, { delay:0.7,	alpha:0 } );
			TweenLite.to(_btn_screenPrinting,.5,{ delay:0.5,	alpha:0 } );
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
			_gfx_footer.alpha 			= .6;
			_btn_promoItems.alpha 		= 1;
			_btn_foldingTable.alpha 	= 1;;
			_btn_screenPrinting.alpha 	= 1;
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
			graphics.lineTo		( left, 	top + 50								);
		}
		this.addChild(line);
	}
}

class Footer extends Sprite
{
	public function Footer()
	{
		var base:Sprite = new Sprite();
		var color:uint 	= 0x474D67;
		
		var top:int 	= 550;
		var right:int 	= 480;
		var bottom:int 	= AppData.stageH;
		var left:int 	= 0;

		with (base) 
		{
			graphics.beginFill(color);
			graphics.moveTo		( left, 		top + 25							);
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
			graphics.lineTo		( left, 	top + 50								);
			graphics.lineTo		( left, 	bottom									);
			graphics.endFill();
		}
		this.addChild(base);
	}
}

