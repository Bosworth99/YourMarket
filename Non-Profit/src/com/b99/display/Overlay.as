///////////////////////////////////////////////////////////////////////////////
//
//	com>b99>display>Overlay.as
//
//	extends : sprite
//
//
///////////////////////////////////////////////////////////////////////////////

package com.b99.display 
{
	import com.b99.element.ComplexRoundRect;
	import com.b99.element.ComplexTextField;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import com.b99.app.AppData;
	import flash.filters.GlowFilter;
	
	/**
	 * ...
	 * @author bosworth99
	 */
	public class Overlay extends Sprite
	{
		private var _canvas:Sprite;
		
		private var _top	:Sprite;
		private var _bottom	:Sprite;
		private var _text	:ComplexTextField;
		
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//									constructor
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++		
		public function Overlay() 
		{
			super();
			init();
		}
		
		private function init():void
		{
			assembleDisplayObjects();
		}
		
		private function assembleDisplayObjects():void
		{
			_canvas 		= new Sprite();
			this.addChild(_canvas);
		}
		
		public function addBars():void
		{
			_top 			= new ComplexRoundRect(AppData.stageW, 20, 0, "linear", [0x000000], [1], [1], 90);
			_canvas.addChild(_top);
			
			_bottom 		= new ComplexRoundRect(AppData.stageW, 20, 0, "linear", [0x000000], [1], [1], 90);
			_bottom.y 		= AppData.stageH - 20;
			_canvas.addChild(_bottom);
			
			_text = new ComplexTextField( 	"Your Market: Non-Profit Organizations",
											"verdana_title",
											0xFFFFFF,
											12,
											20,
											250,
											"none"
										);
			with (_text) 
			{
				x			= 720;
				y			= 0;
			}
			_top.addChild(_text);
			_text.filters = [new GlowFilter(0xFFFFFF, .4, 6, 6, 1)];
			
		}
		
	}
}