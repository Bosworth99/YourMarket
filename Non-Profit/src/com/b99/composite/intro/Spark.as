package com.b99.composite.intro 
{
	import flash.geom.Point;
	import org.flintparticles.common.actions.Age;
	import org.flintparticles.common.counters.Random;
	import org.flintparticles.common.displayObjects.Dot;
	import org.flintparticles.common.initializers.ColorInit;
	import org.flintparticles.common.initializers.ImageClasses;
	import org.flintparticles.common.initializers.Lifetime;
	import org.flintparticles.twoD.actions.Move;
	import org.flintparticles.twoD.actions.RandomDrift;
	import org.flintparticles.twoD.actions.RotateToDirection;
	import org.flintparticles.twoD.emitters.Emitter2D;
	import org.flintparticles.twoD.initializers.Position;
	import org.flintparticles.twoD.initializers.Velocity;
	import org.flintparticles.twoD.zones.DiscZone;
	
	/**
	 * ...
	 * @author bosworth99
	 */
	public class Spark extends Emitter2D
	{
		
		public function Spark() 
		{
			super();
			init();
		}
		
		private function init():void
		{
			assembleParams();
		}
		
		private function assembleParams()
		{
			counter = new Random( 0, 3 );
      
			addInitializer( new ImageClasses([[Dot, 1 ]],[1]) );
			addInitializer( new ColorInit( 0xFFFFCC00, 0xFFFFCC00 ) );
			addInitializer( new Position( new DiscZone( new Point(0,0), 40, 0)));
			addInitializer( new Velocity( new DiscZone( new Point( 0, -400 ), 20, 0 ) ) );
			addInitializer( new Lifetime( 0.2, 1.5 ) );
		  
			addAction( new Age() );
			addAction( new Move() );
			addAction( new RandomDrift(50, 50));
			addAction( new RotateToDirection() );
		}
	}

}