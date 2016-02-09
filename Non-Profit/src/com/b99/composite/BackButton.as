package com.b99.composite 
{
	import com.b99.element.ComplexTextField;
	import com.greensock.TweenLite;
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	
	/**
	 * ...
	 * @author bosworth99
	 */
	public class BackButton extends Sprite
	{
		private var _canvas		:Sprite;
		private var _hit		:Sprite;
		private var _base		:Sprite;
		private var _color		:int;
		private var _text		:ComplexTextField;
		private var _textOver	:ComplexTextField;
		
		private var _arrowCon	:Sprite;
		private var _arrow		:Sprite;
		
		public function BackButton(color:int) 
		{
			super();
			
			_color = color;
			
			init();
		}
		
		private function init():void
		{
			assembleDisplayObjects();
			addEventHandlers();
			
			this.buttonMode = true;
			this.mouseChildren = false;
		}
		
		private function assembleDisplayObjects():void
		{
			_canvas = new Sprite();
			this.addChild(_canvas);
			
			_hit = new Sprite();
			with (_hit) 
			{
				graphics.beginFill(0x00FF00, 0);
				graphics.drawRect( 0, 0, 175, 100)
				graphics.endFill();
			}
			_canvas.addChild(_hit);
			
			var matrix:Matrix = new Matrix(); 
			matrix.createGradientBox(80, 50, 80);
			
			_base = new Sprite();
			with (_base) 
			{
				graphics.clear();	
				graphics.beginGradientFill(GradientType.LINEAR, [0xFFFFFF, 0xFFFFFF], [.5, .8], [1, 255], matrix);
				graphics.lineStyle(2, 0x000000,1);
				graphics.moveTo(-5, 0)
				graphics.lineTo(80, 0);
				graphics.lineTo(78, 35);
				graphics.curveTo(78, 50, 60, 50);
				graphics.lineTo(-5, 50);
				graphics.lineTo(-5, 0);
				graphics.endFill();
			}
			_base.filters = [new DropShadowFilter(0, 45, 0x000000, .5, 6, 6, 1)];
			_canvas.addChild(_base);
			
			_arrowCon = new Sprite();
			with (_arrowCon) 
			{
				x 	= 15;
				y 	= 35;
			}
			_canvas.addChild(_arrowCon);
			
			_arrow = new Sprite();
			with (_arrow) 
			{
				graphics.beginFill(0x000000,1);
				graphics.moveTo( 0, 0)
				graphics.lineTo( 7, -10);
				graphics.lineTo( -7, 0);
				graphics.lineTo( 7, 10);
				graphics.lineTo(0, 0);
				graphics.endFill();
				scaleX:1.2;
				scaleY:.8;
			}
			_arrow.filters = [new GlowFilter(0xFFFFFF, 1, 5, 5, 2)];
			_arrowCon.addChild(_arrow);
			
			_text = new ComplexTextField("Back", "verdana_text", 0x000000, 14, 15, 80, "italic");
			with (_text) 
			{
				x 		= 28;
				y 		= 24;
			}
			_canvas.addChild(_text);
			
			_textOver = new ComplexTextField("Back", "verdana_text", 0x000000, 14, 15, 80, "italic");
			with (_textOver) 
			{
				x 		= 28;
				y 		= 24;
				alpha 	= 0;
			}
			_textOver.filters = [new GlowFilter(0xFFFFFF, 1, 6, 6, 2)];
			_canvas.addChild(_textOver);
			
		}
		
		private function addEventHandlers():void
		{
			this.addEventListener(MouseEvent.MOUSE_OVER, over, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_OUT,  out, false, 0, true);
		}
		
		private function out(e:MouseEvent):void
		{
			TweenLite.to(_canvas, 	.2, {y:0} );
			TweenLite.to(_textOver, .2, { alpha:0 } );
		}
		
		private function over(e:MouseEvent):void
		{
			TweenLite.to(_canvas, 	.3, {y:10} );
			TweenLite.to(_textOver, .3, { alpha:1 } );
		}
		
		public function destroy():void
		{
			this.removeEventListener(MouseEvent.MOUSE_OVER, over);
			this.removeEventListener(MouseEvent.MOUSE_OUT,  out);
			
			_canvas.removeChild(_hit);
			_hit 		= null;

			_base.graphics.clear();
			_canvas.removeChild(_base);
			_base 		= null;
			
			_arrowCon.removeChild(_arrow);
			_arrow 		= null;
			
			_canvas.removeChild(_arrowCon);
			_arrowCon 	= null;
			
			_text.destroy();
			_text 		= null;
			
			_textOver.destroy();
			_textOver 	= null;
			
			this.removeChild(_canvas);
			_canvas 	= null;
			
			this.parent.removeChild(this);
		}
		
		
	}
}