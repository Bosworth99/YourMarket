///////////////////////////////////////////////////////////////////////////////
//
//	com>b99>display>BasicButton.as
//
//	extends : sprite
//
//	flexible class for button 
//
///////////////////////////////////////////////////////////////////////////////


package com.b99.composite
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import com.greensock.*;
	import com.greensock.plugins.*;

	/**
	 * ...
	 * @author bosworth99
	 */
	public class BasicButton extends Sprite
	{
		private var _size		:String;
		private var _color		:String;
		private var _text		:String;
		private var _font		:String;
		private var _style		:String;
		
		private var _generic	:CustomComplexButton;
		/**
		* @private
		* assign top level variables, instantiate a CustomComplexButton, add it to calling object
		* 
		* @param size		:String; generic size of button. 	"small" "med" "large" 
		* @param color		:String; generic color of button. 	"dark" "light" "trans"
		* @param txt		:String; text button will display. 
		* @param font 		:String; font fam for button text "verdana_title"(default) or "kaufmann"
		* @param style		:String; font style for text "none"(default) "italic" "bold"
		*/
		public function BasicButton(size:String, color:String, txt:String, font:String = "verdana_title", style:String = "none"):void 
		{
			_size			= size;
			_color			= color;
			_text			= txt;
			_font 			= font;
			_style			= style;
			
			_generic = new CustomComplexButton(_size, _color, _text, _font, _style);
			this.addChild(_generic);
			
			add_listeners();
		}
		
		public function add_listeners():void 
		{
			TweenPlugin.activate([GlowFilterPlugin]);
			
			_generic.addEventListener(MouseEvent.MOUSE_OVER, 	over, false, 0, true);
			_generic.addEventListener(MouseEvent.MOUSE_OUT, 	out, false, 0, true);
		}
		
		private function over(e:MouseEvent):void 
		{
			TweenLite.to(e.target, 	.2, { glowFilter: { color:0xFFFFFF, alpha:1, blurX:10, blurY:10 }} );
		}
		private function out(e:MouseEvent):void 
		{
			TweenLite.to(e.target, 	.7, { glowFilter: { color:0xFFFFFF, alpha:0, blurX:0, blurY:0, remove:true}} );
		}
		
		public function disable():void 
		{
			_generic.mouseEnabled = false;
		}
		
		public function enable():void 
		{
			_generic.mouseEnabled = true;
		}
		
		public function destroy():void
		{
			_generic.removeEventListener(MouseEvent.MOUSE_OVER,over);
			_generic.removeEventListener(MouseEvent.MOUSE_OUT, out);
			
			_generic.destroy();
			_generic = null;
			
			this.parent.removeChild(this);
		}
	}
}

//-----------------------------------------------------------------------------
//
//	create simple button
//
//-----------------------------------------------------------------------------

import flash.display.DisplayObject;
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.text.TextField;

import com.b99.element.ComplexRoundRect;

class CustomComplexButton extends SimpleButton 
{
	//top levels
	private var _size			:String;
	private var _color			:String;
	private var _text			:String;
	private var _font			:String;
	private var _style			:String;

	private var _hitWidth		:uint;
	private var _hitHeight		:uint;
	private var _upState		:CustomState;
	private var _overState		:CustomState;
	private var _hitTestState	:ComplexRoundRect;
	
	/**
	* @private
	* take top level variables
	* instantiate button states
	* creat hit space from customRoundRect
	* 
	* @param size		:String; generic size of button. 	"small" "med" "large" 
	* @param color		:String; generic color of button. 	"dark" "light" "trans"
	* @param txt		:String; text button will display. 
	* @param font 		:String; font fam for button text "verdana_title"(default) or "kaufmann"
	* @param style		:String; font style for text "none" "italic" "bold"
	*/
	
	public function CustomComplexButton(size:String, color:String, txt:String, font:String, style:String) 
	{
		_size				= size;
		_color				= color;
		_text				= txt;
		_font				= font;
		_style				= style;

		switch (_size) 
		{
			case "large":
			{
				_hitWidth 	= _text.length * 14;
				_hitHeight	= 50;
				
				break;
			}
			case "med":
			{
				_hitWidth	= _text.length * 10;
				_hitHeight	= 40;
				
				break;
			}
			case "small":
			{
				_hitWidth	= _text.length * 8;
				_hitHeight	= 30;
				
				break;
			}
		}	
			
		_upState 	= new CustomState(_size, _color, _text, _font, style, "up");
		_overState 	= new CustomState(_size, _color, _text, _font, style, "over");
		
		_upState.cacheAsBitmap = true;
		_overState.cacheAsBitmap = true;
		
		this.upState        = _upState;
		this.overState      = _overState;
		this.downState 		= _overState;
		
		_hitTestState		= new ComplexRoundRect(_hitWidth, _hitHeight, 0, "linear", [0x00FF40], [1], [1], 270, 1, 0x000000, 1);
		this.hitTestState   = _hitTestState
		this.hitTestState.x = -((_hitTestState.width - _upState.width )/2) ;
		this.hitTestState.y = -((_hitTestState.height - _upState.height )/2);

		this.cacheAsBitmap = true;
	}
	
	public function destroy():void
	{
		_upState.destroy();
		_upState = null;
		
		_overState.destroy();
		_overState = null;
		
		_hitTestState = null;
		
		this.parent.removeChild(this);
	}
}

//-----------------------------------------------------------------------------
//
//	create graphics for button states
//
//-----------------------------------------------------------------------------


import com.b99.element.ComplexRoundRect;
import com.b99.element.ComplexTextField;

import flash.filters.*;

class CustomState extends Sprite 
{	
	//top levels
	private var _size			:String;
	private var _color			:String;
	private var _text			:String;
	private var _state			:String;
	private var _font			:String;
	private var _style			:String;
	
	//variables for rect
	private var _height			:uint;
	private var _width			:uint;
	private var _addWidth		:uint;
	private var _ellipse		:uint;
	
	//variables for over state
	private var _overColors		:Array;
	private var _overAlphas		:Array;
	private var _overRatios		:Array;
	private var _overRot		:uint;
	private var _overLineColor	:uint;
	private var _overLineAlpha	:uint;
	
	//variables for up state
	private var _upColors		:Array;	
	private var _upAlphas		:Array;
	private var _upRatios		:Array;
	private var _upRot			:uint;
	private var _upLineColor	:uint;
	private var _upLineAlpha	:uint;
	private var _lineWeight		:Number;
	
	//_theTextField variables
	private var _overFontColor	:uint;
	private var _upFontColor	:uint;
	private var _fontSize		:uint;
	
	private var _txtY			:int;
	private var _blurSizeG		:uint;
	private var _blurSizeT		:uint;
	
	
	//filters
	private var _gf_graphic		:GlowFilter;
	private var _gf_text		:GlowFilter;
	
	private var _theGraphic		:ComplexRoundRect;
	private var _theTextField	:ComplexTextField;
	
	/**
	* @private
	* take top level variables, assign complex variables for each 
	* build button states from those newly assigned variables
	* 
	* @param size		:String; generic size of button. 	"small" "med" "large" 
	* @param color		:String; generic color of button. 	"dark" "light" "trans"
	* @param txt		:String; text button will display
	*/
	
	public function CustomState(size:String, color:String, txt:String, font:String, style:String, state:String)
	{
		_size				= size;
		_color				= color;
		_text				= txt;
		_font				= font;
		_style				= style;
		_state				= state;
		
		switch (_size) 
		{
			case "large":
			{
				_addWidth 	= 12;
				_height 	= 28;
				_ellipse 	= 30;
				
				_lineWeight	= 2;
				_blurSizeG	= 15;
				_blurSizeT	= 8;
				_txtY		= 1;
				
				if (_font == "kaufmann") 
				{
					_fontSize	= 26;
				} 
				else 
				{
					_fontSize	= 17;
				}
				
				break;
			}
			case "med":	
			{
				_addWidth 	= 10;
				_height 	= 24;
				_ellipse 	= 24;
				
				_lineWeight = 2;
				_blurSizeG	= 10;
				_blurSizeT 	= 8;
				_txtY		= 1;
				
				if (_font == "kaufmann") 
				{
					_fontSize	= 22;
				} 
				else 
				{
					_fontSize	= 14;
				}

				break;
			}
			case "small":	
			{
				_addWidth 	= 8;
				_height 	= 20;
				_ellipse 	= 20;
				
				_lineWeight	= 2;
				_blurSizeG	= 8;
				_blurSizeT	= 8;
				_txtY		= 2;
				
				if (_font == "kaufmann") 
				{
					_fontSize	= 16;
				} 
				else 
				{
					_fontSize	= 10;
				}
				
				break;
			}
		}
		switch (_color)
		{
			case "dark":
			{
				_overColors		= [0x1B1B1B, 0x727272, 0x252525];
				_overRatios		= [90, 100, 255];
				_overAlphas		= [1, 1, 1 ];
				_overRot		= 270;
				_overLineColor	= 0x1F1F1F;
				_overLineAlpha	= 1;
				
				_upColors		= [0x454545, 0x969696, 0x404040];
				_upRatios		= [90, 100, 255];
				_upAlphas		= [1, 1, 1 ];
				_upRot			= 270;
				_upLineColor	= 0x000000;
				_upLineAlpha	= 1;
				
				_overFontColor	= 0xF7F7F7;
				_upFontColor	= 0xD3D3D3;
				
				_gf_graphic	= new GlowFilter(0xFFFFFF, .5, _blurSizeG, _blurSizeG);
				_gf_text	= new GlowFilter(0xFFFFFF, .5, _blurSizeT, _blurSizeT);
				
				break;
			}
			case "light":
			{
				_overColors		= [0xE1E1E1, 0xA0A0A0, 0xFBFBFB];
				_overRatios		= [90, 100, 255];
				_overAlphas		= [1, 1, 1 ];
				_overRot		= 270;
				_overLineColor	= 0x535353;
				_overLineAlpha	= 1;
				
				_upColors		= [0xE8E8E8, 0xC1C1C1, 0xF5F5F5];
				_upRatios		= [90, 100, 255];
				_upAlphas		= [1, 1, 1 ];
				_upRot			= 270;
				_upLineColor	= 0x838383;
				_upLineAlpha	= 1;
				
				_overFontColor	= 0x111111;
				_upFontColor	= 0x7C7C7C;
				
				_gf_graphic	= new GlowFilter(0xFFFFFF, .2, _blurSizeG, _blurSizeG);
				_gf_text	= new GlowFilter(0xFFFFFF, 1, _blurSizeT, _blurSizeT);
				
				break;
			}
			case "trans":
			{
				_overColors		= [0xE2E2E2, 0xD6D6D6, 0xF2F2F2];
				_overRatios		= [1, 127, 256];
				_overAlphas		= [.1, .1, .1 ];
				_overRot		= 90;
				_overLineColor	= 0xDFDFDF;
				_overLineAlpha	= 0;
				
				_upColors		= [0xCECECE, 0xB5B5B5, 0xE5E5E5];
				_upRatios		= [1, 127, 256];
				_upAlphas		= [.1, .1, .1 ];
				_upRot			= 90;
				_upLineColor	= 0x5D5D5D;
				_upLineAlpha	= 0;
				
				_overFontColor	= 0xF7F7F7;
				_upFontColor	= 0xDBDBDB;
				
				_gf_graphic	= new GlowFilter(0xFFFFFF, 0, _blurSizeG, _blurSizeG);
				_gf_text	= new GlowFilter(0xFFFFFF, .2, _blurSizeG, _blurSizeG);
				
				break;
			}
		}
		
	//add graphical elements to button states
		
		switch (_state)
		{
			case "up":
			{
				if (_font == "kaufmann") 
				{
					_theTextField	= new ComplexTextField(_text, "kaufmann", _upFontColor, _fontSize, 0, 0, _style);
				}
				else 
				{
					_theTextField	= new ComplexTextField(_text, "verdana_title", _upFontColor, _fontSize, 0, 0, _style);
				}
				
				if (_color == "trans") 
				{
					_width 	= _theTextField.width;
					_theTextField.x = 0;
					_theTextField.y = 0;
				} 
				else 
				{
					_width 		= _theTextField.width + (_addWidth * 2);
					_theTextField.x = _addWidth;
					_theTextField.y = _txtY;
				}
				
				_theTextField.mouseEnabled = false;
				_theTextField.cacheAsBitmap = true;	
				
				_theGraphic		= new ComplexRoundRect(	_width, 
														_height, 
														_ellipse, 
														"linear", 
														_upColors, 
														_upAlphas, 
														_upRatios, 
														_upRot, 
														_lineWeight, 
														_upLineColor, 
														_upLineAlpha);
				
				_theGraphic.cacheAsBitmap 	= true;
				_theGraphic.useHandCursor 	= true;
				_theGraphic.buttonMode 		= true;										
																					
				this.addChild(_theGraphic);
				this.addChild(_theTextField);

				break;
			}
			
			case "over":
			{
				if (_font == "kaufmann") 
				{
					_theTextField	= new ComplexTextField(_text, "kaufmann", _overFontColor, _fontSize, 0, 0, _style);
				}
				else 
				{
					_theTextField	= new ComplexTextField(_text, "verdana_title", _overFontColor, _fontSize, 0, 0, _style);
				}
				
				if (_color == "trans") 
				{
					_width 	= _theTextField.width;
					_theTextField.x = 0;
					_theTextField.y = 0;
				} 
				else 
				{
					_width 		= _theTextField.width + (_addWidth * 2);
					_theTextField.x = _addWidth;
					_theTextField.y = _txtY;
				}
				
				_theTextField.mouseEnabled = false;
				//_theTextField.cacheAsBitmap = true;	
				
				_theGraphic		= new ComplexRoundRect(	_width, 
														_height, 
														_ellipse, 
														"linear", 
														_overColors, 
														_overAlphas, 
														_overRatios, 
														_overRot, 
														_lineWeight, 
														_overLineColor, 
														_overLineAlpha);
									
				//_theGraphic.cacheAsBitmap 	= true;
				_theGraphic.useHandCursor 	= true;
				_theGraphic.buttonMode 		= true;																			
										
				this.addChild(_theGraphic);
				this.addChild(_theTextField);
				_theTextField.filters = [_gf_text];

				break;
			}
		}
	}
	
	public function destroy():void
	{
		_overColors.splice(0, 	_overColors.length);
		_overColors = null;
		
		_overAlphas.splice(0, 	_overAlphas.length);
		_overAlphas = null;
		
		_overRatios.splice(0, 	_overRatios.length);
		_overRatios = null;
		
		_upColors.splice(0, 	_upColors.length);
		_upColors = null;
		
		_upAlphas.splice(0,		_upAlphas.length);
		_upAlphas = null;
		
		_upRatios.splice(0, 	_upRatios.length);
		_upRatios = null;
		
		_theGraphic.filters = [];
		_gf_graphic	= null;
		this.removeChild(_theGraphic);
		_theGraphic = null;
		
		_theTextField.filters = [];
		_gf_text	= null;
		this.removeChild(_theTextField);
		_theTextField = null;
		
	}
}