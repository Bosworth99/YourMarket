package com.b99.composite 
{
	import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	
	/**
	 * ...
	 * @author bosworth99
	 */
	public class ProductButton extends Sprite
	{
		private var _canvas			:Sprite;
		private var _image			:Sprite;
		private var _scale			:Number
		private var _scaleUp		:Number;
		
		public function ProductButton(image:DisplayObject, scale:Number) 
		{
			super();
			
			_image 				= image as Sprite;
			_scale				= scale;
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
			with (_image) 
			{
				scaleX			= _scale;
				scaleY			= _scale;
			}
			this.addChild(_image);
			
			_image.filters 		= [new DropShadowFilter(3,45,0x000000,.3,6,6)];
		}
		
		private function addEventHandlers():void
		{
			this.addEventListener(MouseEvent.MOUSE_OVER, 	over, false, 0 , true);
			this.addEventListener(MouseEvent.MOUSE_OUT, 	out, false, 0 , true);
		}
		
		private function over(e:MouseEvent):void 
		{
			TweenLite.to(_image,.3,{scaleX:_scaleUp, scaleY:_scaleUp, x:0, y:0});
		}
		
		private function out(e:MouseEvent):void 
		{
			TweenLite.to(_image,.3,{scaleX:_scale, scaleY:_scale, x:0, y:0});
		}

	}
}