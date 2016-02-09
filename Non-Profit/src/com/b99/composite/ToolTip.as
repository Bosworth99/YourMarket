///////////////////////////////////////////////////////////////////////////////
//
//	com>b99>composite>ToolTip.as
//
//	extends : sprite
//
//	Simple message display 
//	implemented on mouse-over events of specific calling objects
//
///////////////////////////////////////////////////////////////////////////////

package com.b99.composite 
{
	import com.b99.app.AppData;
	import com.b99.app.Main;
	import com.b99.element.ComplexRoundRect;
	import com.b99.element.ComplexTextField;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	
	/**
	 * ...
	 * @author bosworth99
	 */
	public class ToolTip extends Sprite
	{
		private var _canvas		:Sprite;
		private var _message	:ComplexTextField;
		private var _base		:ComplexRoundRect;
		private var _text		:String;
		private var _alive		:Boolean;
		
		public function ToolTip(text:String) 
		{
			super();

			if ( text != null)
			{
				_text = text;
				_alive = false;
				
				init();
			}
		}
		
		private function init():void
		{
			this.mouseChildren = false;
			this.mouseEnabled = false;
			
			TweenLite.delayedCall(.5, activate);
		}
		
		private function activate():void
		{
			assembleDisplayObjects();
			addEventHandlers();
			
			_alive = true;
			
			TweenLite.from(_canvas, .2, { alpha:0 } );
		}
		
		private function assembleDisplayObjects():void
		{
			_canvas = new Sprite();
			this.addChild(_canvas);
			
			_message = new ComplexTextField(_text);
			
			_base = new ComplexRoundRect(_message.textWidth + 20, 22, 5, "linear", [0xFFFFFF, 0xF5F5F5], [.7, .9], [1, 255], 80, 2, 0xFFFFFF, 1);
			with(_base) 
			{
				x = mouseX + 10;
				y = mouseY - 20;
			}
			
			_canvas.addChild(_base);
			_base.filters = [new DropShadowFilter(4, 45, 0x000000, .5, 4, 4)];
			
			with (_message) 
			{
				x = 8;
				y = 2;
			}
			_base.addChild(_message);
		}
		
		private function addEventHandlers():void
		{
			this.addEventListener(Event.ENTER_FRAME, update, false, 0, true);
		}
		
		private function update(e:Event):void 
		{
			_base.x = mouseX + 10;
			_base.y = mouseY - 20;
			
			if (_base.x < 0 ) 
			{
				_base.x = 10;
			}
			else if (_base.x + _base.width > AppData.stageW - 10 ) 
			{
				_base.x = AppData.stageW - (_base.width + 10);
			} 
			
			if (_base.y < 0 ) 
			{
				_base.y = 10;
			}
			else if (_base.y + _base.height > AppData.stageH - 10 ) 
			{
				_base.y = AppData.stageH - (_base.height + 10); 
			} 
		}
		
		public function destroy():void
		{
			TweenLite.killDelayedCallsTo(activate);
			TweenLite.killTweensOf(_canvas);
			
			if (_alive) 
			{
				this.removeEventListener(Event.ENTER_FRAME, update);
				
				_message.destroy();
				_message = null;
				
				_base.destroy();
				_base 	= null;
				
				this.removeChild(_canvas);
				_canvas = null;
			}

			this.parent.removeChild(this);
		}
		
	}
}