///////////////////////////////////////////////////////////////////////////////
//
//	com>b99>display>CentralNavigation.as
//
//	extends : sprite
//
//	primary navigation system 
//	papervision based
//
///////////////////////////////////////////////////////////////////////////////

package com.b99.display 
{
	import com.b99.app.AppData;
	import com.b99.app.Main;
	import com.b99.events.AppEvents;
	import com.greensock.*;
	import com.greensock.data.ColorMatrixFilterVars;
	import com.greensock.data.TweenLiteVars;
	import com.greensock.easing.Quint;
	import com.greensock.plugins.*;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import org.papervision3d.cameras.Camera3D;
	import org.papervision3d.core.math.Matrix3D;
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.materials.BitmapAssetMaterial;
	import org.papervision3d.materials.BitmapFileMaterial;
	import org.papervision3d.materials.ColorMaterial;
	import org.papervision3d.materials.MovieMaterial;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.Cube;
	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.render.BasicRenderEngine;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.view.layer.util.ViewportLayerSortMode;
	import org.papervision3d.view.layer.ViewportLayer;
	import org.papervision3d.view.Viewport3D;
	
	/**
	 * ...
	 * @author bosworth99
	 */
	public class CentralNavigation extends Sprite
	{
		
		//++++++++++++++++++++++++++++++ 3D Essentials
		private var _viewport			:Viewport3D;
		private var _scene				:Scene3D;
		private var _camera				:Camera3D;
		private var _renderEngine		:BasicRenderEngine;	
		
		//++++++++++++++++++++++++++ materials
		private var _sky_list			:MaterialsList;
		private var _mat_wall			:BitmapAssetMaterial;
		
		//++++++++++++++++++++++++++ displayOjbecst
		private var _block				:DisplayObject3D;
		private var _tempPanel			:DisplayObject3D;
		private var _tempTitle			:DisplayObject3D;
		
		private var _skyBox				:Cube;
		
		//++++++++++++++++++++++++++ viewportlayers
		private var _vpl_container		:ViewportLayer;
		private var _vpl_background		:ViewportLayer;
		private var _vpl_midground		:ViewportLayer;
		private var _vpl_foreground		:ViewportLayer;
		private var _vpl_content		:ViewportLayer;
		
		//++++++++++++++++++++++++++ numerics
		private var _targetIndex		:int;
		private const TESS				:uint = 2;
		
		//++++++++++++++++++++++++++ arrays
		private var _panels				:Array = new Array();
		private var _titles				:Array = new Array();
		private var _particles			:Array = new Array();

		//++++++++++++++++++++++++++ booleans
		private var _returnToBase		:Boolean;
		private var _navAssembled		:Boolean = false;
		
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//									constructor
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

		public function CentralNavigation() 
		{
			super();
			init();
		}
	
		private function init():void
		{
			trace("CentralNavigation.init()");
		}
		
		public function assembleNavigation():void
		{
			assemble3Dscene();
			assembleSceneObjects();
			assembleDisplayObjects();
			initPlugins();
		}
		
		private function navigationAssembled():void
		{
			this.dispatchEvent(new AppEvents(AppEvents.APP_READY));
			_navAssembled = true;
		}

		public function entryPoint():void
		{
			addEventHandlers();
		}
	
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//									display objects
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++		
		private function assemble3Dscene():void
		{
			_scene 			= new Scene3D();
			_camera 		= new Camera3D(50,10,10000,true,true)
			with (_camera) 
			{
				zoom		= 60;
				x 			= 0;
				y 			= -1000;
				z 			= -1000;
				rotationX 	= 5;
			}
			_renderEngine 	= new BasicRenderEngine();
		}
		
		private function assembleSceneObjects():void
		{
			_viewport = new Viewport3D(AppData.stageW, AppData.stageH, false);
			_viewport.containerSprite.sortMode = ViewportLayerSortMode.INDEX_SORT;
			_viewport.interactive = false;
			addChild(_viewport);
			
			//_main container layer
			_vpl_container 					= new ViewportLayer(_viewport, null);
			_viewport.containerSprite.addLayer(_vpl_container);
			_vpl_container.sortMode 		= ViewportLayerSortMode.INDEX_SORT;
			_vpl_container.layerIndex 		= 0;
			
			_vpl_background 				= new ViewportLayer(_viewport, null);
			_vpl_container.addLayer(_vpl_background);
			_vpl_background.sortMode 		= ViewportLayerSortMode.INDEX_SORT;
			_vpl_background.layerIndex 		= 1;
			
			_vpl_midground					= new ViewportLayer(_viewport, null);
			_vpl_container.addLayer(_vpl_midground);
			_vpl_midground.sortMode			= ViewportLayerSortMode.Z_SORT;
			_vpl_midground.layerIndex		= 2;
			
			_vpl_foreground					= new ViewportLayer(_viewport, null);
			_vpl_container.addLayer(_vpl_foreground);
			_vpl_foreground.sortMode		= ViewportLayerSortMode.Z_SORT;
			_vpl_foreground.layerIndex		= 3;
			
			_vpl_content					= new ViewportLayer(_viewport, null);
			_vpl_container.addLayer(_vpl_content);
			_vpl_content.sortMode			= ViewportLayerSortMode.INDEX_SORT;
			_vpl_content.layerIndex			= 4;
		}
		
		private function assembleDisplayObjects():void
		{
			//++++++++++canvas
			_block = new DisplayObject3D("block");
			_scene.addChild(_block);	
			
			//+++++++++++skybox
			_mat_wall 						= new BitmapAssetMaterial("White_Wall");
			_sky_list						= new MaterialsList();
			_sky_list.addMaterial(_mat_wall, 	"left");
			_sky_list.addMaterial(_mat_wall,	"right");
			_sky_list.addMaterial(_mat_wall, 	"back");
			_sky_list.addMaterial(_mat_wall, 	"top");
			_sky_list.addMaterial(_mat_wall, 	"bottom");
			_sky_list.addMaterial(_mat_wall, 	"front");
			
			_skyBox 			= new Cube(_sky_list, 10000, 7500, 7500, 10, 10, 10, Cube.ALL);
			with (_skyBox) 
			{
				x 				= 1500;
				y 				= 2500;
				z 				= 2500;
				useOwnContainer = true;
				name 			= "skyBox";
			}
			_block.addChild(_skyBox);
			_vpl_background.getChildLayer(_skyBox, true).layerIndex = 1;
			
			//+++++++++++panels
			for (var i:int = 0; i < AppData.navLocations.length; i++) 
			{
				constructPanel(AppData.libraryLoaded[i],i);
			}
			navigationAssembled();
		}
		
		/**
		 * for each element in AppData.navLocations, create an element containing two planes 
		 * additionally, create a title graphic based on the same info
		 * 
		 * if the external library is loaded for the targeted nav location, create mats, else, create
		 * loader graphics
		 * 
		 * @param	isLoaded:boolean = AppData.libraryLoaded[?]; test whether external library has been loaded
		 * @param	i:int = target index	
		 */
		private function constructPanel(isLoaded:Boolean, i:int):void
		{
			//mat_Fore	= new BitmapFileMaterial(("../img/nav/Mat_" + 	AppData.navLocations[i] + ".png"), 		true);
			//mat_Back	= new BitmapFileMaterial(("../img/nav/Mat_" + 	AppData.navLocations[i]	+ "_Back.png"), true);
			
			//+++++++++++++++++ materials
			var mat_Fore:*;
			var mat_Back:*;
			var title_mat:BitmapAssetMaterial = new BitmapAssetMaterial(("Title_"+AppData.navLocations[i]), true);
			
			if (isLoaded) 
			{
				mat_Fore	= new BitmapAssetMaterial(("Mat_" + AppData.navLocations[i]), true);
				mat_Back	= new BitmapAssetMaterial(("Mat_" + AppData.navLocations[i] + "_Back"), true);
			} 
			else
			{
				mat_Fore 	= new MovieMaterial(new GFX_LoadPanel() as MovieClip, true, true);
				mat_Back	= new BitmapAssetMaterial("Mat_Loader_Back", true);
			}
			
			with (mat_Fore) {	interactive	= false;	doubleSided = false;	smooth	= true;	}
			with (mat_Back) {	interactive	= false;	doubleSided = false;	smooth 	= true;	}
			with (title_mat){	interactive	= false;	doubleSided = false;	smooth 	= true;	}
			
			//+++++++++++++++++ geometry
			var panel:DisplayObject3D = new DisplayObject3D();
			with (panel) 
			{
				x 				= i * 450;
				y 				= 150;
				z 				= i * 500;
				useOwnContainer = true;
			}
			_block.addChild(panel);
			_vpl_foreground.getChildLayer(panel, true).layerIndex = i*10;
			
			var num3D:Number3D = new Number3D(panel.x, panel.y, panel.z);
			_panels.push([ panel , num3D ] );
			
			var plane_fore:Plane = new Plane( mat_Fore, 600, 420, TESS, TESS);
			with (plane_fore) 
			{
				x 				= 0;
				y 				= 0;
				z 				= -150;
				name			= "plane_fore";
				useOwnContainer = true;
			}
			panel.addChild(plane_fore);

			var plane_Back:Plane = new Plane( mat_Back, 600, 420, TESS, TESS);
			with (plane_Back) 
			{
				x 				= 0;
				y 				= 20;
				z 				= 50;
				scale 			= 1.2;
				name			= "plane_back";
				useOwnContainer = true;
			}
			panel.addChild(plane_Back);
			
			var title_plane:Plane = new Plane( title_mat, 500, 80, TESS, TESS);
			with (title_plane) 
			{
				x 				= _panels[i][1].x + 1000;
				y 				= _panels[i][1].y - 200;
				z 				= _panels[i][1].z - 300;
				useOwnContainer = true;
			}
			
			_block.addChild(title_plane);
			_vpl_foreground.getChildLayer(title_plane, true).layerIndex = i*11;
			
			var num3D_title:Number3D = new Number3D(title_plane.x, title_plane.y, title_plane.z);
			_titles.push([ title_plane , num3D_title ]);
			
			title_plane.container.alpha = 0;
		}

		public function updateMaterial(index:int):void
		{
			if (_navAssembled) 
			{
				TweenLite.to(_panels[index][0].container, .2, { alpha:0, onComplete:switchMat, onCompleteParams:[index] } );
			}
		}
		private function switchMat(index:int):void
		{
			var mat_Fore:BitmapAssetMaterial = new BitmapAssetMaterial(("Mat_" + AppData.navLocations[index]), true);
			var mat_Back:BitmapAssetMaterial = new BitmapAssetMaterial(("Mat_" + AppData.navLocations[index] + "_Back"), true);
			with (mat_Fore) {	interactive	= false;	doubleSided = false;	smooth	= true;	}
			with (mat_Back) {	interactive	= false;	doubleSided = false;	smooth 	= true;	}
			
			_panels[index][0].setChildMaterialByName("plane_fore", mat_Fore);
			_panels[index][0].setChildMaterialByName("plane_back", mat_Back);
			
			TweenLite.to(_panels[index][0].container, .2, { alpha:1 } );
		}
		
		private function initPlugins():void
		{
			TweenPlugin.activate([BlurFilterPlugin, GlowFilterPlugin]);
			OverwriteManager.init(OverwriteManager.AUTO);
		}
		
		
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//									state change
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++		
		
		//contact point from appControl
		public function activatePanelTransition(targetIndex):void
		{
			_targetIndex 	= targetIndex;
			_tempPanel  	= _panels[_targetIndex][0];
			_tempTitle		= _titles[_targetIndex][0];
			
			removeCameraUpdateHandler();
			relocateCamera();
		}
		
		private function panelTransitionComplete():void 
		{
			addCameraUpdateHandler();
			this.dispatchEvent(new AppEvents(AppEvents.CHANGE_COMPLETE, false, false));
		}
		
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//									event handlers
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++		
		
		private function addEventHandlers():void
		{
			addCameraUpdateHandler();
			addRenderHandlers();
		}
		
		private function addCameraUpdateHandler():void
		{
			this.addEventListener(Event.ENTER_FRAME, updateCameraPosition, false, 0, true);
		}
		private function removeCameraUpdateHandler():void
		{
			this.removeEventListener(Event.ENTER_FRAME, updateCameraPosition);
		}

		private function addObjectUpdateHandler():void
		{
			this.addEventListener(Event.ENTER_FRAME, updateObjectPosition, false, 0, true);
		}
		
		private function removeObjectUpdateHandler():void
		{
			this.removeEventListener(Event.ENTER_FRAME, updateObjectPosition);
		}
		
		private function addRenderHandlers():void
		{
			this.addEventListener(Event.ENTER_FRAME, renderLoop, false, 0 , true);
		}

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//									camera position
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++	

		private function relocateCamera():void
		{
			var transitionLoc:int;
			if (_returnToBase) 
			{
				transitionLoc = _tempPanel.x;
			}
			else
			{
				transitionLoc = _tempPanel.x + 350;
			}

			TweenLite.to(_camera, 1.2, { 	x			: transitionLoc, y:75, 
											z			: _tempPanel.z - 1000, 
											rotationY	:0, 
											rotationX	:0, 
											onComplete	:panelTransitionComplete, 
											ease		:Quint.easeOut } 
											);
				
			for (var i:int = 0; i < _panels.length; i++) 
			{
				var pVars:TweenLiteVars = new TweenLiteVars();
				var tVars:TweenLiteVars = new TweenLiteVars();
				
				// modify scale and position of target panel
				if (_panels[i][0] == _tempPanel) 
				{
					//+++++++++++++++++++++++++++++++ panels
					pVars.addProp("x", 			_panels[i][1].x + 350, 	false);
					pVars.addProp("y", 			125, 					false);
					pVars.addProp("rotationY",	0, 						false);
					pVars.addProp("rotationX", 	0,						false);
					pVars.addProp("scale", 		1.3, 					false);
					pVars.ease = Quint.easeOut;
						
					if (_returnToBase) 
					{
						TweenLite.to(_panels[i][0], 1.2, pVars );
					}
					else 
					{
						pVars.delay	= .1;
						
						TweenLite.to(_panels[i][0], 1.1, pVars );
						
						if (AppData.isFancy)
						{
							TweenLite.to(_panels[i][0].container, .7, { delay:.5, 	blurFilter: { blurX:0, blurY:0, quality:2, remove:true }, 
																	glowFilter: { color:0xFFFFFF, blurX:50, blurY:50, alpha:1, remove:false }} );
						}
					}

					//+++++++++++++++++++++++++++++++ titles												
					tVars.addProp("x", 			_panels[i][1].x + 500, 	false);
					tVars.addProp("rotationY",	0, 						false);
					tVars.addProp("rotationX", 	0,						false);
					
					tVars.delay	= .5;
					tVars.ease = Quint.easeOut;	
						
					TweenLite.to(_titles[i][0], 1.5, tVars );
					TweenLite.to(_titles[i][0].container, 1, { delay:.5, alpha:1 } );
				}
				else 
				{	
					// if the target panel is out of place (it has been modified, put it back in place
					if (_panels[i].x != _panels[i][1].x) 
					{
						//+++++++++++++++++++++++++++++++ panels	
						pVars.addProp("x", 			_panels[i][1].x, 		false);
						pVars.addProp("y", 			_panels[i][1].y, 		false);
						pVars.addProp("scale", 		1, 						false);
							
						TweenLite.to(_panels[i][0], .4, pVars );
						
						
						//+++++++++++++++++++++++++++++++ titles
						tVars.addProp("x", 			_titles[i][1].x, 		false);
						
						tVars.delay	= .1;
						tVars.ease = Quint.easeOut;
						
						TweenLite.to(_titles[i][0], .7 , tVars );
						TweenLite.to(_titles[i][0].container, .1, { alpha:0 } );
					}
					
					// if app isFancy, change filter setting for each panel
					if (AppData.isFancy)
					{
						var blur:Number = Math.round(distanceTo(_panels[i][0], _tempPanel) / 250);
						if (blur < 5) 
						{
							blur = 5;
						}

						TweenLite.to(_panels[i][0].container, .4, { delay:.5, 	blurFilter: { blurX:blur, blurY:blur, quality:2, remove:false }, 
																			glowFilter: { color:0xFFFFFF, blurX:0, blurY:0, alpha:0, remove:true }} );
					}	
				}
			}	
			_returnToBase = false;
		}
			
		private var _tempObjRotY	:Number;
		private var _tempTitleX		:int;
		private var _tempTitleY		:int;
		/**
		 * @param	e
		 */
		public function activatePageContent():void
		{
			removeCameraUpdateHandler();
			addObjectUpdateHandler();
			
			var tempCamX		:int;
			var tempCamY		:int;
			var tempCamZ		:int;

			switch (Main.appDisplay.pageContent.camDirection()) 
			{
				case "left":
					tempCamX 		= _tempPanel.x + 260;
					tempCamY		= 2400;
					tempCamZ		= _tempPanel.z - 1000;
					
					_tempTitleX 	= _tempPanel.x + 100;
					_tempTitleY		= 2690;
					_tempObjRotY	= 15;
					break;
					
				case "right":
					tempCamX 		= _tempPanel.x - 260;
					tempCamY		= 2400;
					tempCamZ		= _tempPanel.z - 1000;
					
					_tempTitleX 	= _tempPanel.x - 200;
					_tempTitleY		= 2690;
					_tempObjRotY	= -15;
					break;
					
				case "centerLeft":
					tempCamX 		= _tempPanel.x + 200;
					tempCamY		= 2530;
					tempCamZ		= _tempPanel.z - 800;
					
					_tempTitleX 	= _tempPanel.x + 125;
					_tempTitleY		= 2700;
					_tempObjRotY	= 15;
					break;	
					
				case "centerRight":
					tempCamX 		= _tempPanel.x - 200;
					tempCamY		= 2530;
					tempCamZ		= _tempPanel.z - 800;

					_tempTitleX 	= _tempPanel.x - 100;
					_tempTitleY		= 2720;
					_tempObjRotY	= -15;
					break;
			}
			
			TweenLite.to(_skyBox.container, 		1,  { alpha:.7 } );
			
			TweenLite.to(_tempTitle.container, 		.2, { alpha:0, onComplete:setTitlePosition} );
			
			TweenLite.to(_tempPanel, 				2, 	{ y:2500 } );
			TweenLite.to(_camera, 	 				2, 	{ y:tempCamY, x:tempCamX, z: tempCamZ, rotationX:0, rotationY: 0 } );
		}
		
		private function setTitlePosition():void
		{
			_tempTitle.x = _tempTitleX;
			_tempTitle.y = _tempTitleY;
			TweenLite.to(_tempTitle.container, 	.8, { delay:1.5,  alpha:1 } );
		}
		
		private function resetTitlePosition():void
		{
			_tempTitle.x = _titles[_targetIndex][1].x;
			_tempTitle.y = _titles[_targetIndex][1].y;
		}
		
		public function deactivatePageContent():void
		{	
			TweenLite.to(_tempTitle.container, 	.7, { alpha:0, onComplete:resetTitlePosition } );
			
			TweenLite.delayedCall(1.5, addCameraUpdateHandler);
			TweenLite.delayedCall(1.5, removeObjectUpdateHandler);
			
			_returnToBase = true;
			TweenLite.delayedCall(1, relocateCamera);
			
			TweenLite.to(_skyBox.container, 1, { alpha:1});
		}
		
		public function makeFancy():void
		{
			if (!AppData.isFancy) 
			{
				for (var i:int = 0; i < _panels.length; i++) 
				{
					var blur:Number = Math.round(distanceTo(_panels[i][0], _tempPanel) / 250);
					if (blur < 5) 
					{
						blur = 5;
					}
					if (_panels[i][0] != _tempPanel) 
					{
						TweenLite.to(_panels[i][0].container, .4, { delay:.5, 	blurFilter: { blurX:blur, blurY:blur, quality:2, remove:false }} );
					}
				}
			}
		}
		
		public function makeBasic():void
		{
			if (AppData.isFancy) 
			{
				for (var i:int = 0; i < _panels.length; i++) 
				{
					TweenLite.to(_panels[i][0].container, .4, { delay:.5, 	blurFilter: { blurX:0, blurY:0, quality:2, remove:false }} );
				}
			}
		}
		
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//									render interactions
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++		

		private var rotY	:Number;
		private var rotX	:Number;
		private var locY	:Number;
		private var locX	:Number;
		
		private var _divH:uint = AppData.stageH / 2;
		private var _divW:uint = AppData.stageW / 2;
		
		private function updateObjectPosition(e:Event):void
		{
			var dtime	:Number = AppData.deltaTime;
			var limit	:Number	= .01;

			//vertical movement
			if (mouseX < _divW) 
			{	
				rotY 	= (((mouseX  - _divW)) * limit) - _tempObjRotY;			
			} 
			else if (mouseX > _divW) 
			{
				rotY 	= -((((_divW - mouseX)) * limit) + _tempObjRotY);	
			}
			//horizontal movement
			if (mouseY < _divH) 
			{
				rotX	= -((_divH - mouseY) * limit);
			} 
			else if (mouseY > _divH) 
			{
				rotX 	= (mouseY  - _divH) * limit;
			}
				
			_tempPanel.rotationX  -= (_tempPanel.rotationX - rotX)  * dtime;
			_tempPanel.rotationY  -= (_tempPanel.rotationY - rotY) * dtime;
			
			_tempTitle.rotationX = _tempPanel.rotationX;
			_tempTitle.rotationY = _tempPanel.rotationY;
		}
		
		private function updateCameraPosition(e:Event):void 
		{
			//set delta time quantity
			var dtime		:Number = AppData.deltaTime * 2.5;
			
			//set rotation / movement limiter
			var limit	:Number	= .005;
			
			//vertical movement
			if (mouseX < _divW) 
			{	
				rotY 	= (mouseX  - _divW) * limit;			
				locX 	= _tempPanel.x - ((_divW - mouseX) * limit ); 
			} 
			else if (mouseX > _divW) 
			{
				rotY 	= -((_divW - mouseX) * limit);	
				locX 	= _tempPanel.x + ((mouseX  - _divW) * limit );
			}
			//horizontal movement
			if (mouseY < _divH) 
			{
				rotX	= -((_divH - mouseY) * limit);
				locY	= _tempPanel.y -((mouseY - _divH) * limit);
			} 
			else if (mouseY > _divH) 
			{
				rotX 	= (mouseY  - _divH) * limit;
				locY	= _tempPanel.y +(_divH - mouseY) * limit;
			}
			
			// currentLoc -= (currentLoc - targetLoc) / easing divisor 
			// dtime changes over time as framerate varies
			_camera.rotationX 	-= (_camera.rotationX - rotX ) 	* dtime;
			_camera.rotationY 	-= (_camera.rotationY - rotY ) 	* dtime;
			_camera.x			-= (_camera.x - locX) 			* dtime;
			_camera.y			-= (_camera.y - (locY - 50 )) 	* dtime;
		}	
	
		private function renderLoop(e:Event = null):void 
		{
			_renderEngine.renderScene(_scene, _camera, _viewport);
		}
		
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//							get set
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++			
		
		public function get tempCoords():Array
		{
			_tempPanel.calculateScreenCoords(_camera);
			return [_divW + _tempPanel.screen.x, _divH + _tempPanel.screen.y];
		}		
		
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//							utils
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++		

		private function distanceTo( obj1:DisplayObject3D, obj2:DisplayObject3D ):Number
		{
			var x :Number = obj1.x - obj2.x;
			var y :Number = obj1.y - obj2.y;
			var z :Number = obj1.z - obj2.z;
	
			return Math.sqrt( x*x + y*y + z*z );
		}
		
//++++++++++++++++++++++++++++++     end     ++++++++++++++++++++++++++++++++++		

	}
}