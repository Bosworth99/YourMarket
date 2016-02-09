package com.b99.composite.intro 
{
	import com.b99.app.AppData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author bosworth99
	 */
	public class Campfire extends Sprite
	{
		private var _base			:MovieClip;
		private var _top			:MovieClip;
		private var _fire			:Fire;
		private var _bg_xTarget		:Number = 0;
		private var _locX			:Number = 0;

		
//-----------------------------------------------------------------------------
//								initialize
//-----------------------------------------------------------------------------

		public function Campfire() 
		{
			super();
			init();
		}
		
		private function init():void
		{
			assembleDisplayObjects();
			addEventHandlers();
		}
		
//-----------------------------------------------------------------------------
//								display objects
//-----------------------------------------------------------------------------		
		
		private function assembleDisplayObjects():void
		{
			_base 	= new IMG_intro_campfire_base();
			this.addChild(_base);
			
			_top 	= new IMG_intro_campfire_top();
			this.addChild(_top);
			
			_fire 	= new Fire();
			with (_fire) 
			{
				y 	= 0;
			}
			this.addChild(_fire);
		}
		
//-----------------------------------------------------------------------------
//							eventHandlers
//-----------------------------------------------------------------------------					
		
		private function addEventHandlers():void
		{
			this.addEventListener(Event.ENTER_FRAME, updateLocation, false, 0, true);
		}
		
		private function updateLocation(e:Event):void 
		{
			_bg_xTarget -= (_bg_xTarget - mouseX ) /20;
			_locX 		+= _bg_xTarget - _locX;
			
			_fire.x 	= (_locX / 25) + 325;
			_top.x 		= (_locX / 30) - 25;
			_base.x 	= (_locX / 50) - 25;

		}
		
//-----------------------------------------------------------------------------
//							destroy
//-----------------------------------------------------------------------------				
		
		public function destroy():void
		{
			this.removeEventListener(Event.ENTER_FRAME, updateLocation);
			
			this.removeChild(_base);
			_base 	= null;
			
			this.removeChild(_top);
			_top 	= null;
			
			_fire.destroy();
			_fire 	= null;
			
			this.parent.removeChild(this);
		}
	}
}