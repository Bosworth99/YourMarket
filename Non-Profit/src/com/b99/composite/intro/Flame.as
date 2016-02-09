package com.b99.composite.intro 
{
	import com.greensock.*;
	import com.greensock.easing.*;
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.*;
	import flash.utils.*;
	import org.flintparticles.common.actions.Age;
	import org.flintparticles.common.actions.ColorChange;
	import org.flintparticles.common.actions.ScaleImage;
	import org.flintparticles.common.counters.Steady;
	import org.flintparticles.common.energyEasing.TwoWay;
	import org.flintparticles.common.initializers.ImageClasses;
	import org.flintparticles.common.initializers.Lifetime;
	import org.flintparticles.twoD.actions.Accelerate;
	import org.flintparticles.twoD.actions.Move;
	import org.flintparticles.twoD.emitters.Emitter2D;
	import org.flintparticles.twoD.initializers.Position;
	import org.flintparticles.twoD.initializers.Velocity;
	import org.flintparticles.twoD.zones.DiscZone;
	import org.flintparticles.twoD.zones.LineZone;
	
	/**
	 * ...
	 * @author bosworth99
	 */
	public class Flame extends Emitter2D
	{
		private var _acceleration	:Accelerate;
		private var _timer			:Timer;
		
		public function Flame() 
		{
			super();
			init();
		}
		
		private function init():void
		{
			assembleParams();
			
			_timer = new Timer(1000);
			_timer.addEventListener(TimerEvent.TIMER, flicker, false, 0, true);
			_timer.start();
		}
		
		private function assembleParams()
		{
			counter 	= new Steady(8);
			
			addInitializer( new ImageClasses( [[IMG_flame_1],[IMG_flame_2],[IMG_flame_3],[IMG_flame_4]],[20,10,1,1] ));
			addInitializer( new Lifetime(.8, 1.2));
			addInitializer( new Position( new LineZone(new Point(-20,0), new Point(20,0))));
			addInitializer( new Velocity( new DiscZone( new Point(0, -60), 20, 0)));
		
			addAction( new Age(TwoWay.quadratic) );
			addAction( new Move() );
			addAction( new ColorChange(0xFFFFFFFF, 0x00FFDD66));
			addAction( new ScaleImage(.95, 1));
			
			_acceleration= new Accelerate(0, 0);
			addAction( _acceleration );
		}
		
		private function flicker(e:TimerEvent):void 
		{
			var ranDir:int = Math.random() * 15 - 7;
			var ranHeight:int = -((Math.random() * 10) + 15);
			TweenLite.to(_acceleration, 1.1, { x:ranDir,y:ranHeight,ease:Quint.easeOut});
		}
		
		public function destroy():void
		{
			_timer.removeEventListener(TimerEvent.TIMER, flicker);
			_timer = null;
			_acceleration = null;
			
			
		}
	}
}