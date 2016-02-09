///////////////////////////////////////////////////////////////////////////////
//
//	com>b99>composite>ProductInfoFlyout.as
//
//	extends : 	sprite
//
//	intent	: 	create mousefollowing label for products
//				called in content pages, during runtime
//				functionality esablished in content_base.as
//
///////////////////////////////////////////////////////////////////////////////

package com.b99.composite 
{
	import com.b99.app.AppData;
	import com.b99.element.*;
	import com.greensock.*;
	import com.greensock.plugins.*;
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author bosworth99
	 */
	
	public class ProductInfoFlyout extends Sprite
	{
		private var _canvas 	:Sprite;
		private var _flyout		:Sprite;
		private var _base		:Shape;
		private var _txt_title	:ComplexTextField;
		private var _title		:String;
		private var _txt_text	:ComplexTextField;
		private var _text		:String;
		private var _line 		:Sprite;
		private var _flyoutPnt	:Point = new Point(0, 0);
		private var _left		:Boolean;
		private var _isInit		:Boolean;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//									construction
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

		public function ProductInfoFlyout(title:String, text:String) 
		{
			super();
			
			_title 	= title;
			_text	= text;
			
			init();
		}
		
		private function init():void
		{
			_isInit = true;
			TweenPlugin.activate([BlurFilterPlugin]);
			
			assembleDisplayObjects();
			addEventHandlers();
			animateIn();
		}

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//									display
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++		
		
		private function assembleDisplayObjects():void
		{
			_canvas 	= new Sprite();
			this.addChild(_canvas);

			_line = new Sprite();
			_canvas.addChild(_line);
			
			_flyout 	= new Sprite();
			if (mouseX <= AppData.stageW / 2) 
			{
				_flyout.x 	= mouseX + 60;
				_flyout.y 	= mouseY - 30;
				_left		= true;
			}
			else
			{
				_flyout.x 	= mouseX - 360;
				_flyout.y 	= mouseY - 30;
				_left		= false;
			}
			_canvas.addChild(_flyout);

			var matrix:Matrix = new Matrix(); 
			matrix.createGradientBox(300, 60, 180);
			
			_base 	= new Shape();
			with (_base) 
			{
				graphics.beginGradientFill(GradientType.LINEAR, [0xFFFFFF, 0xF5F5F5], [.7, .9], [1, 255], matrix);
				graphics.lineStyle(2, 0xFFFFFF, 1);
				if (_left) 
				{
					graphics.moveTo(0, 0)
					graphics.lineTo(280, 0);
					graphics.curveTo(300, 0, 303, 22);
					graphics.lineTo(305, 60);
					graphics.lineTo(0, 60);
					graphics.lineTo(0, 0);
					graphics.endFill();
				}
				else
				{
					graphics.moveTo(300, 0);
					graphics.lineTo(20, 0);
					graphics.curveTo(0, 0, -3, 22);
					graphics.lineTo(-5, 60);
					graphics.lineTo(300, 60);
					graphics.lineTo(300, 0);
					graphics.endFill();
				}
			}
			_flyout.addChild(_base);

			_txt_title = new ComplexTextField( 
												_title,
												"verdana_title",
												0x232323,
												10,
												20,
												250,
												"bold"
											);
			with (_txt_title) 
			{
				x = 15;
				y = 8;
			}
			_flyout.addChild(_txt_title);
			
			_txt_text = new ComplexTextField( 
												_text,
												"verdana_text",
												0x232323,
												10,
												50,
												270,
												"none",
												1
											);
			with (_txt_text) 
			{
				x = 15;
				y = 24;
			}
			_flyout.addChild(_txt_text);	
		}
		
		private function animateIn():void
		{
			_canvas.filters	= [new DropShadowFilter(4,45,0x000000,.5,4,4)];
			
			if (AppData.isFancy)
			{
				TweenLite.from(_canvas, .4, { alpha:.5, blurFilter: { blurX:30, blurY:30, quality:1, remove:true }} );
			}
			else
			{
				TweenLite.from(_canvas, .4, { alpha:.5} );
			}
		}
		
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//									events 
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++		

		private function addEventHandlers():void
		{
			this.addEventListener(Event.ENTER_FRAME, update, false, 0, true);
		}
		
		private function update(e:Event):void
		{
			var dtime :Number = AppData.deltaTime * 2.5;
			
			if (_isInit) 
			{
				if (mouseX <= AppData.stageW / 2) 
				{
					_flyout.x 	= mouseX + 60;
					_flyout.y 	= mouseY - 30;
				}
				else
				{
					_flyout.x 	= mouseX - 360;
					_flyout.y 	= mouseY - 30;
				}
				_isInit = false;
			}
			
			if (mouseX <= AppData.stageW / 2  ) 
			{
				_flyoutPnt.x = (_flyout.x - 15);
				_flyoutPnt.y = (_flyout.y + 30 );
				
				_flyout.x -= (( _flyout.x - ( mouseX + 60 ) ) * dtime);
				_flyout.y -= (( _flyout.y - ( mouseY - 30 ) ) * dtime);
			}
			else
			{
				_flyoutPnt.x = (_flyout.x + _flyout.width) + 5;
				_flyoutPnt.y = (_flyout.y + 30 );
				
				_flyout.x -= (( _flyout.x - ( mouseX - 360) ) * dtime);
				_flyout.y -= (( _flyout.y - ( mouseY - 30 ) ) * dtime);
			}

			if ( _flyout.y < 25) 
			{
				_flyout.y  = 25;
			}
			
			if ( _flyout.y > AppData.stageH - 100) 
			{
				_flyout.y  = AppData.stageH - 100;
			}	
			
			with (_line) 
			{
				graphics.clear();
				
				graphics.beginFill(0xFFFFFF);
				graphics.drawEllipse( mouseX - 5, mouseY - 5, 10, 10 );
				graphics.endFill();
				
				graphics.lineStyle(2, 0xFFFFFF, .8);
				graphics.moveTo(mouseX, mouseY);
				graphics.lineTo(_flyoutPnt.x, _flyoutPnt.y );
				graphics.lineTo(_flyoutPnt.x, _flyoutPnt.y + 30 );
				graphics.lineTo(_flyoutPnt.x, _flyoutPnt.y - 30 );
			}
			
		}

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//									destruction 
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++		
		
		
		public function destroy():void 
		{
			this.removeEventListener(Event.ENTER_FRAME, update);
			
			_txt_text.destroy();
			_txt_text 	= null;
			
			_txt_title.destroy();
			_txt_title 	= null;
			
			_flyout.removeChild(_base);		
			_base 		= null;

			_canvas.removeChild(_flyout);
			_flyout 	= null;
			
			_canvas.removeChild(_line);
			_line 		= null;
			
			_canvas.filters = [];
			this.removeChild(_canvas);
			_canvas 	= null;
			
			this.parent.removeChild(this);
		}
	}
}