package com.b99.composite.intro 
{
	import com.greensock.*;
	import com.greensock.easing.*;
	import flash.display.*;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.*;
	import flash.utils.*;
	import org.flintparticles.twoD.emitters.Emitter2D;
	import org.flintparticles.twoD.renderers.DisplayObjectRenderer;
	/**
	 * ...
	 * @author bosworth99
	 */
	public class Fire extends Sprite
	{

		private var 	_flame		:Emitter2D;
		private var 	_spark		:Emitter2D;
		private var 	_renderer	:DisplayObjectRenderer;
		
		public function Fire() 
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
			//var outline:Sprite = new Sprite();
			//with(outline) 
			//{
				//graphics.beginFill(0xFFFFFF, .1);
				//graphics.drawRect(0, 0, 300, 550);
			//}
			//this.addChild(outline);
			
			
			_flame 		= new Flame();
			with (_flame) 
			{
				x	= 25;
				y	= 325;
			}
			_flame.start();
			
			_spark 		= new Spark();
			with (_spark) 
			{
				x	= 150;
				y	= 500;
			}
			_spark.start();
			
			_renderer 	= new DisplayObjectRenderer();
			this.addChild(_renderer); 
			_renderer.addEmitter(_flame);
			_renderer.addEmitter(_spark);
			
		}
		
		
		public function destroy():void
		{
			_flame.stop();
			Flame(_flame).destroy();
			
			_renderer = null;
			_flame = null;
				
			this.parent.removeChild(this);
		}

		
	}
}