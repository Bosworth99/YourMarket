package com.b99.display.content 
{
	import com.b99.app.AppData;
	import com.b99.composite.BasicButton;
	import com.b99.composite.InfoButton;
	import com.b99.composite.Mission;
	import com.b99.element.ComplexTextField;
	import com.b99.interfaces.*;
	import com.greensock.TweenLite;
	import com.greensock.plugins.*;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	/**
	 * ...
	 * @author bosworth99
	 */
	public class AboutCI extends Content_Base implements IContent
	{
		//+++++++++++++++++++++++++++++ containers
		private var _btnCon			:Sprite;
		
		
		//+++++++++++++++++++++++++++++ graphics
		private var _gfx_swoop		:Swoop;
		
		//+++++++++++++++++++++++++++++ buttons
		private var _img_oneStop 	:MovieClip; 
		private var _img_noBids 	:MovieClip; 
		private var _img_economy 	:MovieClip; 
		private var _img_workers 	:MovieClip; 
	
		private var _btn_oneStop	:InfoButton;
		private var _btn_noBids		:InfoButton;
		private var _btn_economy	:InfoButton;
		private var _btn_workers	:InfoButton;
		
		private var _backButton		:BasicButton;

		//+++++++++++++++++++++++++++++ text
		private var _mainTitle		:ComplexTextField;
		private var _mainText		:ComplexTextField;
		private var _mission		:Mission;
		
		//+++++++++++++++++++++++++++++ misc
		private var _camDirection	:String = "centerRight";
		
//-----------------------------------------------------------------------------
//							constructor
//-----------------------------------------------------------------------------		
					
		public function AboutCI() 
		{
			super();
			init();
		}
				
		private function init():void
		{
			trace("AboutCI.init()");
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
			_btn_oneStop	= new InfoButton(_img_oneStop);
			with (_btn_oneStop) 
			{
				x 		= 100;
				y 		= 120;
				name	= "One Stop";
			}
			_btnCon.addChild(_btn_oneStop);
			
			_btn_noBids	= new InfoButton(_img_noBids);
			with (_btn_noBids) 
			{
				x 		= 100;
				y 		= (_btn_oneStop.height + _btn_oneStop.y) + 10;
				name	= "No Bids";
			}
			_btnCon.addChild(_btn_noBids);
			
			_btn_economy	= new InfoButton(_img_economy);
			with (_btn_economy) 
			{
				x 		= _btn_oneStop.width + _btn_oneStop.x;
				y		= 170;
				name 	= "Local Economy";
			}
			_btnCon.addChild(_btn_economy);
			
			_btn_workers	= new InfoButton(_img_workers);
			with (_btn_workers) 
			{
				x 		= _btn_economy.x;
				y 		= (_btn_economy.height + _btn_economy.y) + 10;
				name	= "Offender Workers";
			}
			_btnCon.addChild(_btn_workers);
			
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
				x			= 20;
				y			= 350;
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
				275,
				"none"
				);
			with (_mainText) 
			{
				x			= 20;
				y			= 400;
				rotation	= 0;
			}	
			_mainText.filters = [new GlowFilter(0xFFFFFF, .4, 3, 3, 1)];
			_canvas.addChild(_mainText);
			
			_mission = new Mission(	AppData.nonProfitXML.content.scene.(@name == "AboutCI").text.pageContent.missionTitle,
									AppData.nonProfitXML.content.scene.(@name == "AboutCI").text.pageContent.missionText);
			with (_mission) 
			{
				x			= 620;
				y			= 500;
			}						
			_canvas.addChild(_mission);
			
		}	
		
		override public function instantiateLibraryItem(index:uint ):void
		{
			switch (_libNames[index]) 
			{
				case "IMG_aboutci_economy":
					_img_economy 	= new _library[index] as MovieClip;
					break;
				case "IMG_aboutci_noBids":
					_img_noBids 	= new _library[index] as MovieClip;
					break;
				case "IMG_aboutci_offenderWorkers":
					_img_workers 	= new _library[index] as MovieClip;
					break;
				case "IMG_aboutci_oneStop":
					_img_oneStop 	= new _library[index] as MovieClip;
					break;
			}
		}
		
		override public function animateContentIn():void
		{
			TweenLite.from(_gfx_swoop, 		1, { delay:0.1,	x:_gfx_swoop.x, 		y:_gfx_swoop.y,  		alpha:0 } );
			TweenLite.from(_btn_economy, 	1, { delay:0.2,	x:_btn_economy.x + 50, 	y:_btn_economy.y, 		alpha:0 } );
			TweenLite.from(_btn_noBids,		1, { delay:0.3,	x:_btn_noBids.x + 50, 	y:_btn_noBids.y, 		alpha:0 } );
			TweenLite.from(_btn_oneStop, 	1, { delay:0.4,	x:_btn_oneStop.x + 50, 	y:_btn_oneStop.y, 		alpha:0 } );
			TweenLite.from(_btn_workers, 	1, { delay:0.5,	x:_btn_workers.x + 50,	y:_btn_workers.y, 		alpha:0 } );
			TweenLite.from(_mainTitle, 		1, { delay:0.6,	x:_mainTitle.x, 		y:_mainTitle.y + 50, 	alpha:0 } );
			TweenLite.from(_mainText, 		1, { delay:0.7,	x:_mainText.x, 			y:_mainText.y + 50, 	alpha:0 } );
			TweenLite.from(_mission, 		1, { delay:1.8, x:_mission.x, 			y:_mission.y, 			alpha:0, blurFilter: { blurX:20, blurY:20, quality:2, remove:true }} );
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
			
			TweenLite.to(_gfx_swoop, 	.5, { delay:0.9,	x:_gfx_swoop.x, 	y:_gfx_swoop.y, 	alpha:0, onComplete:animateOutComplete } );
			TweenLite.to(_btn_economy, 	.5, { delay:0.8,	x:_btn_economy.x, 	y:_btn_economy.y, 	alpha:0 } );
			TweenLite.to(_btn_noBids,	.5, { delay:0.7,	x:_btn_noBids.x, 	y:_btn_noBids.y, 	alpha:0 } );
			TweenLite.to(_btn_oneStop, 	.5, { delay:0.6,	x:_btn_oneStop.x, 	y:_btn_oneStop.y, 	alpha:0 } );
			TweenLite.to(_btn_workers, 	.5, { delay:0.5,	x:_btn_workers.x,	y:_btn_workers.y, 	alpha:0 } );
			TweenLite.to(_mainTitle, 	.5, { delay:0.4,	x:_mainTitle.x, 	y:_mainTitle.y, 	alpha:0 } );
			TweenLite.to(_mainText, 	.5, { delay:0.3,	x:_mainText.x, 		y:_mainText.y, 		alpha:0 } );
			TweenLite.to(_mission, 		.5, { delay:0.2,	x:_mission.x, 		y:_mission.y, 		alpha:0 } );
			
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
			_gfx_swoop.alpha 	= 1;
			_btn_economy.alpha 	= 1;
			_btn_noBids.alpha 	= 1;
			_btn_oneStop.alpha 	= 1;
			_btn_workers.alpha 	= 1;
			_mainTitle.alpha 	= 1;
			_mainText.alpha 	= 1;
			_mission.alpha 		= 1;
			
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
		var color:uint 	= 0x4d5d6b;
		
		var top:int 	= -2;
		var right:int 	= 650;
		var bottom:int 	= AppData.stageH + 50;
		var left:int 	= -2;

		with (base) 
		{
			graphics.lineStyle(3, 0xFFFFFF, 1);
			graphics.beginFill(color);
			graphics.moveTo		( left, 	bottom						);
			graphics.lineTo		( left, 	top							);
			graphics.lineTo		( 250, 		top							);
			graphics.curveTo	( 250, 		bottom, 	right, 	bottom 	);
			graphics.lineTo		( left, 	bottom						);
			graphics.endFill();
		}
		this.addChild(base);
	}
}