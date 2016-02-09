package com.b99.composite 
{
	import adobe.utils.CustomActions;
	import com.b99.app.AppControl;
	import com.b99.app.AppData;
	import com.b99.app.Main;
	import com.b99.element.ComplexTextField;
	import com.b99.events.AppEvents;
	import com.greensock.easing.Sine;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
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
		private var _click			:PanelInfoButton;

		//++++++++++++++++++++++++++ int
		private var _panelCoords	:Array = [AppData.stageW - 200, AppData.stageH - 200 ];
		private var _originX		:Number;
		private var _originY		:Number;
		private var _pnt1X			:Number;
		private var _pnt1Y			:Number;
		private var _pnt2X			:Number;
		private var _pnt2Y			:Number;
		
		//++++++++++++++++++++++++++ text
		private var _textCon		:Sprite;
		private var _text			:String;
		private var _isSwapped 		:Boolean = false;
		
		//++++++++++++++++++++++++++ split text
		private var _wordArray		:Array = new Array();
		private var _textFields		:Array = new Array();
		
		//++++++++++++++++++++++++++ misc
		private var _color			:uint;
		private var _currentLoc		:String;
		
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
			_tempIndex 			= AppData.navLocations.indexOf(AppData.newLocation);
			_currentLoc 		= AppData.newLocation;
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
			
			TweenPlugin.activate([BlurFilterPlugin]);
			
			assembleDisplayObjects();
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
			
			_click 			= new PanelInfoButton(_color);
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
			
			with (_click) 
			{
				x 	= _pnt2X + 460;
				y 	= _pnt2Y + 14;
			}
			
			animateIn();
		}
		
		private function animateIn():void
		{
			if (AppData.isFancy)
			{
				TweenLite.from(_node, 	.5, 	{ delay:0.5, alpha:0, blurFilter: { blurX:20, blurY:20, quality:2, remove:true }} );
				TweenLite.from(_line, 	.5, 	{ delay:0.8, alpha:0, blurFilter: { blurX:20, blurY:20, quality:2, remove:true }} );	
				TweenLite.from(_click, 	.5, 	{ delay:1, 	 alpha:0, blurFilter: { blurX:20, blurY:20, quality:2, remove:true }, onComplete:addEventHandlers } );
			}
			else
			{
				TweenLite.from(_node, 	.5, 	{ delay:0.5, alpha:0} );
				TweenLite.from(_line, 	.5, 	{ delay:0.8, alpha:0} );	
				TweenLite.from(_click, 	.5, 	{ delay:1, alpha:0, onComplete:addEventHandlers} );
			}
			
			TweenLite.delayedCall(	.5, 	splitText);
		}
		
		private function animateInComplete():void
		{
			addEventHandlers();
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
			_wordArray 		= _text.split(" ");
			
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
					
					//+++++++++++++++++ random position
					//var ranX:int = word.x + (Math.random() * 20) - 10;
					//var ranY:int = word.y + (Math.random() * 20) - 10;
					
					//+++++++++++++++++ in from left
					var ranX:Number = word.x - 30;
					var ranY:Number = word.y;
					
					//+++++++++++++++++ down from top
					//var ranX:int = word.x;
					//var ranY:int = word.y - 30;
					

					if (i != _wordArray.length - 1)
					{
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
					else
					{
						if (AppData.isFancy)
						{
							TweenLite.from(word, .7, { delay:(.4 * (countY / 2)) + (i * .05), alpha:0, x:ranX, y:ranY, blurFilter: { blurX:20, blurY:20, alpha:0, quality:1, remove:true }, onComplete:swapBitmapForText} );
						}
						else 
						{
							TweenLite.from(word, .7, { delay:(.4 * (countY / 2)) + (i * .05), alpha:0, x:ranX, y:ranY, onComplete:swapBitmapForText });
						}
					}
				}
				
				_textFields.push(word);
				_textCon.addChild(word);
			}
			
			_wordArray.splice(0, _wordArray.length);
			oldXY.splice(0, oldXY.length);
			oldXY 		= null;
		}
		
		private function swapBitmapForText():void
		{
			//draw the contents of _textCon
			var data:BitmapData = new BitmapData(475, 70, true, 0x00000000);
			data.draw(_textCon);
			
			var bitmap:Bitmap = new Bitmap(data, "auto", true);
			bitmap.smoothing = true;
			
			//remove all text objects from _textCom
			killText();
			
			_textCon.addChild(bitmap);
			
			_isSwapped = true;
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
			var dtime :Number = AppData.deltaTime;
			
			updateCoords();
			
			_originX 	-= (_originX - (_panelCoords[0] - 270)) * (dtime * 10);
			_originY 	-= (_originY - (_panelCoords[1] + 240)) * (dtime * 10);
			_pnt1X 		-= 	(_pnt1X  - (_originX + 30)) * (dtime * 1.2);
			_pnt1Y 		-= 	(_pnt1Y  - (_originY + 20)) * (dtime * 1.2);	
			_pnt2X 		-= 	(_pnt2X  - _pnt1X);
			_pnt2Y 		-= 	(_pnt2Y  - (_pnt1Y + 60));
				
			_node.x 	= _originX;
			_node.y 	= _originY;
			
			_textCon.x 	= _pnt1X + 15;
			_textCon.y 	= _pnt1Y;
			
			_click.x 	-= (_click.x - (_pnt1X + 475)) * dtime;
			_click.y 	-= (_click.y - (_pnt1Y + 14)) * dtime;
			
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
		
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//							event interaction
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++			
		

		public function addEventHandlers():void
		{
			_click.addEventListener(MouseEvent.CLICK, 		click_down, false, 0, true);
		}
		
		private function addUpdateHandlers():void
		{
			_canvas.addEventListener(Event.ENTER_FRAME, updateLocation, false, 0, true);
		}
		
		private function click_down(e:MouseEvent):void 
		{
			AppControl.addPageContent();
		}

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//							destroy
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++	

		public function deactivate():void
		{
			_canvas.removeEventListener(Event.ENTER_FRAME, 		updateLocation);
				
			_click.removeEventListener(MouseEvent.CLICK, 		click_down);
				
			if (AppData.isFancy)
			{
				TweenLite.to(_canvas, .3 , { delay:0.1, alpha:0, onComplete:destroy, blurFilter: { blurX:20, blurY:20, quality:1, remove:true }} );
			}
			else
			{
				TweenLite.to(_canvas, .3 , { delay:0.1, alpha:0, onComplete:destroy} );
			}
		}

		private function killText():void
		{
			for (var i:int = 0; i < _textFields.length; i++) 
			{
				TweenLite.killTweensOf(_textFields[i]);
				ComplexTextField(_textFields[i]).destroy();
				_textFields[i] = null;
			}
		}
		
		public function destroy():void
		{
			TweenLite.killDelayedCallsTo(splitText);
			TweenLite.killTweensOf(_line);
			TweenLite.killTweensOf(_node);
			TweenLite.killTweensOf(_click);
			TweenLite.killTweensOf(_canvas);
			
			_line.graphics.clear();
			_canvas.removeChild(_line);
			_line 			= null;
			
			_node.graphics.clear();
			_canvas.removeChild(_node);
			_node 			= null;
			
			_click.destroy();
			_click			= null;

			if (!_isSwapped) 
			{
				killText();
			}
			else
			{
				if ( typeof _textCon.getChildAt(0) == "Bitmap")
				{
					Bitmap(_textCon.getChildAt(0)).bitmapData.dispose();
				}
				else 
				{
					while (_textCon.numChildren > 0)
					{
						_textCon.removeChildAt(0);
					}
				}
			}
			
			_canvas.removeChild(_textCon)
			_textCon 		= null;
			
			_canvas.filters = [];
			this.removeChild(_canvas);
			_canvas = null;
			
			_panelCoords = null;
			_textFields = null;
			
			this.parent.removeChild(this);
			
			this.dispatchEvent(new AppEvents(AppEvents.INFO_REMOVED));
		}
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//							utils
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++			

		private function updateCoords():void
		{
			if(Main.appDisplay.navigation.tempCoords[0]) 
			{
				_panelCoords[0] = Main.appDisplay.navigation.tempCoords[0];
				_panelCoords[1] = Main.appDisplay.navigation.tempCoords[1];
			}
		}

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//							end
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++			
		
	}
}