///////////////////////////////////////////////////////////////////////////////
//
//	com>b99>composite>QualityPanel.as
//
//	extends : sprite
//
//	object to hold app-wide quality controls
//	turn filters on or off
//	set stage quality to low, medium, high
//
//	implemented on the user interface.
//
///////////////////////////////////////////////////////////////////////////////

package com.b99.composite 
{
	import com.b99.app.*
	import com.b99.element.*;
	import com.b99.utils.Utility;
	import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	
	/**
	 * ...
	 * @author bosworth99
	 */
	public class QualityPanel extends Sprite
	{
		private var _canvas			:Sprite;
		private var _hit			:Sprite;
		private var _base			:ComplexRoundRect;
		private var _indicator		:Sprite;
		private var _btnContainer	:Sprite;
		private var _btn_low		:BasicButton;
		private var _btn_med		:BasicButton;
		private var _btn_high		:BasicButton;
		private var _btn_best		:BasicButton;
		private var _btn_info		:BasicButton;
		private var _div			:Sprite;
		private var _title			:ComplexTextField;
		private var _info			:ToolTip;
		
		public function QualityPanel() 
		{
			super();
			init();
		}
		
		private function init():void
		{
			assembleDisplayObjects();
			addEventHandlers();
			entryPoint();
			
			this.buttonMode = true;
		}
		
		private function entryPoint():void
		{
			Main.mainStage.quality = StageQuality.HIGH;
			AppData.isFancy = false;

			var target:DisplayObject = _btnContainer.getChildByName("med");
			shiftIndicator(target.x + (target.width/2));
		}
		
		private function assembleDisplayObjects():void
		{
			_canvas 	= new Sprite();
			this.addChild(_canvas);
			
			_hit 		= new ComplexRoundRect(300, 100, 0, "linear", [0x000000, 0x000000], [0, 0], [1, 255], 270, 1, 0x000000, 0);
			with (_hit) 
			{
				x 		= 0;
				y 		= -30;
			}
			_canvas.addChild(_hit);
			
			var baseWidth	: uint;
			(Main.isTest)? baseWidth = 240 : baseWidth = 210;

			_base 		 	= new ComplexRoundRect(baseWidth, 75, 30, "linear", [0x000000, 0x000000], [.9, .6], [1, 255], 270, 2);
			_base.filters 	= [new DropShadowFilter(5, 45, 0x000000, .4, 5, 5)];
			_canvas.addChild(_base);
			
			_title 		= new ComplexTextField("Settings", "verdana_title", 0xE0E0E0, 12, 20, 100, "italic");
			with (_title) 
			{
				x		= 30;
				y		= -20;
				mouseChildren = false;
			}
			_canvas.addChild(_title);
			
			_btnContainer = new Sprite();
			_canvas.addChild(_btnContainer);
			
			_btn_low 	= new BasicButton("med", "trans", "low", "verdana_title", "italic");
			with (_btn_low) 
			{
				x		= 30;
				y 		= 10;
				name 	= "low";
			}
			_btnContainer.addChild(_btn_low);
			
			_btn_med 	= new BasicButton("med", "trans", "med", "verdana_title", "italic");
			with (_btn_med) 
			{
				x		= (_btn_low.x + _btn_low.width) + 6;
				y 		= 10;
				name 	= "med";
			}
			_btnContainer.addChild(_btn_med);
			
			_btn_high 	= new BasicButton("med", "trans", "high", "verdana_title", "italic");
			with (_btn_high) 
			{
				x		= (_btn_med.x + _btn_med.width) + 6;
				y 		= 10;
				name 	= "high";
			}
			_btnContainer.addChild(_btn_high);

			_btn_best 	= new BasicButton("med", "trans", "best", "verdana_title", "italic");
			with (_btn_best) 
			{
				x		= (_btn_high.x + _btn_high.width) + 6;
				y 		= 10;
				name 	= "best";
			}
			_btnContainer.addChild(_btn_best);
			
			if (Main.isTest)
			{
				_btn_info	= new BasicButton("small", "trans", "Info", "verdana_title", "italic");
				with (_btn_info) 
				{
					x		= (_btn_best.x + _btn_best.width) + 15;
					y 		= 14;
					alpha	= .8;
					name 	= "info";
				}
				_btnContainer.addChild(_btn_info);
				
				_div = new Sprite();
				with (_div)
				{
					graphics.lineStyle(2, 0xF5F5F5, .3);
					graphics.moveTo(0, 0);
					graphics.lineTo(0, 15);
					
					x		= _btn_info.x - 5;
					y 		= 15 ;
				}
				_canvas.addChild(_div);
				
			}
			
			_indicator = new Sprite();
			with (_indicator) 
			{
				graphics.lineStyle(2, 0xFFFFFF, .7);
				graphics.moveTo( -18, 0);
				graphics.lineTo(18, 0)
				
				x = 30;
				y = 34;
				
				mouseEnabled = false;
			}
			_canvas.addChild(_indicator);
		}
		
		private function addEventHandlers():void
		{
			_btnContainer.addEventListener(MouseEvent.MOUSE_DOWN, 	qualityDown, 	false, 0, true);
			_btnContainer.addEventListener(MouseEvent.MOUSE_OVER, 	qualityOver, 	false, 0, true);
			_btnContainer.addEventListener(MouseEvent.MOUSE_OUT, 	qualityOut, 	false, 0, true);
			
			if (!Main.isTest)
			{
				Main.mainStage.addEventListener(KeyboardEvent.KEY_DOWN, addConsole);
			}
		}
		
		private var _console:Array = [];
		private function addConsole(e:KeyboardEvent):void
		{
			if (_console.length >= 7) 
			{
				_console.splice(0,1);
				_console.push(e.keyCode.toString());
			} 
			else 
			{
				_console.push(e.keyCode.toString());
			}

			if (_console.toString() == "67,79,78,83,79,76,69") 
			{
				Utility.memoryGraphControl();
			} 
		}
		
		private function qualityOver(e:MouseEvent):void
		{
			if (_info) 
			{
				_info.destroy();
				_info = null;
			}
			
			var txtMessage:String;
			switch (e.target.parent.name)
			{
				case "best":
				{
					txtMessage = "High quality filters. More CPU intensive.";
					break;
				}
				case "high":
				{
					txtMessage = "Low quality filters. Less CPU intensive.";
					break;
				}
				case "med":
				{
					txtMessage = "Filters off. Good performance.";
					break;
				}
				case "low":
				{
					txtMessage = "Filters off. Best performance";
					break;
				}
				case "info":
				{
					txtMessage = "Display System Resources.";
					break;
				}
			}
			_info = new ToolTip(txtMessage);
			Main.appDisplay.userInferace.addChild(_info);
		}

		private function qualityOut(e:MouseEvent):void
		{
			if (_info) 
			{
				_info.destroy();
				_info = null;
			}
		}
		
		private function qualityDown(e:MouseEvent):void 
		{	
			var targetName:String = e.target.parent.name;
			
			switch (targetName)
			{
				case "best":
				{
					Main.mainStage.quality = StageQuality.BEST;
					Main.appDisplay.navigation.makeFancy();
					AppData.isFancy = true;
					trace("Settings:Best");
					break;
				}
				case "high":
				{
					Main.mainStage.quality = StageQuality.HIGH;
					Main.appDisplay.navigation.makeFancy();
					AppData.isFancy = true;
					trace("Settings:High");
					break;
				}
				case "med":
				{
					Main.mainStage.quality = StageQuality.HIGH;
					Main.appDisplay.navigation.makeBasic();
					AppData.isFancy = false;
					trace("Settings:Medium");
					break;
				}
				case "low":
				{
					Main.mainStage.quality = StageQuality.MEDIUM;
					Main.appDisplay.navigation.makeBasic();
					AppData.isFancy = false;
					trace("Settings:Low");
					break;
				}
				case "info":
				{
					Utility.memoryGraphControl();
					break;
				}
			}
			
			if (targetName != "info") 
			{
				var target:DisplayObject = _btnContainer.getChildByName(e.target.parent.name);
				shiftIndicator(target.x + (target.width/2));
			}
		}
		
		private function shiftIndicator(target:int):void
		{
			TweenLite.to(_indicator, .5, { x:target });
		}
	}
}