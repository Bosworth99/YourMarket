///////////////////////////////////////////////////////////////////////////////
//
//	com>b99>display>UserInterface.as
//
//	extends : sprite
//
//	holds layers of user interface objects and related handlers
//	object / layer groups are unrelated, and called up at different times
// 	for different purposes. 
//
//
///////////////////////////////////////////////////////////////////////////////

package com.b99.display 
{
	import com.b99.app.*;
	import com.b99.composite.BasicButton;
	import com.b99.composite.PanelInfo;
	import com.b99.composite.QualityPanel;
	import com.b99.events.AppEvents;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author bosworth99
	 */
	public class UserInterface extends Sprite
	{	
		//+++++++++++++++++++ navigation
		private var _navCanvas		:Sprite;
		private var _buttonPlus		:Sprite;
		private var _buttonMinus	:Sprite;
		private var _qualityPanel	:QualityPanel;
		
		private var _panelCanvas	:Sprite;
		private var _panelInfo		:PanelInfo;

		private var _infoExists		:Boolean = false;
		
		private const DIST			:uint = 20;
		

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//									constructor
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++	

		public function UserInterface() 
		{
			super();
			init();
		}
		
		private function init():void
		{
			_navCanvas = new Sprite();
			this.addChild(_navCanvas)
			
			_panelCanvas = new Sprite();
			this.addChild(_panelCanvas);	
		}
		
		
		
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//									Nav display Objects
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++				

	//+++++++++++++++++++++++ navigation display objects
		public function assembleNavObjects():void
		{
			_buttonMinus = new GFX_SideBar_Minus();
			with (_buttonMinus) 
			{
				x 			= DIST;
				y			= AppData.stageH / 2;
				alpha		= .7;
				name 		= "minus";
				buttonMode 	= true;
			}
			_navCanvas.addChild(_buttonMinus);
			
			_buttonPlus = new GFX_SideBar_Plus();
			with (_buttonPlus) 
			{
				x 			= AppData.stageW - DIST;
				y			= AppData.stageH / 2;
				alpha		= .7;
				name 		= "plus";
				buttonMode 	= true;
			}
			_navCanvas.addChild(_buttonPlus);
			
			_qualityPanel = new QualityPanel();
			with (_qualityPanel) 
			{
				x			= -18;
				y			= AppData.stageH;
			}
			_navCanvas.addChild(_qualityPanel);
		}

	//+++++++++++++++++++++++ navigation event handlers
		
		public function activateNavEvents():void
		{
			_buttonMinus.addEventListener	(MouseEvent.MOUSE_DOWN, sideDown, 	false, 0, true);
			_buttonMinus.addEventListener	(MouseEvent.MOUSE_OVER, sideOver, 	false, 0, true);
			_buttonMinus.addEventListener	(MouseEvent.MOUSE_OUT,  sideOut, 	false, 0, true);
			
			_buttonPlus.addEventListener	(MouseEvent.MOUSE_DOWN, sideDown, 	false, 0, true);
			_buttonPlus.addEventListener	(MouseEvent.MOUSE_OVER, sideOver, 	false, 0, true);
			_buttonPlus.addEventListener	(MouseEvent.MOUSE_OUT,  sideOut, 	false, 0, true);
			
			_qualityPanel.addEventListener	(MouseEvent.MOUSE_OVER, qualityOver,false, 0, true);
			_qualityPanel.addEventListener	(MouseEvent.MOUSE_OUT, 	qualityOut, false, 0, true);
			
			TweenLite.to(_navCanvas, 	.3, { alpha:1 });
			
			Main.mainStage.addEventListener(MouseEvent.MOUSE_WHEEL, navWheel, false, 0, true);
			
			
			var currentLoc:Point = localToGlobal(new Point(mouseX, mouseY)) as Point;
			
			//if mouse is over a button at the end of a transition, trigger mouse over
			if (_buttonPlus.hitTestPoint(currentLoc.x, currentLoc.y, true)) 
			{
				_buttonPlus.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OVER));
			} 
			else if (_buttonMinus.hitTestPoint(currentLoc.x, currentLoc.y, true))
			{
				_buttonMinus.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OVER));
			}
		}
		
		public function deactivateNavEvents():void
		{
			_buttonMinus.removeEventListener	(MouseEvent.MOUSE_DOWN, sideDown);
			_buttonMinus.removeEventListener	(MouseEvent.MOUSE_OVER, sideOver);
			_buttonMinus.removeEventListener	(MouseEvent.MOUSE_OUT, 	sideOut);
			
			_buttonPlus.removeEventListener		(MouseEvent.MOUSE_DOWN, sideDown);
			_buttonPlus.removeEventListener		(MouseEvent.MOUSE_OVER, sideOver);
			_buttonPlus.removeEventListener		(MouseEvent.MOUSE_OUT, 	sideOut);
			
			_qualityPanel.removeEventListener	(MouseEvent.MOUSE_OVER, qualityOver);
			_qualityPanel.removeEventListener	(MouseEvent.MOUSE_OUT, 	qualityOut);
		
			TweenLite.to(_navCanvas, 	.3, { alpha:.2 });
			
			Main.mainStage.removeEventListener(MouseEvent.MOUSE_WHEEL, navWheel);
		}
		
		private function sideOver(e:MouseEvent):void 
		{
			switch (e.target.name)
			{
				case "plus":
				{
					TweenLite.to(_buttonPlus, .2, { x: AppData.stageW - 40, alpha:1 } );
					break;
				}
				case "minus":
				{
					TweenLite.to(_buttonMinus, .2, { x: 40, alpha:1 } );
					break;
				}
			}
		}
		
		private function sideOut(e:MouseEvent):void 
		{
			switch (e.target.name)
			{
				case "plus":
				{
					TweenLite.to(_buttonPlus, .2, {x: AppData.stageW - DIST, alpha:.7});
					break;
				}
				case "minus":
				{
					TweenLite.to(_buttonMinus, .2, {x: DIST, alpha:.7 } );
					break;
				}
			}
		}
		
		private function sideDown(e:MouseEvent):void 
		{
			AppControl.readyStateChange(e.target.name);
			
			//reset buttons
			TweenLite.to(_buttonMinus, .3, {x: DIST, alpha:.7 } );
			TweenLite.to(_buttonPlus, .3, {x: AppData.stageW - DIST, alpha:.7 });
		}
		
		private function navWheel(e:MouseEvent):void 
		{
			if (e.delta >= 3)
			{
				AppControl.readyStateChange("plus");
			} 
			else if (e.delta <= -3) 
			{
				AppControl.readyStateChange("minus");
			}
		}
		
		private function qualityOver(e:MouseEvent):void 
		{
			TweenLite.to(_qualityPanel, .5, {delay:.1, y:AppData.stageH - 45 } );
		}
		
		private function qualityOut(e:MouseEvent):void 
		{
			TweenLite.to(_qualityPanel, .5, {delay:.1, y:AppData.stageH } );
		}
		
		public function deactivateNavButtons():void
		{
			TweenLite.to(_buttonMinus,	.5, { x: -100 } );
			TweenLite.to(_buttonPlus, 	.5, { x: AppData.stageW + 100 } );
			TweenLite.to(_qualityPanel, .5, { y: AppData.stageH + 20} );
			
			deactivateNavEvents();
		}
		
		public function activateNavButtons():void
		{
			TweenLite.to(_buttonMinus,	.5, { x: DIST } );
			TweenLite.to(_buttonPlus, 	.5, { x: AppData.stageW - DIST } );
			TweenLite.to(_qualityPanel, .5, { y: AppData.stageH } );
			
			activateNavEvents();
		}
			
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//									panel info composite
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++	

		public function addPanelInfo():void
		{
			_infoExists = true;
			
			if (_panelInfo) 
			{
				_panelInfo.destroy();
				_panelInfo = null;
			}
			_panelInfo = new PanelInfo();
			_panelCanvas.addChild(_panelInfo);
		}
	
		public function removePanelInfo():void 
		{
			if (_panelInfo) 
			{
				_panelInfo.addEventListener(AppEvents.INFO_REMOVED, panelInfoRemoved, false, 0, true);
				_panelInfo.deactivate();
			}
		}
		
		private function panelInfoRemoved(e:AppEvents):void
		{
			_panelInfo.removeEventListener(AppEvents.INFO_REMOVED, panelInfoRemoved);
			_panelInfo = null;
			
			_infoExists = false;
		}
		
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//									get n set
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++	
		
		public function get infoExists():Boolean { return _infoExists; }

	}
}