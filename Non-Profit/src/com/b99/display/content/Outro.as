///////////////////////////////////////////////////////////////////////////////
//
//	com>b99>display>content>Outro.as
//
//	extends : sprite
//
//	Outro scene after content has been unloaded.
//
///////////////////////////////////////////////////////////////////////////////

package com.b99.display.content 
{
	import com.b99.composite.BasicButton;
	import com.b99.composite.outro.CandleFlame;
	import com.b99.element.ComplexRoundRect;
	import com.b99.element.ComplexTextField;
	import com.greensock.plugins.BlurFilterPlugin;
	import com.greensock.plugins.EndArrayPlugin;
	import com.greensock.plugins.GlowFilterPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.ConvolutionFilter;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author bosworth99
	 */
	public class Outro extends Sprite
	{
		private var _canvas				:Sprite;
		private var _gfx_title			:MovieClip;
		private var _btn_home			:BasicButton;
		private var _btn_ym				:BasicButton;
		private var _gfx_titleLine		:ComplexRoundRect;
		private var _hands				:Bitmap;
		private var _hands_highlight	:Bitmap;
		private var _flame				:CandleFlame;
		
		private var _textBack			:ComplexRoundRect;
		private var _text				:ComplexTextField;
		private var _title				:ComplexTextField;
		private var _contact			:BasicButton;
		private var _prodService		:BasicButton;
		private var _restart			:BasicButton;
		private var _divLine			:Sprite;
		
		private var _stageW				:uint;
		private var _stageH				:uint;
		private var _offset				:Number;
		private var _conArray 			:Array = new Array( -2,-1, 0,	
															-1, 1, 1,
															 0, 1, 2);
										 
//-----------------------------------------------------------------------------
//								constructor
//-----------------------------------------------------------------------------
																	
		public function Outro() 
		{
			super();
			
			if (stage) 
			{
				init();
			}
			else
			{
				this.addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			TweenPlugin.activate([EndArrayPlugin, GlowFilterPlugin, BlurFilterPlugin]);
			
			_stageH = 550;
			_stageW	= 760;
			
			assembleDisplayObject();
			
			animateIn();
		}
		
//-----------------------------------------------------------------------------
//								display objects
//-----------------------------------------------------------------------------
					
		private function assembleDisplayObject():void
		{
			_hands 		= new Bitmap(new Hands(0, 0), "auto", true);
			this.addChild(_hands);

			_hands_highlight 	= new Bitmap(new Hands_highlight(0, 0), "auto", true);	
			with (_hands_highlight) 
			{
				x		= 0;
				y		= 0;
				alpha	= .8
			}
			this.addChild(_hands_highlight);
			
			_flame 		= new CandleFlame();
			_flame.x 	= 375;
			_flame.y 	= 230;
			this.addChild(_flame);
			
			_canvas 	= new Sprite();
			this.addChild(_canvas);
			
			_textBack 	= new ComplexRoundRect(	550, 
												120, 
												20, 
												"linear", 
												[0x000000, 0x000000], 
												[.9, .6], 
												[1, 255], 
												90, 
												2
											);
			with (_textBack) 
			{
				x 		= (_stageW / 2) - (_textBack.width / 2);
				y 		= 400;
			}
			_canvas.addChild(_textBack);
			
			_title		= new ComplexTextField(	"Thanks!", 
												"verdana_title", 
												0xFFFFFF, 
												14, 
												20, 
												100,
												"italic"
												);
			with (_title) 
			{
				x 		= 20;
				y 		= 10;
			}
			//_textBack.addChild(_title);
												
			_text 		= new ComplexTextField("Thanks for spending a few moments with us. Now that you've had a chance to see what we can offer you, your organization, and the people that depend on you, here are a couple links to get you started ~", 
												"verdana_text", 
												0xFFFFFF, 
												11, 
												180, 
												520,
												"italic"
												);
			with (_text) 
			{
				x 		= 20;
				y 		= 20;
			}
			_textBack.addChild(_text);
			
			_restart = new BasicButton("med", "trans", "Restart App");
			with (_restart) 
			{
				x		= _textBack.width - _restart.width - 20;
				y 		= 85;
				name	= "restart";
			}
			_textBack.addChild(_restart);
			
			_contact = new BasicButton("med", "trans", "Contact Us");
			with (_contact) 
			{
				x		= _restart.x - _contact.width - 40;
				y 		= 85;
				name	= "contact";
			}
			_textBack.addChild(_contact);
			
			_prodService = new BasicButton("med", "trans", "Products & Services");
			with (_prodService) 
			{
				x		= _contact.x - _prodService.width - 20;
				y 		= 85;
				name	= "prodService";
			}
			_textBack.addChild(_prodService);
			
			
			_divLine = new Sprite();
			with (_divLine) 
			{
				graphics.lineStyle(2, 0xFFFFFF, .5);
				graphics.moveTo(0, 0);
				graphics.lineTo(0, 18);
				x = _restart.x - 20;
				y = _restart.y + 2;
			}
			_textBack.addChild(_divLine);
			

			//+++++++++++++++++++++ banner
			_gfx_title 			= new GFX_nonprofit_title();
			with (_gfx_title) 
			{
				x 				= 22;
				y				= 18;
				scaleX			= .75;
				scaleY 			= .75;
				mouseEnabled	= false;
			}
			_canvas.addChild(_gfx_title);
			
			_btn_home 			= new BasicButton("small", "trans", "CI Home >");
			with (_btn_home) 
			{
				x 				= 18;
				y				= 2;
				name			= "home";
			}
			_canvas.addChild(_btn_home);
			
			_btn_ym 			= new BasicButton("small", "trans", "Your Market >");
			with (_btn_ym) 
			{
				x 				= 85;
				y				= 2;
				name			= "your market";
			}
			_canvas.addChild(_btn_ym);

			_gfx_titleLine 		= new ComplexRoundRect(	300, 
														2, 
														0,  
														"linear", 
														[0xFFFFFF, 0xFFFFFF, 0xFFFFFF], 
														[0, .6, 0], 
														[1, 40, 255], 
														0, 
														0, 
														0xFFFFFF, 
														0);
			with (_gfx_titleLine) 
			{
				x 				= 0;
				y				= 46;
				mouseEnabled 	= false;
			}
			_canvas.addChild(_gfx_titleLine);
			
			
			var timer:Timer = new Timer(250);
			timer.addEventListener(TimerEvent.TIMER, offset, false, 0, true);
			timer.dispatchEvent( new TimerEvent(TimerEvent.TIMER));
			timer.start();
		}
		
		private function animateIn():void
		{
			
			TweenLite.from(_hands,  			1.0, 	{ delay:0.1, alpha:0 } );
			TweenLite.from(_flame,  			0.2, 	{ delay:0.1, alpha:0 } );
			TweenLite.from(_hands_highlight,  	0.2, 	{ delay:0.6, alpha:0 } );
			
			TweenLite.from(_textBack,  			0.6, 	{ delay:0.8, y:_textBack.y + 20, 	alpha:0, blurFilter: { blurX:10, blurY:10, quality:2, remove:true	}} );
			TweenLite.from(_title,  			0.6, 	{ delay:1.5, x:_title.x + 20, 		alpha:0, blurFilter: { blurX:10, blurY:10, quality:2, remove:true	}} );
			TweenLite.from(_text,  				0.6, 	{ delay:1.7, x:_text.x + 20, 		alpha:0, blurFilter: { blurX:10, blurY:10, quality:2, remove:true	}} );
			
			TweenLite.from(_restart,  			0.6, 	{ delay:1.9, x:_restart.x + 20, 	alpha:0, blurFilter: { blurX:10, blurY:10, quality:2, remove:true	}} );
			TweenLite.from(_contact,  			0.6, 	{ delay:2.0, x:_contact.x + 20, 	alpha:0, blurFilter: { blurX:10, blurY:10, quality:2, remove:true	}} );
			TweenLite.from(_prodService,  		0.6, 	{ delay:2.1, x:_prodService.x + 20, alpha:0, blurFilter: { blurX:10, blurY:10, quality:2, remove:true	}} );
			TweenLite.from(_divLine,  			0.6, 	{ delay:1.9, y:_divLine.y + 20, 	alpha:0, blurFilter: { blurX:10, blurY:10, quality:2, remove:true	}} );

			TweenLite.from(_gfx_titleLine,  	0.6, 	{ delay:2.0, x:_gfx_titleLine.x + 20, 		y:_gfx_titleLine.y, 	alpha:0		} );
			TweenLite.from(_gfx_title,  		0.6, 	{ delay:2.1, x:_gfx_title.x + 20, 			y:_gfx_title.y, 		alpha:0		} );
			TweenLite.from(_btn_home,  			0.6, 	{ delay:2.2, x:_btn_home.x + 20, 			y:_btn_home.y, 			alpha:0		} );
			TweenLite.from(_btn_ym,  			0.6, 	{ delay:2.3, x:_btn_ym.x + 20, 				y:_btn_ym.y, 			alpha:0, onComplete:animateInComplete	} );
			
		}
		
		private function animateInComplete():void
		{
			TweenLite.to(_textBack,  		0.5, 	{ delay:0.1, glowFilter: { color:0xFFFFFF, blurX:20, blurY:20, 	alpha:.5	}} );
			TweenLite.to(_title,  			0.5, 	{ delay:0.3, glowFilter: { color:0xFFFFFF, blurX:5, blurY:5, 	alpha:.5	}} );
			TweenLite.to(_text,  			0.5, 	{ delay:0.5, glowFilter: { color:0xFFFFFF, blurX:5, blurY:5, 	alpha:.5	}} );
			
			addEventHandlers();
		}
		
//-----------------------------------------------------------------------------
//									event listeners  / events
//-----------------------------------------------------------------------------
				
		private function addEventHandlers():void
		{
			this.addEventListener(Event.ENTER_FRAME, flicker, false, 0, true);
			
			_btn_home.addEventListener(MouseEvent.MOUSE_DOWN, 		linkDown, false, 0, true);
			_btn_ym.addEventListener(MouseEvent.MOUSE_DOWN, 		linkDown, false, 0, true);
			_contact.addEventListener(MouseEvent.MOUSE_DOWN, 		linkDown, false, 0, true);
			_restart.addEventListener(MouseEvent.MOUSE_DOWN, 		linkDown, false, 0, true);
			_prodService.addEventListener(MouseEvent.MOUSE_DOWN, 	linkDown, false, 0, true);
			
		}
		
		private function linkDown(e:MouseEvent):void 
		{
			var targetURL:String;
			
			trace(e.target.parent.name);
			switch (e.target.parent.name)
			{
				case "home":
				{
					targetURL = "/";
					break;
				}
				case "your market":
				{
					targetURL = "/_content/your_market/";
					break;
				}
				case "contact":
				{
					targetURL = "/_content/contact_us/";
					break;
				}
				case "prodService":
				{
					targetURL = "/products_and_services/";
					break;
				}
				case "restart":
				{
					targetURL = "/_content/your_market/non-profit.aspx";
					break;
				}
				

			}
			var targetRequest:URLRequest = new URLRequest(targetURL);
			navigateToURL(targetRequest,"_self");
		}
		
		private function offset(e:TimerEvent):void 
		{
			var ranOffset:Number = -((Math.random()* .4)+1.8);
			TweenLite.to(_conArray, .24, { endArray:[ ranOffset,-1, 0,    
															 -1, 1, 1,
															  0, 1, 2
													]} );
		}
		
		private function flicker(e:Event):void 
		{
			_hands_highlight.filters = null;
			var conFilter:ConvolutionFilter = new ConvolutionFilter(3, 3, _conArray, 1, 1, true, true);
			_hands_highlight.filters = [conFilter];
		}

	}
}