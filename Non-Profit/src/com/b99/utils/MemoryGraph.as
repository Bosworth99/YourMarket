package com.b99.utils 
{
	import com.b99.app.AppData;
	import com.b99.composite.BasicButton;
	import com.b99.element.ComplexRoundRect;
	import com.b99.element.ComplexTextField;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Rectangle;
	import flash.system.System;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author bosworth99
	 */
	public class MemoryGraph extends Sprite
	{
		private var _canvas		:Sprite;
		private var _base		:ComplexRoundRect;
		private var _frame		:ComplexRoundRect;
		private var _historyRAM	:Array = [];
		private var _avgRam		:Number;
		private var _max		:Number = 0;
		private var _lineCon	:Sprite;
		private var _line		:Sprite;
		private var _redLine	:Sprite;
		private var _text		:ComplexTextField;
		private var _text2		:ComplexTextField;
		private var _text3		:ComplexTextField;
		private var _text4		:ComplexTextField;
		private var _avgFPS		:int;
		private var _historyFPS	:Array = [];
		private var _btn_close	:BasicButton;
		
		public function MemoryGraph() 
		{
			super();
			init();
		}
		
		private function init():void
		{
			for (var i:int = 0; i <= 100; i++) 
			{
				_historyRAM.push(10);
			}
			_avgRam = getAverage(_historyFPS);
			
			for (var j:int = 0; j < 10; j++) 
			{
				_historyFPS.push(10);
			}
			_avgFPS = getAverage(_historyRAM);
			
			assembleDisplayObjects();
			addEventHandlers();
		}

		private function assembleDisplayObjects():void
		{
			_canvas = new Sprite();
			with (_canvas) 
			{
				buttonMode 		= false;
				mouseChildren 	= false;
				mouseEnabled 	= false;
			}
			this.addChild(_canvas);
			
			_base	= new ComplexRoundRect(200, 75, 20, "linear", [0x000000, 0x575757], [.5, .7], [1, 255], 270, 2,0x000000,1);
			_canvas.addChild(_base);
			_base.filters = [new DropShadowFilter(2, 45, 0x000000, .5, 6, 6)];
			
			_lineCon = new Sprite();
			with (_lineCon) 
			{
				x		= 0;
				y 		= 15;
			}
			_canvas.addChild(_lineCon);

			_redLine	= new Sprite();
			with (_redLine) 
			{
				graphics.lineStyle(2, 0xFF0000);
				graphics.moveTo(0, 0);
				graphics.lineTo(200, 0);
			}
			_lineCon.addChild(_redLine);

			_line 		= new Sprite();
			_lineCon.addChild(_line);
			
			_text 		= new ComplexTextField("","verdana_title",0xFFFFFF,12,10,100,"none");
			_text.x		= 10;
			_text.y		= 2;
			_canvas.addChild(_text);
			
			_text2		= new ComplexTextField("","verdana_title",0xFFFFFF,10,10,100,"none");
			_text2.x	= 110;
			_text2.y	= 4;
			_canvas.addChild(_text2); 
			
			_text3		= new ComplexTextField("","verdana_title",0xFFFFFF,8,10,100,"none");
			_text3.x	= 10;
			_text3.y	= 60;
			_canvas.addChild(_text3);
			
			_text4		= new ComplexTextField("", "verdana_title", 0xFFFFFF, 15, 10, 100, "none");
			_text4.x	= 10;
			_text4.y	= 52;
			_canvas.addChild(_text4);

			_frame 		= new ComplexRoundRect(200, 75, 20, "linear", [0x000000, 0x575757], [0, 0], [1, 255], 270, 3,0x000000,1);
			_canvas.addChild(_frame); 
			
			_btn_close 	= new BasicButton("small", "trans", "close");
			with (_btn_close) 
			{
				x		= 162;
				y		= 56;
			}
			this.addChild(_btn_close);
		}
		
		private function addEventHandlers():void
		{
			this.addEventListener(Event.ENTER_FRAME, update, false, 0, true);
			_btn_close.addEventListener(MouseEvent.MOUSE_DOWN, closeDown, false, 0, true);
		}
		
		private function closeDown(e:MouseEvent):void
		{
			Utility.memoryGraphControl();
		}
		
		private function update(e:Event):void 
		{
			//update RAM
			//_avgRam = getAverage(_historyFPS);
			
			var currentRam: Number = Number( System.totalMemory / 1024 / 1024 );
			_historyRAM.splice(0, 1);
			_historyRAM.push( currentRam);
			
			if (currentRam >= _max) 
			{
				_max = currentRam;
			}
			
			with (_line) 
			{
				graphics.clear();
				graphics.lineStyle(2, 0xFFFFFF);
				graphics.moveTo(0, 50 - _historyRAM[0]);
				for (var i:int = 1; i < _historyRAM.length; i++) 
				{
					graphics.lineTo(i * 2, 50 - _historyRAM[i]);
				}
			}
			_redLine.y = 50 - _max;	
		
			_lineCon.y = _max - 20;

			//update FPS
			_historyFPS.splice(0, 1);
			_historyFPS.push(AppData.fps);
			_avgFPS = Math.round(getAverage(_historyFPS));
			
			// update text
			_text.set_text = "RAM: " + currentRam.toFixed(2) + "Mb";
			_text2.set_text = "/ " + _max.toFixed(2) + " max";
			//_text3.set_text = _avgRam.toFixed(2) + " Mb";
			_text4.set_text = _avgFPS.toString() + " FPS";
		}
		
		private function getAverage(target:Array):Number
		{
			var average:Number = 0;
			for (var i:int = 0; i < target.length; i++) 
			{
				average += target[i];
			}
			return average / target.length;
		}
		
	}
}