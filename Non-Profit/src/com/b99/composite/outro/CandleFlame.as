package com.b99.composite.outro 
{
	import com.greensock.easing.Quint;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import org.flintparticles.common.actions.Age;
	import org.flintparticles.common.actions.ColorChange;
	import org.flintparticles.common.actions.ScaleImage;
	import org.flintparticles.common.counters.Steady;
	import org.flintparticles.common.initializers.Lifetime;
	import org.flintparticles.common.initializers.SharedImage;
	import org.flintparticles.twoD.actions.Accelerate;
	import org.flintparticles.twoD.actions.LinearDrag;
	import org.flintparticles.twoD.actions.Move;
	import org.flintparticles.twoD.emitters.Emitter2D;
	import org.flintparticles.twoD.initializers.Position;
	import org.flintparticles.twoD.initializers.Velocity;
	import org.flintparticles.twoD.renderers.BitmapRenderer;
	import org.flintparticles.twoD.zones.DiscSectorZone;
	import org.flintparticles.twoD.zones.DiscZone;
	
	/**
	 * ...
	 * @author bosworth99
	 */
	public class CandleFlame extends Sprite
	{
		private static var _emitter	:Emitter2D;
		private static var _renderer:BitmapRenderer;
		private var accleration:Accelerate;
		
		public function CandleFlame() 
		{
			super();
			init();
		}
		
		private function init():void
		{
			
			assembleParticleSystem();
		}
		
		private function assembleParticleSystem():void
		{
			//+++++++++++++++++++++++++++++++++ renderer definition
			_renderer 				= new BitmapRenderer(new Rectangle(-200,-200,400,400));
			this.addChild(_renderer); 

			//var blur:BlurFilter 	= new BlurFilter(2, 2, 1);
			var colMatrix:ColorMatrixFilter = new ColorMatrixFilter([
																	1, 0, 0, 0, 0,
																	0, 1, 0, 0, 0,
																	0, 0,.1, 0, 0,
																	0, 0, 0, .6, 0 
																	]);
			
			//_renderer.addFilter(blur);
			_renderer.addFilter(colMatrix);
			
			//+++++++++++++++++++++++++++++++++ emitter definition
			_emitter 			= new Emitter2D();
			_emitter.counter 	= new Steady(150);

			_emitter.addInitializer( new Lifetime(2, 5));
			_emitter.addInitializer( new Velocity( new DiscSectorZone( new Point(0, 0), 12, 5, -Math.PI, 0)));
			_emitter.addInitializer( new Position( new DiscZone( new Point(0, 0), 1)));
			_emitter.addInitializer( new SharedImage( new Bitmap(new FireBall(0, 0)) ));
			
			_emitter.addAction( new Age() );
			_emitter.addAction( new Move() );
			_emitter.addAction( new LinearDrag(1.7) );
			
			accleration = new Accelerate(0, -30);
			_emitter.addAction( accleration );
			_emitter.addAction( new ColorChange(0x06FFFFFF,0x0AFFFFFF));
			_emitter.addAction( new ScaleImage(.8, 2));
			//_emitter.addAction( new RotateToDirection());

			//+++++++++++++++++++++++++++++++ activate it
			_renderer.addEmitter(_emitter);
			_emitter.start();
			_emitter.runAhead(10);
			
			var timer:Timer = new Timer(600);
			timer.addEventListener(TimerEvent.TIMER, flicker, false, 0, true);
			timer.start();
		}
		
		private function flicker(e:Event):void 
		{
			var ranDir:int = Math.random() * 30 - 15;
			var ranHeight:int = -((Math.random() * 22) +15);
			TweenLite.to(accleration, .55, { x:ranDir,y:ranHeight,ease:Quint.easeOut});
			//trace("ranDir: " + ranDir+ "   ranHeight:  "+ranHeight);
		}
	}
}