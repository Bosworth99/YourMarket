///////////////////////////////////////////////////////////////////////////////
//
//	com>b99>display>ComplexRoundRect.as
//
//	extends : sprite
//
///////////////////////////////////////////////////////////////////////////////

package com.b99.element 
{
	import flash.display.Sprite;
	import flash.display.Graphics;
	import flash.display.GradientType;
	import flash.geom.Matrix;
	/**
	 * ...
	 * @author bosworth99
	 */
	public class ComplexRoundRect extends Sprite
	{
		private var _generic		:Sprite;
		private var _width			:uint;
		private var _height			:uint;
		private var _ellipse		:uint;
		private var _line_width		:uint;
		private var _line_color		:uint;
		private var _grad_type		:String;
		private var _colors			:Array;
		private var _alphas			:Array;
		private var _ratios			:Array;
		private var _grad_rotation	:Number;
		private var _line_alpha		:Number;
		
//-----------------------------------------------------------------------------
//		initialization
//-----------------------------------------------------------------------------
		
		/**
		 * @private construct a round rectangle with specified fill and line style
		 *	add mutliple colors to the gradient by extending the array. each array needs synchronous indexes
		 * 
		 * 
		 * @param	width			:uint	- width of rect
		 * @param	height			:uint	- height of rect
		 * @param 	ellipse			:uint 	- diameter of round corners
		 * @param	line_width		:uint	- pixel thickness of line
		 * @param	line_color		:uint	- line color
		 * @param	line_alpha		:Number	- line alpha
		 * @param	grad_type		:String	- type of gradient "linear" or "radial"
		 * @param	colors			:Array	- color values
		 * @param	alphas			:Array	- aplha values
		 * @param	ratios			:Array 	- gradient ratios for each color/alpha
		 * @param	grad_rotation	:uint	- rotation of gradient
		 */
		public function ComplexRoundRect(width:uint, height:uint, ellipse:uint, grad_type:String, colors:Array, alphas:Array, ratios:Array, grad_rotation:Number, line_width:uint = 1, line_color:uint = 0x000000, line_alpha:Number = 1) 
		{
			super();
			
			_width 			= width;
			_height 		= height;
			_ellipse 		= ellipse;
			_grad_type 		= grad_type;
			_colors			= colors;
			_alphas			= alphas;
			_ratios			= ratios;
			_grad_rotation 	= grad_rotation;
			_line_width 	= line_width;
			_line_color 	= line_color;
			_line_alpha		= line_alpha;
			
			init();
		}
		
		private function init():void
		{
			draw();
		}
		
		private function draw():void
		{
			_generic = new Sprite();
			
			var matrix:Matrix = new Matrix(); 
			matrix.createGradientBox(_width, _height, deg2rad(_grad_rotation));
			switch (_grad_type) {
				case "linear" :
				{
					_grad_type = GradientType.LINEAR;
					break;
				}
				case "radial" :
				{
					_grad_type = GradientType.RADIAL;
					break;
				}	
			}
			
			with (_generic) 
			{
				graphics.lineStyle(_line_width, _line_color, _line_alpha, false);
				graphics.beginGradientFill(_grad_type, _colors, _alphas, _ratios, matrix);
				graphics.drawRoundRect(0, 0, _width, _height, _ellipse, _ellipse);
				graphics.endFill();
			}
			//_generic.cacheAsBitmap = true;
			this.addChild(_generic);
		}
		
		public function destroy():void
		{
			this.removeChild(_generic);
			_generic = null;
			
			this.parent.removeChild(this);
		}
		
		private function deg2rad(deg:Number):Number
		{
			return deg * (Math.PI/180);
		}
		
	}
}