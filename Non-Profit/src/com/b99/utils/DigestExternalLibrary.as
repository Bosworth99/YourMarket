///////////////////////////////////////////////////////////////////////////////
//
//	com>b99>utils>DigestExternalLibrary.as
//
//	extends : EventDispatcher
//	
//	Digest external swf and return array of class refs
//
///////////////////////////////////////////////////////////////////////////////


package com.b99.utils 
{
	import com.b99.app.Main;
	import com.b99.events.AppEvents;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * ...
	 * @author bosworth99
	 */
	public class DigestExternalLibrary extends EventDispatcher
	{
		private var _library			:Array;
		private var _names				:Array;
		
		private var _verbose			:Boolean;
		private var _target				:String;
		private var _name				:String;
		private var _progress			:Number;
		
		private var _loader				:Loader;
		private var _loaderInfo			:LoaderInfo;
		private var _context			:LoaderContext;
		
		private var _loadProgressString	:String = "";
		private var _bytesLoaded		:Number = 0;
		private var _bytesTotal			:Number = 0;
		
//-----------------------------------------------------------------------------
//		initialization
//-----------------------------------------------------------------------------

		public function DigestExternalLibrary(target:IEventDispatcher = null) 
		{
			super(target);
		}
		
		public function ready():void
		{
		}

//-----------------------------------------------------------------------------
//							 loader sequence
//-----------------------------------------------------------------------------		
		public function digestLibrary(target:String, verbose:Boolean):void
		{
			_target 	= "runtimeLibs/"+target;
			_verbose 	= verbose;
			init();
		}
		
		private function init():void
		{
			loadAsset(_target);
		}
		
		private function loadAsset(target:String):void
		{
			_loader = new Loader();
			_context = new LoaderContext(false, ApplicationDomain.currentDomain);

			_loaderInfo = _loader.contentLoaderInfo;
			_loaderInfo.addEventListener(Event.OPEN, 				onOpen, 		false, 0, true);
			_loaderInfo.addEventListener(ProgressEvent.PROGRESS, 	onProgress, 	false, 0, true);
			_loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, 	onIOError, 		false, 0, true);
			_loaderInfo.addEventListener(Event.COMPLETE, 			onComplete, 	false, 0, true);
			
			_loader.load((new URLRequest(target)),_context);
		}
		
		private function onOpen(e:Event):void 
		{
			if (_verbose) 
			{
				trace(_target + " has begun loading");
			}
		}
		
		private function onProgress(e:ProgressEvent):void 
		{
			var loadPercent:int = Math.round((e.bytesLoaded / e.bytesTotal) * 100);
			_progress 			= loadPercent;
			_bytesLoaded 		= e.bytesLoaded;
			_bytesTotal 		= e.bytesTotal;
			
			if (_verbose) {
				_loadProgressString = (loadPercent + " % loaded: " + _bytesLoaded + " bytes of " + _bytesTotal + " total bytes");
				trace(_loadProgressString);
			}
		}
		
		private function onIOError(e:IOErrorEvent):void {
			Main.appDisplay.msgTxt.set_text = "A loading error occurred:\n", e.text;
			if (_verbose) 
			{
				trace("A loading error occurred:\n", e.text);
			}
		}
		
		private function onComplete(e:Event):void 
		{
			_loaderInfo.removeEventListener(Event.OPEN, 			onOpen);
			_loaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			_loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, 	onIOError);
			_loaderInfo.removeEventListener(Event.COMPLETE, 		onComplete);
			
			var tempPackage:Object 	= e.target.content;
			var tempClass:Class 	= Class(getDefinitionByName(getQualifiedClassName(e.target.content)));
			_name 					= tempClass.ASSET_DEF;
			
			_library 				= [];
			_names					= [];
			
			var tempLibrary	:Array 	= [];
			var tempNames	:Array  = [];
			tempLibrary = tempPackage.getAssets();
			
			for (var i:int = 0; i < tempLibrary.length; i++) 
			{
				var tempObj:Class = defineAsset(tempLibrary[i]);
				_library.push(tempObj);
				_names.push(tempLibrary[i]);
			}

			// send name and library along with the event to the caller (DataLoader)
			this.dispatchEvent(new AppEvents(AppEvents.LIBRARY_LOADED, false , false, _name, _library, _names));
			
			_loader = null;	
		}
		
//-----------------------------------------------------------------------------
//							utility
//-----------------------------------------------------------------------------			
		
		private function defineAsset(libItem:String):Class {
			if (_verbose)
			{
				trace("defineAsset():" + libItem);
			}
			var newAsset:Class = getDefinitionByName(libItem) as Class;
			return newAsset;
		}
		
//-----------------------------------------------------------------------------
//							 getter
//-----------------------------------------------------------------------------			
		
		public function get progress()	:Number { return _progress; }
		
		
	}
}