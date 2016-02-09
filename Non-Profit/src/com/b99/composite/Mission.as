package com.b99.composite 
{
	import com.b99.element.ComplexRoundRect;
	import com.b99.element.ComplexTextField;
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	
	/**
	 * ...
	 * @author bosworth99
	 */
	public class Mission extends Sprite
	{
		private var _canvas		:Sprite;
		private var _base		:Sprite;
		private var _title		:ComplexTextField;
		private var _titleData	:String;
		private var _text		:ComplexTextField;
		private var _textData	:String;
		
		public function Mission(title:String,text:String) 
		{
			super();
			_titleData 	= title;
			_textData	= text;
			
			init();
		}
		
		private function init():void
		{
			assembleDisplayObjects();
		}
		
		private function assembleDisplayObjects():void
		{
			_canvas = new Sprite();
			this.addChild(_canvas);
			
			var matrix:Matrix = new Matrix(); 
			matrix.createGradientBox(350, 145, 180);
			
			_base 	= new Sprite();
			with (_base) 
			{
				graphics.beginGradientFill(GradientType.LINEAR, [0xFFFFFF, 0xF5F5F5], [.7, .9], [1, 255], matrix);
				graphics.lineStyle(2, 0xFFFFFF, 1);
				graphics.moveTo(350, 0);
				graphics.lineTo(25, 0);
				graphics.curveTo(0, 0, -4, 25);
				graphics.lineTo(-6, 145);
				graphics.lineTo(350, 145);
				graphics.lineTo(350, 0);
				graphics.endFill();
			}
			_canvas.addChild(_base);
			_base.filters = [new GlowFilter(0xF8F8EF, .3, 15, 15, 2)];
			
			//---------------- text
			_title = new ComplexTextField(	
				_titleData,
				"verdana_title",
				0x232323,
				12,
				50,
				200,
				"bold"
				);
			with (_title) 
			{
				x			= 25;
				y			= 20;
			}						
			_canvas.addChild(_title);
			
			_text = new ComplexTextField(	
				_textData,
				"verdana_text",
				0x232323,
				10,
				100,
				300,
				"none"
				);
			with (_text) 
			{
				x			= 25;
				y			= 40;
			}						
			_canvas.addChild(_text);
		}
	}
}