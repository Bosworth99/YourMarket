package com.b99.display.content 
{
	import com.b99.app.AppData;
	import com.b99.composite.BackButton;
	import com.b99.composite.BasicButton;
	import com.b99.composite.ProductButton;
	import com.b99.element.ComplexTextField;
	import com.b99.interfaces.*;
	import com.greensock.TweenLite;
	import flash.display.BlendMode;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	/**
	 * ...
	 * @author bosworth99
	 */
	public class Outreach extends Content_Base implements IContent
	{
		//+++++++++++++++++++++++++++++ containers
		private var _btnCon				:Sprite;
		
		//+++++++++++++++++++++++++++++ graphics
		private var _img_texture 		:MovieClip; 
		private var _gfx_maskTexture	:Mask;
		private var _gfx_headerLine		:HeaderLine;
		private var _gfx_footer			:Footer;

		private var _img_brush			:MovieClip;
		
		//+++++++++++++++++++++++++++++ buttons
		private var _img_classFurn		:MovieClip;	
		private var _img_filesStorage	:MovieClip;	
		private var _img_pacific		:MovieClip;	

		private var _btn_classFurn		:ProductButton;	
		private var _btn_filesStorage	:ProductButton;	
		private var _btn_pacific		:ProductButton;	

		private var _btn_back			:BackButton;

		//+++++++++++++++++++++++++++++ text
		private var _mainTitle			:ComplexTextField;
		private var _mainText			:ComplexTextField;
		
		//+++++++++++++++++++++++++++++ misc
		private var _camDirection		:String = "right";
		
//-----------------------------------------------------------------------------
//							constructor
//-----------------------------------------------------------------------------		
		
		public function Outreach() 
		{
			super();
			init();
		}
				
		private function init():void
		{
			trace("Outreach.init()");
		}

		override public function assembleDisplayObjects():void
		{
			for (var i:int = 0; i < _library.length; i++) 
			{
				instantiateLibraryItem(i);
			}

			//---------------- containers
			_canvas = new Sprite();
			this.addChild(_canvas);
			
			_btnCon	= new Sprite();
			this.addChild(_btnCon);
			
			_flyoutCon = new Sprite();
			this.addChild(_flyoutCon);
			
			//---------------- background
			with (_img_texture) 
			{
				x 			= -20;
				y 			= 311;
			}
			_canvas.addChild(_img_texture);
			_img_texture.filters = [_textureDS];
			
			_gfx_maskTexture = new Mask();
			with (_gfx_maskTexture) 
			{
				x			= 0;
				y			= 0;
			}
			_canvas.addChild(_gfx_maskTexture);
			_img_texture.mask 		= _gfx_maskTexture;

			_gfx_headerLine 		= new HeaderLine();
			_canvas.addChild(_gfx_headerLine);
			
			_gfx_footer				= new Footer();
			_gfx_footer.blendMode 	= BlendMode.MULTIPLY; 
			_gfx_footer.alpha 		= .9;
			_canvas.addChild(_gfx_footer);
			
			//---------------- buttons
			
			_btn_filesStorage = new ProductButton(_img_filesStorage, .83);
			with (_btn_filesStorage) 
			{
				x			= 180;
				y			= 172;
				name		= "Files Storage";
			}
			_btnCon.addChild(_btn_filesStorage);
			
			_btn_classFurn = new ProductButton(_img_classFurn, .88);
			with (_btn_classFurn) 
			{
				x			= 182;
				y			= 315;
				name		= "Classroom Furniture";
			}
			_btnCon.addChild(_btn_classFurn);
			
			_btn_pacific = new ProductButton(_img_pacific, .96);
			with (_btn_pacific) 
			{
				x			= 243;
				y			= 566;
				name		= "Chairs Desks";
			}
			_btnCon.addChild(_btn_pacific);

			//---------------- misc graphics
			with (_img_brush)
			{
				x 			= 21;
				y 			= 643;
				scaleX 		= .89;
				scaleY 		= .89;
				rotation	= 7.0;
			}
			_img_brush.filters = [_objDS]
			_canvas.addChild(_img_brush);
			
			//---------------- text
			_mainTitle = new ComplexTextField(	
				AppData.nonProfitXML.content.scene.(@name == _name).text.pageContent.mainTitle,
				"kaufmann",
				AppData.nonProfitXML..scene.(@name == _name).text.pageContent.titleColor,
				70,
				100,
				420,
				"none"
				);
			with (_mainTitle) 
			{
				x			= 488;
				y			= 472;
				rotation	= -2.0;
			}						
			_canvas.addChild(_mainTitle);
			
			_mainText = new ComplexTextField(	
				AppData.nonProfitXML.content.scene.(@name == _name).text.pageContent.mainText,
				"verdana_text",
				AppData.nonProfitXML..scene.(@name == _name).text.pageContent.textColor,
				10,
				350,
				360,
				"none"
				);
			with (_mainText) 
			{
				x			= 511;
				y			= 564;
				rotation	= -2.0;
			}						
			_canvas.addChild(_mainText);
			
			_btn_back = new BackButton(AppData.nonProfitXML..scene.(@name == _name).text.pageContent.titleColor);
			with (_btn_back)
			{
				x 			= 0;
				y 			= 0;
			}
			_canvas.addChild(_btn_back);
		}	
		
		override public function instantiateLibraryItem(index:uint ):void
		{
			switch (_libNames[index]) 
			{
				case "IMG_out_classroomFurniture":
					_img_classFurn 		= new _library[index] as MovieClip;
					break;
				case "IMG_out_filesStorage":
					_img_filesStorage 	= new _library[index] as MovieClip;
					break;
				case "IMG_out_pacificChair":
					_img_pacific 		= new _library[index] as MovieClip;
					break;
				case "IMG_out_paintbrush":
					_img_brush 			= new _library[index] as MovieClip;
					break;
				case "IMG_out_texture":
					_img_texture 		= new _library[index] as MovieClip;
					break;
			}
		}

		override public function animateContentIn():void
		{
			TweenLite.from(_img_texture, 		1, { delay:0.1,y:_img_texture.y + 100,		alpha:0 } );
			TweenLite.from(_gfx_headerLine, 	1, { delay:0.3,	alpha:0 } );
			TweenLite.from(_btn_filesStorage, 	1, { delay:0.5,	x:_btn_filesStorage.x - 50,	alpha:0 } );
			TweenLite.from(_btn_classFurn, 		1, { delay:0.9,	x:_btn_classFurn.x - 50, 	alpha:0 } );
			TweenLite.from(_btn_pacific, 		1, { delay:1.0,	x:_btn_pacific.x - 50,		alpha:0 } );
			TweenLite.from(_img_brush, 			1, { delay:1.2,	x:_img_brush.x - 50, 		alpha:0 } );
			TweenLite.from(_mainTitle, 			1, { delay:1.4,	x:_mainTitle.x - 50, 		alpha:0 } );
			TweenLite.from(_mainText, 			1, { delay:1.5,	x:_mainText.x - 50, 		alpha:0 } );
			TweenLite.from(_btn_back, 			1, { delay:1.6,	x:_btn_back.x-100, 			alpha:0, onComplete:animateInComplete } );
		}
//-----------------------------------------------------------------------------
//							eventHandlers
//-----------------------------------------------------------------------------				
		
		override public function addEventHandlers():void
		{
			_btnCon.addEventListener(MouseEvent.MOUSE_OVER, 	productOver, 	false, 0, true);
			_btnCon.addEventListener(MouseEvent.MOUSE_OUT, 		productOut,  	false, 0, true);
			_btnCon.addEventListener(MouseEvent.MOUSE_DOWN, 	productDown, 	false, 0, true);
			
			_btn_back.addEventListener(MouseEvent.MOUSE_DOWN,	backDown, 		false, 0, true);		
		}
	
//-----------------------------------------------------------------------------
//							animate out
//-----------------------------------------------------------------------------		
		
		override public function animateContentOut():void
		{
			removeEventHandlers();	
			
			TweenLite.to(_btn_back, 		.5, { delay:1.2,	alpha:0, onComplete:animateOutComplete } );
			TweenLite.to(_img_texture, 		.5, { delay:1.2,	alpha:0 } );
			TweenLite.to(_gfx_headerLine, 	.5, { delay:1.1,	alpha:0 } );
			TweenLite.to(_gfx_footer, 		.5, { delay:1.0,	alpha:0 } );
			TweenLite.to(_btn_filesStorage, .5, { delay:0.9,	alpha:0 } );
			TweenLite.to(_btn_classFurn, 	.5, { delay:0.7,	alpha:0 } );
			TweenLite.to(_btn_pacific, 		.5, { delay:0.6,	alpha:0 } );
			TweenLite.to(_img_brush, 		.5, { delay:0.4,	alpha:0 } );
			TweenLite.to(_mainTitle, 		.5, { delay:0.3,	alpha:0 } );
			TweenLite.to(_mainText, 		.5, { delay:0.2,	alpha:0 } );
		}
		
//-----------------------------------------------------------------------------
//							destroy
//-----------------------------------------------------------------------------				

		override public function removeEventHandlers():void
		{
			_btnCon.removeEventListener(MouseEvent.MOUSE_OVER, 		productOver);
			_btnCon.removeEventListener(MouseEvent.MOUSE_OUT, 		productOut);
			_btnCon.removeEventListener(MouseEvent.MOUSE_DOWN, 		productDown);
			
			_btn_back.removeEventListener(MouseEvent.MOUSE_DOWN,	backDown);
		}	
					
		override public function reset():void
		{
			_img_texture.alpha 		= 1;
			_gfx_headerLine.alpha 	= 1;
			_gfx_footer.alpha 		= .9;
			_btn_filesStorage.alpha = 1;
			_btn_classFurn.alpha 	= 1;
			_btn_pacific.alpha 		= 1;
			_img_brush.alpha 		= 1;
			_mainTitle.alpha 		= 1;
			_mainText.alpha 		= 1;
			_btn_back.alpha 		= 1;
		}

//-----------------------------------------------------------------------------
//							get n set
//-----------------------------------------------------------------------------					

		override public function get camDirection():String { return _camDirection; }		
		
	}

}

//-----------------------------------------------------------------------------
//
//	draw graphics
//
//-----------------------------------------------------------------------------

import com.b99.app.AppData;
import flash.display.*;

class Footer extends Sprite
{
	public function Footer()
	{
		var base:Sprite = new Sprite();
		var color:uint 	= 0xd7a570;
		
		var top:int 	= 525;
		var right:int 	= AppData.stageW + 30;
		var bottom:int 	= AppData.stageH;
		var left:int 	= 500;

		with (base) 
		{
			graphics.beginFill(color);
			graphics.moveTo		( right, 		bottom									);
			graphics.lineTo		( right, 		top										);
			graphics.lineTo		( left, 		top + 20								);
			graphics.curveTo	( left - 50, 	top + 20, 	left - 60, 		top + 70 	);
			graphics.lineTo		( left - 80, 	bottom									);
			graphics.lineTo		( right, 		bottom									);
			graphics.endFill();
		}
		this.addChild(base);
	}
}

class HeaderLine extends Sprite
{
	public function HeaderLine()
	{
		var line:Sprite = new Sprite();
		var color:uint 	= 0x000000;
		
		var top:int 	= 450;
		var right:int 	= AppData.stageW + 5;
		var bottom:int 	= AppData.stageH;
		var left:int 	= -5;
		
		with (line) 
		{
			graphics.lineStyle(7, color, 1);
			graphics.moveTo		( right,		top									);
			graphics.lineTo		( left, 		top + 35							);
			graphics.lineTo		( left, 		bottom								);
		}
		this.addChild(line);
	}
}

class Mask extends Sprite
{
	public function Mask()
	{
		var base:Sprite = new Sprite();
		var color:uint 	= 0x00FF00;
		
		var top:int 	= 450;
		var right:int 	= AppData.stageW + 5;
		var bottom:int 	= AppData.stageH;
		var left:int 	= -5;
		
		with (base) 
		{
			graphics.beginFill(color);
			graphics.moveTo		( left, 		bottom								);
			graphics.lineTo		( right,   		bottom								);
			graphics.lineTo		( right,		top									);
			graphics.lineTo		( left, 		top + 35							);
			graphics.lineTo		( left, 		bottom								);
			graphics.endFill();
		}
		this.addChild(base);
	}
}


