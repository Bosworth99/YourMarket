package com.b99.utils 
{
	import com.b99.app.AppData;
	import com.b99.app.Main;
	import flash.display.*;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.system.System;
	/**
	 * ...
	 * @author bosworth99
	 */
	public class Utility extends Object
	{
		private static var _memory			:MemoryGraph;
		private static var _deltaTimer		:DeltaFrameTimer;
		
		public function Utility(){}

		public static function memorize():void
		{
			_memory 	= new MemoryGraph();
			with (_memory) 
			{
				x 				= 10;
				y 				= 560;
				name 			= "memoryGraph";
			}
		}
		
		public static function memoryGraphControl():void
		{
			if (Main.appDisplay.overlay.getChildByName("memoryGraph") )
			{
				Main.appDisplay.overlay.removeChild(_memory);
			} 
			else
			{
				Main.appDisplay.overlay.addChild(_memory);
			}
		}

		public static function deltaTimer():void
		{
			_deltaTimer = new DeltaFrameTimer();
			_deltaTimer.start();
			_deltaTimer.addEventListener(TimerEvent.TIMER, updateDeltaTime, false, 0, true);
		}
		
		private static function updateDeltaTime(e:Event):void
		{
			AppData.deltaTime 	= _deltaTimer.dt;
			AppData.fps 		= Math.round( 1000 / _deltaTimer.dtMilli );
		}
		
		public static function killDeltaTimer():void
		{
			_deltaTimer.pause();
			_deltaTimer.removeEventListener(TimerEvent.TIMER, updateDeltaTime);
		}
		
	}
}