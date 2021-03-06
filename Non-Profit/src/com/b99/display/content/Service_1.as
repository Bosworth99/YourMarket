package com.b99.display.content 
{
	import com.b99.app.AppData;
	import com.b99.composite.BasicButton;
	import com.b99.composite.InfoButton;
	import com.b99.element.ComplexTextField;
	import com.b99.interfaces.*;
	import com.greensock.TweenLite;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	/**
	 * ...
	 * @author bosworth99
	 */
	public class Service extends Content_Base implements IContent
	{
		//+++++++++++++++++++++++++++++ containers
		private var _btnCon			:Sprite;
		
		//+++++++++++++++++++++++++++++ graphics
		private var _gfx_swoop		:Swoop;
		
		//+++++++++++++++++++++++++++++ buttons
		private var _img_design 	:MovieClip; 
		private var _img_sustain 	:MovieClip; 
		private var _img_furniture 	:MovieClip; 
		private var _img_signs	 	:MovieClip; 

		private var _btn_design		:InfoButton;
		private var _btn_sustain	:InfoButton;
		private var _btn_furniture	:InfoButton;
		private var _btn_signs		:InfoButton;

		private var _backButton		:BasicButton;

		//+++++++++++++++++++++++++++++ text
		private var _mainTitle		:ComplexTextField;
		private var _mainText		:ComplexTextField;
		
		//+++++++++++++++++++++++++++++ misc
		private var _camDirection	:String = "centerLeft";
		
		public function Service() 
		{
			super();
			init();
		}
				
		private function init():void
		{
			trace("Service.init()");
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
			
			_gfx_swoop	= new Swoop();
			_canvas.addChild(_gfx_swoop);
			
			//----------------- buttons
			_btn_design	= new InfoButton(_img_design);
			with (_btn_design) 
			{
				x 		= 840;
				y 		= 120;
				name	= "Custom Design";
			}
			_btnCon.addChild(_btn_design);
			
			_btn_sustain	= new InfoButton(_img_sustain);
			with (_btn_sustain) 
			{
				x 		= 840;
				y 		= (_btn_design.height + _btn_design.y) + 10;
				name	= "Sustainable";
			}
			_btnCon.addChild(_btn_sustain);
			
			_btn_furniture	= new InfoButton(_img_furniture);
			with (_btn_furniture) 
			{
				x 		= _btn_design.x - _btn_furniture.width;
				y 		= 170;
				name	= "Furniture Refurbishing";
			}
			_btnCon.addChild(_btn_furniture);
			
			_btn_signs	= new InfoButton(_img_signs);
			with (_btn_signs) 
			{
				x 		= _btn_furniture.x;
				y 		= (_btn_furniture.height + _btn_furniture.y) + 10;
				name	= "Sign Refurbishing";
			}
			_btnCon.addChild(_btn_signs);

			_backButton = new BasicButton("med", "dark", "back");
			with (_backButton)
			{
				x = 30;
				y = 30;
			}
			_canvas.addChild(_backButton);
			
			//---------------- text
			_mainTitle = new ComplexTextField(	
				AppData.nonProfitXML.content.scene.(@name == _name).text.pageContent.mainTitle,
				"kaufmann",
				AppData.nonProfitXML..scene.(@name == _name).text.pageContent.titleColor,
				30,
				50,
				200,
				"none"
				);
			with (_mainTitle) 
			{
				x			= 680;
				y			= 400;
				rotation	= 0;
			}				
			_mainTitle.filters = [new GlowFilter(0xFFFFFF, .4, 3, 3, 1)];
			_canvas.addChild(_mainTitle);
			
			_mainText = new ComplexTextField(	
				AppData.nonProfitXML.content.scene.(@name == _name).text.pageContent.mainText,
				"verdana_text",
				AppData.nonProfitXML..scene.(@name == _name).text.pageContent.textColor,
				10,
				500,
				250,
				"none"
				);
			with (_mainText) 
			{
				x			= 680;
				y			= 450;
				rotation	= 0;
			}	
			_mainText.filters = [new GlowFilter(0xFFFFFF, .4, 3, 3, 1)];
			_canvas.addChild(_mainText);
			
		}	
		
		override public function instantiateLibraryItem(index:uint ):void
		{
			switch (_libNames[index]) 
			{
				case "IMG_service_customDesign":
					_img_design 	= new _library[index] as MovieClip;
					break;
				case "IMG_service_furnRefurbishing":
					_img_furniture 	= new _library[index] as MovieClip;
					break;
				case "IMG_service_signRefurbishing":
					_img_signs 		= new _library[index] as MovieClip;
					break;
				case "IMG_service_sustainable":
					_img_sustain 	= new _library[index] as MovieClip;
					break;
			}
		}

		override public function animateContentIn():void
		{
			TweenLite.from(_gfx_swoop, 		1, { delay:0.1,	x:_gfx_swoop.x, 		y:_gfx_swoop.y,  		alpha:0 } );
			TweenLite.from(_btn_design, 	1, { delay:0.2,	x:_btn_design.x + 50, 	y:_btn_design.y, 		alpha:0 } );
			TweenLite.from(_btn_sustain,	1, { delay:0.3,	x:_btn_sustain.x + 50, 	y:_btn_sustain.y, 		alpha:0 } );
			TweenLite.from(_btn_furniture, 	1, { delay:0.4,	x:_btn_furniture.x + 50,y:_btn_furniture.y, 	alpha:0 } );
			TweenLite.from(_btn_signs, 		1, { delay:0.5,	x:_btn_signs.x + 50,	y:_btn_signs.y, 		alpha:0 } );
			TweenLite.from(_mainTitle, 		1, { delay:0.6,	x:_mainTitle.x, 		y:_mainTitle.y + 50, 	alpha:0 } );
			TweenLite.from(_mainText, 		1, { delay:0.7,	x:_mainText.x, 			y:_mainText.y + 50, 	alpha:0 } );
			TweenLite.from(_backButton, 	1, { delay:0.9,	x:_backButton.x - 100, 	y:_backButton.y, 		alpha:0, onComplete:animateInComplete } );
		}
		
		
//-----------------------------------------------------------------------------
//							eventHandlers
//-----------------------------------------------------------------------------				
		
		override public function addEventHandlers():void
		{
			_btnCon.addEventListener(MouseEvent.MOUSE_OVER, 	productOver, 	false, 0, true);
			_btnCon.addEventListener(MouseEvent.MOUSE_OUT, 		productOut,  	false, 0, true);
			_btnCon.addEventListener(MouseEvent.MOUSE_DOWN, 	productDown, 	false, 0, true);
			
			_backButton.addEventListener(MouseEvent.MOUSE_DOWN,	backDown, 		false, 0, true);		
		}
	
//-----------------------------------------------------------------------------
//							animate out
//-----------------------------------------------------------------------------		
		
		override public function animateContentOut():void
		{
			removeEventHandlers();
			
			TweenLite.to(_gfx_swoop, 		.5, { delay:0.8,	x:_gfx_swoop.x, 		y:_gfx_swoop.y,  		alpha:0, onComplete:animateOutComplete } );
			TweenLite.to(_btn_design, 		.5, { delay:0.7,	x:_btn_design.x, 		y:_btn_design.y, 		alpha:0 } );
			TweenLite.to(_btn_sustain,		.5, { delay:0.6,	x:_btn_sustain.x, 		y:_btn_sustain.y, 		alpha:0 } );
			TweenLite.to(_btn_furniture, 	.5, { delay:0.5,	x:_btn_furniture.x,		y:_btn_furniture.y, 	alpha:0 } );
			TweenLite.to(_btn_signs, 		.5, { delay:0.4,	x:_btn_signs.x,			y:_btn_signs.y, 		alpha:0 } );
			TweenLite.to(_mainTitle, 		.5, { delay:0.3,	x:_mainTitle.x, 		y:_mainTitle.y, 		alpha:0 } );
			TweenLite.to(_mainText, 		.5, { delay:0.2,	x:_mainText.x, 			y:_mainText.y, 			alpha:0 } );
		
			_backButton.alpha 	= 0;
			_backButton.x 		= -100;
		}
		
//-----------------------------------------------------------------------------
//							destroy
//-----------------------------------------------------------------------------				

		override public function removeEventHandlers():void
		{
			_btnCon.removeEventListener(MouseEvent.MOUSE_OVER, 		productOver);
			_btnCon.removeEventListener(MouseEvent.MOUSE_OUT, 		productOut);
			_btnCon.removeEventListener(MouseEvent.MOUSE_DOWN, 		productDown);
			
			_backButton.removeEventListener(MouseEvent.MOUSE_DOWN,	backDown);
		}		
		
		override public function reset():void
		{
			_gfx_swoop.alpha 		= 1;
			_btn_design.alpha 		= 1;
			_btn_sustain.alpha 		= 1;
			_btn_furniture.alpha 	= 1;
			_btn_signs.alpha 		= 1;
			_mainTitle.alpha 		= 1;
			_mainText.alpha 		= 1;
			
			_backButton.alpha 	= 1;
			_backButton.x		= 30
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

class Swoop extends Sprite
{
	public function Swoop()
	{
		var base:Sprite = new Sprite();
		var color:uint 	= 0x5e6b7a;
		
		var top:int 	= -2;
		var right:int 	= AppData.stageW + 5;
		var bottom:int 	= AppData.stageH + 50;
		var left:int 	= 350;

		with (base) 
		{
			graphics.lineStyle(3, 0xFFFFFF, 1);
			graphics.beginFill(color);
			graphics.moveTo		( left, 		bottom						);
			graphics.lineTo		( right, 		bottom						);
			graphics.lineTo		( right, 		top							);
			graphics.lineTo		( left + 350, 	top							);
			graphics.curveTo	( left + 350, 	bottom, 	left, 	bottom 	);
			graphics.lineTo		( left, 		bottom						);
			graphics.endFill();
		}
		this.addChild(base);
	}
}