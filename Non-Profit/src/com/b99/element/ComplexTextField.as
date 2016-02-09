///////////////////////////////////////////////////////////////////////////////
//
//	com>b99>element>TextField_Basic.as
//
//	extends : sprite
//
///////////////////////////////////////////////////////////////////////////////

package com.b99.element  
{
	import flash.display.Sprite;
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import flash.text.FontStyle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	/**
	 * ...
	 * @author bosworth99
	 */
	
	public class ComplexTextField extends Sprite
	{
		
		//+++++++++++++++++Text format+++++++++++++++
		private var _format_kaufmann	:TextFormat = new TextFormat();
		private var _format_verdana		:TextFormat = new TextFormat();
		
		//++++++++++++++++++Text Fields++++++++++++++
		private var _textFieldFormat	:TextField;
		
		//++++++++++++++++++Strings++++++++++++++++++
		
		private var _text				:String;
		private var _intent				:String;
		
		//++++++++++++++++++numerics+++++++++++++++++
		private var _color				:uint;
		private var _size				:uint;
		private var _height				:uint;
		private var _width				:uint;
		private var _textWidth			:uint;
		private var _leading			:uint;
		
		//++++++++++++++++++booleans+++++++++++++++++
		private var _style 				:String;
		
		//+++++++++++++++++ fonts +++++++++++++++++++
		private var _kaufmann			:Font;
		private var _verdana			:Font;
		private var _kaufmannBold		:Font;
		private var _verdanaBold		:Font;
		private var _kaufmannItalic		:Font;
		private var _verdanaItalic		:Font;
		

		/**
		* @private
		* 
		* @param text		:string = text
		* @param intent		:string = "verdana_title", "verdana_text", "kaufmann"
		* @param color		:uint = text color	
		* @param size		:uint = font size
		* @param height		:uint = textfield height
		* @param width		:uint = textfield width
		* @param style		:string = "bold", "italic", "none"
		* @param leading	:uint = line spacing
		*/
		
		public function ComplexTextField(text:String = "", intent:String = "verdana_title", color:uint = 0x000000, size:uint = 12, height:uint = 20, width:uint = 50, style:String = "none", leading:uint = 5) 
		{
			super();
		
			_text 		= text;
			_intent 	= intent;
			_color 		= color;
			_size 		= size;
			_height 	= height;
			_width 		= width;
			_style 		= style;
			_leading   	= leading;
			
			buildFormats();
			buildTextField();
		}
		/**
		 * @private
		 * assign formats for text fields to use, color and size is passed at time of instantiation, making them flexible
		 * 
		 */
		private function buildFormats():void
		{
			switch (_style) 
			{
				case "none":
				{
					_kaufmann = new Kaufmann();
					_verdana = new Verdana();
					
					with (_format_kaufmann) { font = _kaufmann.fontName; color = _color; size = _size; leading = _leading;  align = TextFormatAlign.LEFT; bold = false; italic = false; };
					with (_format_verdana)	{ font = _verdana.fontName;  color = _color; size = _size; leading = _leading;  align = TextFormatAlign.LEFT; bold = false; italic = false;};
					break;
				}
				case "bold":
				{
					_kaufmannBold = new Kaufmann_bold();
					_verdanaBold = new Verdana_bold();
					
					with (_format_kaufmann) { font = _kaufmannBold.fontName; color = _color; size = _size; leading = _leading; align = TextFormatAlign.LEFT; bold = true; italic = false; };
					with (_format_verdana)	{ font = _verdanaBold.fontName;  color = _color; size = _size; leading = _leading; align = TextFormatAlign.LEFT; bold = true; italic = false; };
					break;
				}
				case "italic":
				{
					_kaufmannItalic = new Kaufmann();
					_verdanaItalic = new Verdana_italic();
					
					with (_format_kaufmann) { font = _kaufmannItalic.fontName; color = _color; size = _size; leading = _leading; align = TextFormatAlign.LEFT;};
					with (_format_verdana)	{ font = _verdanaItalic.fontName;  color = _color; size = _size; leading = _leading; align = TextFormatAlign.LEFT; bold = false; italic = true;};
					break;
				}
			}
		}
		/**
		 * @private use the _intent switch to define different text fields for differing purposes
		 * 
		 * @param	_text:String =  text to display
		 * @param	_intent:string  = "verdana_title", "verdana_text", "kaufmann"
		 * @param	_height:uint = if the intent is a text, define a height
		 * @param	_width:uint = if the intent is a text, define a width
		 */
		private function buildTextField():void
		{
			_textFieldFormat = new TextField();
			
			switch (_intent) 
			{
				case "kaufmann":
				{
					with (_textFieldFormat) 
					{
						defaultTextFormat 	= _format_kaufmann;
						autoSize 			= TextFieldAutoSize.LEFT;
						selectable 			= false;
						embedFonts 			= true;
						antiAliasType 		= AntiAliasType.ADVANCED;
						text 				= _text;
					}
					break;
				}
				case "verdana_title":
				{
					with (_textFieldFormat) 
					{
						defaultTextFormat 	= _format_verdana;
						autoSize 			= TextFieldAutoSize.LEFT;
						selectable 			= false;
						embedFonts 			= true;
						antiAliasType 		= AntiAliasType.ADVANCED;
						text 				= _text;
					}
					break;
				}
				case "verdana_text":
				{
					with (_textFieldFormat) 
					{
						defaultTextFormat 	= _format_verdana;
						selectable 			= false;
						multiline 			= true;
						wordWrap 			= true;
						embedFonts 			= true;
						antiAliasType 		= AntiAliasType.ADVANCED;
						text 				= _text;
						height 				= _height;
						width 				= _width;
					}
					break;
				}
				
			}
			//_textFieldFormat.cacheAsBitmap = true;
			
			this.addChild(_textFieldFormat);
			
		}
		
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//							 destroy
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++		
		public function destroy():void
		{
			//+++++++++++++++++Text format+++++++++++++++
			_format_kaufmann	= null;
			_format_verdana		= null;
			
			//++++++++++++++++++Text Fields++++++++++++++
			this.removeChild(_textFieldFormat);
			_textFieldFormat 	= null;

			if (_kaufmann) 
			{
				_kaufmann		= null;
			}
			if (_verdana) 
			{
				_verdana		= null;
			}
			if (_kaufmannBold) 
			{
				_kaufmannBold	= null;
			}
			if (_verdanaBold) 
			{
				_verdanaBold	= null;
			}
			if (_kaufmannItalic) 
			{
				_kaufmannItalic	= null;
			}
			if (_verdanaItalic) 
			{
				_verdanaItalic	= null;
			}
			
			this.parent.removeChild(this);
		}
		
		
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//							 get n set
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		
		public function set set_text(newText:String):void 
		{
			_textFieldFormat.text = newText;
		}
		
		public function get textWidth():uint { return _textFieldFormat.textWidth; }
		
	}
}