///////////////////////////////////////////////////////////////////////////////
//
//	com>b99>utils>DataLoader.as
//
//	extends : EventDispatcher
//	
//	provide loading of all external assets  
//
///////////////////////////////////////////////////////////////////////////////

package com.b99.utils 
{
	//----------------------- core
	import com.b99.app.AppControl;
	import com.b99.app.Main;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.URLRequest;
	
	//----------------------- b99
	import com.b99.app.AppData;
	import com.b99.events.AppEvents;
	import com.b99.utils.DigestExternalLibrary;
	
	//----------------------- greensock
	import com.greensock.*;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.*;
	import com.greensock.loading.data.LoaderMaxVars;

	/**
	 * ...
	 * @author bosworth99
	 */
	public class DataLoader extends EventDispatcher
	{
		private var _digestExternalLib	:DigestExternalLibrary;
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//									constructor
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++		

		public function DataLoader(target:IEventDispatcher = null) 
		{
			super(target);
			init();
		}
		
		private function init():void
		{
			_digestExternalLib = new DigestExternalLibrary();
			trace("DataLoader.init()")
		}
		
		public function ready():void
		{
			trace("DataLoader.ready()");
		}
		
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//									XML 
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++			
				
		/**
		 * called from appControl
		 * employ loaderMax to queue all xml in preparation of 
		 * application activation
		 * dispatch AppEvents when load is complete
		 */
		private var _queueXML	:LoaderMax;
		public function loadXML():void
		{
			trace("DataLoader.loadXML()");
			
			var _loadVars:LoaderMaxVars= new LoaderMaxVars();
			_loadVars.name 			= "_queueXML";
			_loadVars.onComplete 	= XMLcomplete;
			_loadVars.onProgress 	= XMLprogress;
			_loadVars.onError		= XMLerror;
			_loadVars.onChildFail 	= XMLerror;
			_loadVars.onIOError		= XMLerror;
			_loadVars.autoDispose	= true;
			_loadVars.auditSize		= false;
			_queueXML 	= new LoaderMax(_loadVars);
			
			_queueXML.append( new XMLLoader("../xml/nonProfit_data.xml", {name:"xml_nonProfit"}) );
			_queueXML.append( new XMLLoader("../xml/product_data.xml", 	{name:"xml_product"}) );
			
			_queueXML.load();
		}
		
		private function XMLerror(e:LoaderEvent):void
		{
		    Main.appDisplay.msgTxt.set_text = "error occured with " + e.target + ": " + e.text;
			trace("error occured with " + e.target + ": " + e.text);
		}
		private function XMLprogress(e:LoaderEvent):void
		{
			//Main.appDisplay._msgTxt.set_text = "progress: " + e.target.progress;
			trace("progress: " + e.target.progress);
		}
		private function XMLcomplete(e:LoaderEvent):void
		{
			//set app data
			var xml_nonProfit:XML = _queueXML.getContent("xml_nonProfit");
			AppData.nonProfitXML = xml_nonProfit;
				
			var xml_product:XML = _queueXML.getContent("xml_product");
			AppData.productXML = xml_product;
			
			//inform AppControl
			this.dispatchEvent(new AppEvents(AppEvents.XML_LOADED));
		}
		
		/**
		 * parseXML defines a set of arrays (held in AppData) that will go to inform
		 * the rest of the application 
		 * 
		 * once parsed, initate load of external swf libraries
		 * indepedantly, initialize data and activate the display
		 */
		public function parseXML():void
		{
			for (var i:int = 0; i < AppData.nonProfitXML.content.scene.length(); i++) 
			{
				AppData.navLocations.push	(String(AppData.nonProfitXML.content.scene[i].title));
				AppData.libraryRefs.push	(AppData.nonProfitXML.content.scene[i].library);
				AppData.libraryLoaded.push	(false);
			}
			this.dispatchEvent(new AppEvents(AppEvents.XML_PARSED));
		}
		
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//									runtime libraries
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++				
		
		/**
		 * called from appControl
		 * runs a sequence of loaders to import, digest and ready external assets (swf)
		 * array count simply runs through the available locations and finalizes when done
		 */
		public function loadExternalLibraries():void
		{
			if (AppData.libraryRefs.length > 0) 
			{
				_digestExternalLib.addEventListener(AppEvents.LIBRARY_LOADED, onLibraryLoad, false, 0, true);
				_digestExternalLib.digestLibrary(AppData.libraryRefs[0], false);
			} 
			else 
			{
				trace("external libraries successfully loaded");
				_digestExternalLib = null;
			}
		}
		
		/**
		 * after external swf has been loaded and digested, 
		 * push references to appData arrays for later use
		 * 
		 * call assembleContent in the targeted class (pageContent), 
		 * and instantiate each item, ready for display and animation
		 * 
		 * update cetral navigation with newly loaded panel graphics
		 * activate panel info in the target panel
		 * 
		 * @param	e
		 */
		private function onLibraryLoad(e:AppEvents):void 
		{
			_digestExternalLib.removeEventListener(AppEvents.LIBRARY_LOADED, onLibraryLoad);
			
			var currentIndex:int = AppData.navLocations.indexOf(e.arg[0], 0);
			
			AppData.libraries.push(e.arg[0]);
			AppData.libraryCon.push(e.arg[1]);
			AppData.libraryNames.push(e.arg[2]);
			AppData.libraryLoaded[currentIndex] = true;

			trace("DataLoader.library loaded(" + AppData.libraryCon[currentIndex] + ")");
			
			Main.appDisplay.pageContent.assembleContent(e.arg[0]);
			Main.appDisplay.navigation.updateMaterial(currentIndex);
			AppControl.onLibraryLoad(currentIndex);
			
			trace("+----------------------------------------------+");
			
			AppData.libraryRefs.splice(0, 1);
			loadExternalLibraries();
		}
		
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//									image loading
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++		
		
		private var _imgPath		:String;
		private var _queueImage		:LoaderMax;
		private var _imageLoader 	:ImageLoader
		private var _loadVars		:LoaderMaxVars;

		public function loadImage(imgPath:String):void
		{
			trace("DataLoader.loadImage("+imgPath+")");
			
			_imgPath = imgPath;
			
			_loadVars					= new LoaderMaxVars();
			_loadVars.name 				= "_queueImageLoad";
			_loadVars.onComplete 		= imageLoadComplete;
			_loadVars.onProgress 		= imageLoadProgress;
			_loadVars.onError			= imageLoadError;
			_loadVars.onChildFail 		= imageLoadError;
			_loadVars.onIOError			= imageLoadError;
			_loadVars.autoDispose		= true;
			_loadVars.auditSize			= false;
			_queueImage					= new LoaderMax(_loadVars);
			
			_imageLoader = new ImageLoader("../img/products/" + _imgPath, { name:_imgPath } );
			_queueImage.append( _imageLoader );
			
			try 
			{
				_queueImage.load();
			}
			catch (e:LoaderEvent)
			{
				imageLoadError(e);
			}
		}
		
		private function imageLoadError(e:LoaderEvent):void
		{ 
			trace("error occured with " + e.target + ": " + e.text);
			
			_queueImage.cancel();
			_queueImage.unload();
			this.dispatchEvent(new AppEvents(AppEvents.LOAD_ERROR, false, false));
		}
		private function imageLoadProgress(e:LoaderEvent):void
		{
			trace("progress: " + e.target.progress);
		}
		private function imageLoadComplete(e:LoaderEvent):void
		{
			var image:DisplayObject = _queueImage.getContent(_imgPath).rawContent;

			trace("DataLoader.imageLoadComplete(): " + image);
			//send image along to calling class (productContent)
			
			this.dispatchEvent(new AppEvents(AppEvents.IMAGE_LOADED, false, false, image));
		}
		
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//									END 
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++			
		
	}
}