///////////////////////////////////////////////////////////////////////////////
//
//	com>b99>composite>PanelInfoButton.as
//
//	extends : sprite
//
//	indent	: Shared "learn more" button for info panel
//	Info panel drops down from images to display info about each section
//
///////////////////////////////////////////////////////////////////////////////


package com.b99.composite 
{
	import com.b99.element.ComplexTextField;
	import com.greensock.TweenLite;
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	
	/**
	 * ...
	 * @author bosworth99
	 */
	public class PanelInfoButton extends Sprite
	{
		private var _canvas		:Sprite;
		private var _hit		:Sprite;
		private var _base		:Sprite;
		private var _color		:int;
		private var _text		:ComplexTextField;
		private var _textOver	:ComplexTextField;
		
		private var _arrowCon	:Sprite;
		private var _arrow		:Sprite;
		
		public function PanelInfoButton(color:int) 
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
				graphics.drawRect( -25, -25, 175, 80)
				graphics.endFill();
			}
			_canvas.addChild(_hit);
			
			var matrix:Matrix = new Matrix(); 
			matrix.createGradientBox(125, 30, 80);
			
			//pointy
			//_base = new Sprite();
			//with (_base) 
			//{
				//graphics.clear();	
				//graphics.beginGradientFill(GradientType.LINEAR, [0xFFFFFF, 0xF5F5F5], [.6, .4], [1, 255], matrix);
				//graphics.lineStyle(2, 0xFFFFFF,1);
				//graphics.moveTo(0, 0)
				//graphics.lineTo(110, 0);
				//graphics.curveTo(120, 0, 122, 14);
				//graphics.lineTo(125, 30);
				//graphics.lineTo(0, 30);
				//graphics.lineTo(0, 0);
				//graphics.endFill();
			//}
			
			//rounded
			_base = new Sprite();
			with (_base) 
			{
				graphics.clear();	
				graphics.beginGradientFill(GradientType.LINEAR, [0xFFFFFF, 0xF5F5F5], [.7, .5], [1, 255], matrix);
				graphics.lineStyle(2, 0xFFFFFF,1);
				graphics.moveTo(0, 0)
				graphics.lineTo(112, 0);
				graphics.curveTo(120, 0, 120, 12);
				graphics.lineTo(120, 18);
				graphics.curveTo(120, 30,112, 30);
				graphics.lineTo(0, 30);
				graphics.lineTo(0, 0);
				graphics.endFill();
			}

			_base.filters = [new DropShadowFilter(2, 45, 0x000000, .6, 6, 6, 1)];
			_canvas.addChild(_base);
			
			_arrowCon = new Sprite();
			with (_arrowCon) 
			{
				x 	= 100;
				y 	= 16;
			}
			_canvas.addChild(_arrowCon);
			
			_arrow = new Sprite();
			with (_arrow) 
			{
				graphics.beginFill(0xFFFFFF,1);
				//graphics.lineStyle(1, 0xFFFFFF);
				graphics.moveTo( 0, 0)
				graphics.lineTo( -7, -12);
				graphics.lineTo( 7, 0);
				graphics.lineTo( -7, 12);
				graphics.lineTo(0, 0);
				graphics.endFill();
				alpha = .5;
			}
			_arrow.filters = [new DropShadowFilter(0, 45, 0x000000, .6, 4, 4, 2)];
			_arrowCon.addChild(_arrow);
			
			_text = new ComplexTextField("Learn More", "verdana_text", _color, 12, 15, 80, "italic");
			with (_text) 
			{
				x 		= 12;
				y 		= 6;
			}
			_canvas.addChild(_text);
			
			_textOver = new ComplexTextField("Learn More", "verdana_text", 0xFFFFFF, 12, 15, 80, "italic");
			with (_textOver) 
			{
				x 		= 12;
				y 		= 6;
				alpha 	= 0;
			}
			_textOver.filters = [new DropShadowFilter(0, 45, 0x000000, .6, 5, 5, 2)];
			_canvas.addChild(_textOver);
			
		}
		
		private function addEventHandlers():void
		{
			this.addEventListener(MouseEvent.MOUSE_OVER, over, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_OUT,  out, false, 0, true);
		}
		
		private function out(e:MouseEvent):void
		{
			TweenLite.to(_arrow, 	.3, { scaleX:1, scaleY:1, alpha:.5 } );
			TweenLite.to(_textOver, .3, { alpha:0 } );
		}
		
		private function over(e:MouseEvent):void
		{
			TweenLite.to(_arrow, 	.2, { scaleX:1.2, scaleY:.8, alpha:1 } );
			TweenLite.to(_textOver, .2, { alpha:1 } );
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