package com.b99.composite 
{
	import adobe.utils.CustomActions;
	import com.b99.app.AppControl;
	import com.b99.app.AppData;
	import com.b99.app.Main;
	import com.b99.element.ComplexTextField;
	import com.b99.events.AppEvents;
	import com.greensock.easing.Sine;
	import flash.display.CapsStyle;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import com.greensock.*;
	import com.greensock.plugins.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author bosworth99
	 */
	public class PanelInfo extends Sprite
	{
		private var _tempIndex		:int;
		
		//++++++++++++++++++++++++++ containers
		private var _canvas			:Sprite;
		
		//++++++++++++++++++++++++++ displyobjects
		private var _line			:Sprite;
		private var _node			:Sprite;
		private var _click			:Sprite;
		private var _GFX_loader		:MovieClip;

		//++++++++++++++++++++++++++ int
		private var _panelCoords	:Array = new Array();
		private var _originX		:int;
		private var _originY		:int;
		private var _pnt1X			:int;
		private var _pnt1Y			:int;
		private var _pnt2X			:int;
		private var _pnt2Y			:int;
		
		//++++++++++++++++++++++++++ text
		private var _textCon		:Sprite;
		private var _text			:String;
		
		//++++++++++++++++++++++++++ split text
		private var _wordArray		:Array = new Array();
		private var _textFields		:Array = new Array();
		
		//++++++++++++++++++++++++++ misc
		private var _color			:uint;
		private var _currentLoc		:String;
		private var _contentLoaded	:Boolean;
		private var _infoExists		:Boolean;
		
		
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//							constructor
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++			

		public function PanelInfo() 
		{
			super();
			init();
		}
		
		private function init():void
		{
			//trace("panelInfo.init()")
			TweenPlugin.activate([BlurFilterPlugin]);
			assembleDisplayObjects();
			_infoExists = false;
		}

		public function activate():void
		{
			_infoExists = true;
			
			_tempIndex 			= AppData.navLocations.indexOf(AppData.newLocation);
			_currentLoc 		= AppData.newLocation;
			_contentLoaded		= AppData.libraryLoaded[_tempIndex];
			_color 				= AppData.nonProfitXML..scene.(@name == _currentLoc).color;
			_text				= AppData.nonProfitXML..scene.(@name == _currentLoc).text.navPanel;

			updateCoords();
			
			//assign coordinates
			_originX 		= _panelCoords[0] - 250;
			_originY 		= _panelCoords[1] + 170;
			_pnt1X 			= _originX + 50;
			_pnt1Y 			= _originY + 30;
			_pnt2X 			= _pnt1X;
			_pnt2Y 			= _pnt1Y + 60;
			
			
			this.addChild(_canvas);
			
			activateDisplayObjects();
			addUpdateHandlers();
		}
	
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//							display objects
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++			
		
		private function assembleDisplayObjects():void
		{
			_canvas 		= new Sprite();
			this.addChild(_canvas);
			
			_node 			= new Sprite();
			_canvas.addChild(_node);
			
			//line
			_line 			= new Sprite();
			_canvas.addChild(_line);
			
			//text container
			_textCon 		= new Sprite();
			_canvas.addChild(_textCon);
			
			_click 			= new Sprite();
			_canvas.addChild(_click);
		}
		
		private function activateDisplayObjects():void
		{
			//build node
			with (_node) 
			{
				graphics.clear();
				graphics.beginFill(_color);
				graphics.drawEllipse( -6, -6, 12, 12);
				graphics.endFill();
			}
			
			_click.x = _pnt2X + 500;
			_click.y = _pnt2Y + 10;
			with (_click) 
			{
				graphics.clear();
				
				graphics.beginFill(0x80FF00, 0);
				graphics.drawRect( -50, -50, 100, 100);
				graphics.endFill();
				
				graphics.beginFill(_color,1);
				graphics.drawRect( -10, -10, 20, 20);
				graphics.endFill();
				
				graphics.lineStyle(5, 0xFFFFFF,1,true,"normal",CapsStyle.SQUARE);
				graphics.moveTo( 0, -5);
				graphics.lineTo( 0,  5);
				graphics.moveTo(-5,  0);
				graphics.lineTo( 5,  0);
				buttonMode = true;
				mouseEnabled = true;
				alpha = 1;
			}
			
			animateIn();
		}
		
		private function animateIn():void
		{
			if (AppData.isFancy)
			{
				TweenLite.from(_node, 	.5, 	{ delay:0.5, alpha:0, blurFilter: { blurX:20, blurY:20, quality:2, remove:true }} );
				TweenLite.from(_line, 	.5, 	{ delay:0.8, alpha:0, blurFilter: { blurX:20, blurY:20, quality:2, remove:true }} );	
				TweenLite.from(_click, 	.5, 	{ delay:1.1, alpha:0, blurFilter: { blurX:20, blurY:20, quality:2, remove:true }} );
			}
			else
			{
				TweenLite.from(_node, 	.5, 	{ delay:0.5, alpha:0} );
				TweenLite.from(_line, 	.5, 	{ delay:0.8, alpha:0} );	
				TweenLite.from(_click, 	.5, 	{ delay:1.1, alpha:0} );
			}
			
			TweenLite.delayedCall(	.5, 	splitText);
			TweenLite.delayedCall(	1.0, 	animateInComplete);
		}
		
		private function animateInComplete():void
		{
			this.dispatchEvent(new AppEvents(AppEvents.INFO_ADDED));
		}
		
		/**
		 *  split the string "_text" into individual words, store in _wordArray
		 *  create new textField for each word 
		 *  place according to the previous words [y , x + textWidth + spacer]
		 *  contain to a specific width
		 *  animate into place 
		 */
		private function splitText():void
		{
			_wordArray 			= _text.split(" ");
			
			var countY		:int = 0;
			var spacerY		:int = 18;
			var wordSpacer	:int = 7;
			var oldXY		:Array = new Array(0, 0);
			
			for (var i:int = 0; i < _wordArray.length; i++) 
			{
				var word 	:ComplexTextField = new ComplexTextField(_wordArray[i]
																	,"verdana_title"
																	,_color
																	,12
																	,16
																	,20
																	,"none");
				with (word)
				{	
					x 					= oldXY[0];
					y 					= oldXY[1];
					if (word.x + (word.textWidth + wordSpacer)> 450) {
						word.x = 0;
						countY ++;
						word.y = countY * spacerY; 
					}
					oldXY[0] 			= word.x + (word.textWidth + wordSpacer);
					oldXY[1] 			= word.y;
					
					var ranX:int = word.x + (Math.random() * 20) - 10;
					var ranY:int = word.y + (Math.random() * 20) - 10;
					
					//define how words animate into place
					if (AppData.isFancy)
					{
						TweenLite.from(word, .7, { delay:(.4 * (countY / 2)) + (i * .05), alpha:0, x:ranX, y:ranY, blurFilter: { blurX:20, blurY:20, alpha:0, quality:1, remove:true }} );
					}
					else 
					{
						TweenLite.from(word, .7, { delay:(.4 * (countY / 2)) + (i * .05), alpha:0, x:ranX, y:ranY} );
					}
				}
				_textFields.push(word);
				//
				_textCon.addChild(word);
			}
			
			_wordArray.splice(0, _wordArray.length);
			oldXY.splice(0, oldXY.length);
			oldXY 		= null;
		}
		
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//							page update
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++	
	
		/**
		 * once display objects have been added into place, push them around, 
		 * based on location of the target panel in CentralNavigation
		 * 
		 * easing added for the users viewing pleasure
		 * 
		 * @param	e
		 */
		private function updateLocation(e:Event):void
		{
			updateCoords();
			
			_originX 	-= (_originX - (_panelCoords[0] - 270)) / 5;
			_originY 	-= (_originY - (_panelCoords[1] + 240)) / 5;
			_pnt1X 		-= 	(_pnt1X  - (_originX + 30)) / 12;
			_pnt1Y 		-= 	(_pnt1Y  - (_originY + 20)) / 12;	
			_pnt2X 		-= 	(_pnt2X  - _pnt1X);
			_pnt2Y 		-= 	(_pnt2Y  - (_pnt1Y + 60));
				
			_node.x 	= _originX;
			_node.y 	= _originY;
			
			_textCon.x 	= _pnt1X + 15;
			_textCon.y 	= _pnt1Y;
			
			_click.x 	= _pnt1X + 490;
			_click.y 	= _pnt1Y + 10;
			
			if (_GFX_loader) 
			{
				_GFX_loader.x = _click.x;
				_GFX_loader.y = _click.y;
			}
			
			redrawLine();
		}
		
		private	function redrawLine():void
		{
			with (_line) 
			{
				graphics.clear();
				graphics.lineStyle(1, _color);
				graphics.moveTo(_originX, _originY);
				graphics.lineTo(_pnt1X, _pnt1Y + 30);
				graphics.moveTo(_pnt2X, _pnt2Y);
				graphics.lineTo(_pnt1X, _pnt1Y);
			}
		}
		
		private function addLoaderGraphic():void
		{
			_GFX_loader = new GFX_loaderRing();
			with (_GFX_loader) 
			{
				x = _click.x;
				y = _click.y;
			}
			_canvas.addChild(_GFX_loader);
			
			TweenLite.from(_GFX_loader, .5, { delay:0.1, alpha:0, blurFilter: { blurX:20, blurY:20, quality:2, remove:true }} );
			
			_canvas.addEventListener(Event.ENTER_FRAME, addClickHandler, false, 0, true);
		}
		
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//							event interaction
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++			
		
		/**
		 * so this is the point in the app where a user may activate the page content
		 * so test if lib loaded is true - if so, add event handlers as normal
		 * if lib is not loaded add loader ring around the clicker and
		 * then check repeatedly if lib becomes loaded.
		 * when lib is finally loaded, remove loader graphic and then activate clicker
		 */
		public function addEventHandlers():void
		{
			if (!_contentLoaded) 
			{
				//addLoaderGraphic();
			}
			else 
			{
				_click.addEventListener(MouseEvent.MOUSE_OVER, 	click_over, false, 0, true);
				_click.addEventListener(MouseEvent.MOUSE_OUT, 	click_out, false, 0, true);
				_click.addEventListener(MouseEvent.CLICK, 		click_down, false, 0, true);
			}
		}
		
		private function addUpdateHandlers():void
		{
			_canvas.addEventListener(Event.ENTER_FRAME, updateLocation, false, 0, true);
		}
		
		private function addClickHandler(e:Event):void
		{
			_contentLoaded = AppData.libraryLoaded[_tempIndex];
			if (_contentLoaded) 
			{
				_canvas.removeEventListener(Event.ENTER_FRAME, addClickHandler);
				
				TweenLite.to(_GFX_loader, .3, { delay:.1, alpha:0, blurFilter: { blurX:20, blurY:20, quality:1, remove:true } } );
				
				_click.addEventListener(MouseEvent.MOUSE_OVER, 	click_over, false, 0, true);
				_click.addEventListener(MouseEvent.MOUSE_OUT, 	click_out,  false, 0, true);
				_click.addEventListener(MouseEvent.CLICK, 		click_down, false, 0, true);
			} 
		}
	
		private function click_out(e:MouseEvent):void 
		{
			e.target.scaleX = 1;
			e.target.scaleY = 1;
		}
		
		private function click_over(e:MouseEvent):void 
		{
			e.target.scaleX = 1.15;
			e.target.scaleY = 1.15;
		}
		
		private function click_down(e:MouseEvent):void 
		{
			e.target.scaleX = 1;
			e.target.scaleY = 1;
			AppControl.addPageContent();
		}

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//							destroy
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++	

		public function deactivate():void
		{
			_canvas.removeEventListener(Event.ENTER_FRAME, 		updateLocation);
				
			_click.removeEventListener(MouseEvent.MOUSE_OVER, 	click_over);
			_click.removeEventListener(MouseEvent.MOUSE_OUT, 	click_out);
			_click.removeEventListener(MouseEvent.CLICK, 		click_down);
				
			if (AppData.isFancy)
			{
				TweenLite.to(_canvas, .5 , { delay:0.1, alpha:0, onComplete:destroy, blurFilter: { blurX:20, blurY:20, quality:1, remove:true }} );
			}
			else
			{
				TweenLite.to(_canvas, .5 , { delay:0.1, alpha:0, onComplete:destroy} );
			}
		}

		private function destroy():void
		{
			_line.graphics.clear();
			
			_node.graphics.clear();

			_click.graphics.clear();
			
			if (_GFX_loader) 
			{
				_canvas.removeChild(_GFX_loader);
				_GFX_loader = null;
			}
			_panelCoords.splice(0, _panelCoords.length);
			
			for (var i:int = 0; i < _textFields.length; i++) 
			{
				ComplexTextField(_textFields[i]).destroy();
				_textFields[i] = null;
			}
			
			_textFields.splice(0, _textFields.length);
			
			this.removeChild(_canvas);
			
			_canvas.alpha	= 1;

			panelInfoRemoved();
		}
		
		private function panelInfoRemoved():void
		{
			_infoExists = false;
			this.dispatchEvent(new AppEvents(AppEvents.INFO_REMOVED));
		}
		
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//							utils
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++			

		private function updateCoords():void
		{
			_panelCoords[0] = Main.appDisplay.navigation.tempCoords[0];
			_panelCoords[1] = Main.appDisplay.navigation.tempCoords[1];
		}
		
		public function get infoExists():Boolean { return _infoExists; }

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//							end
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++			
		
	}

}