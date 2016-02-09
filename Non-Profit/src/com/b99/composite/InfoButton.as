///////////////////////////////////////////////////////////////////////////////
//
//	com>b99>composite>InfoButton.as
//
//	extends : sprite
//
//	Clickable image button for the two informational pages : about ci, service.
//	insert image into frame, add rollover/out effects
//
///////////////////////////////////////////////////////////////////////////////


package com.b99.composite 
{
	import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	
	/**
	 * ...
	 * @author bosworth99
	 */
	public class InfoButton extends Sprite
	{
		private var _canvas			:Sprite;
		private var _image			:Sprite;
		private var _mask			:Sprite;
		private var _frame			:Sprite;
		private var _scale			:Number
		private var _scaleUp		:Number;
		
		public function InfoButton(image:DisplayObject) 
		{
			super();
			
			_image 				= image as Sprite;
			_scale				= 1;
			_scaleUp			= _scale + (_scale * .08);
			
			init();
		}
		
		private function init():void
		{
			mouseChildren 	= false;
			buttonMode		= true;
			
			assembleDisplayObjects();
			addEventHandlers();
		}

		private function assembleDisplayObjects():void
		{	
			_canvas = new Sprite();
			this.addChild(_canvas);
			
			with (_image) 
			{
				scaleX			= _scale;
				scaleY			= _scale;
			}
			_canvas.addChild(_image);
			
			_mask 				= new Sprite();
			with (_mask) 
			{
				graphics.beginFill(0x00FF00, 1);
				graphics.moveTo(-75, -50);
				graphics.lineTo(60, -50);
				graphics.curveTo(75, -50, 75, -35);
				graphics.lineTo(75, 50);
				graphics.lineTo(-75, 50);
				graphics.lineTo(-75, -50);
				graphics.endFill();
			}
			_canvas.addChild(_mask);
			_image.mask = _mask

			_frame 				= new Sprite();
			with (_frame) 
			{
				graphics.lineStyle(2, 0xFFFFFF, 1);
				graphics.moveTo(-75, -50);
				graphics.lineTo(60, -50);
				graphics.curveTo(75, -50, 75, -35);
				graphics.lineTo(75, 50);
				graphics.lineTo(-75, 50);
				graphics.lineTo(-75, -50);
			}
			_canvas.addChild(_frame);
			
			_canvas.filters 		= [new DropShadowFilter(7,45,0x000000,.4,7,7)];
		}
		
		private function addEventHandlers():void
		{
			this.addEventListener(MouseEvent.MOUSE_OVER, 	over, false, 0 , true);
			this.addEventListener(MouseEvent.MOUSE_OUT, 	out, false, 0 , true);
		}
		
		private function over(e:MouseEvent):void 
		{
			TweenLite.to(_image,.3,{scaleX:_scaleUp, scaleY:_scaleUp});
		}
		
		private function out(e:MouseEvent):void 
		{
			TweenLite.to(_image,.3,{scaleX:_scale, scaleY:_scale});
		}

	}
}