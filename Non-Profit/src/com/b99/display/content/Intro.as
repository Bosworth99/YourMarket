///////////////////////////////////////////////////////////////////////////////
//
//	com>b99>display>content>Intro.as
//
//	extends : sprite
//
//	Introduction scene
//	Launch external load of main content
//
///////////////////////////////////////////////////////////////////////////////

package com.b99.display.content 
{
	import com.b99.composite.BasicButton;
	import com.b99.composite.intro.Campfire;
	import com.b99.element.ComplexRoundRect;
	import com.b99.element.ComplexTextField;
	import com.greensock.plugins.BlurFilterPlugin;
	import com.greensock.plugins.GlowFilterPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.filters.BlurFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author bosworth99
	 */
	public class Intro extends Sprite
	{
		
		private var _canvas 			:Sprite;
		private var _campfire			:Campfire;
		
		private var _gfx_logo			:MovieClip;
		
		private var _gfx_title			:MovieClip;
		private var _gfx_titleLine		:ComplexRoundRect;
		private var _gfx_redbar			:ComplexRoundRect;
		private var _gfx_blackbar		:ComplexRoundRect;	
		private var _gfx_text_backer	:ComplexRoundRect;
		
		private var _gfx_ring1			:ComplexRoundRect;
		private var _gfx_ring2			:ComplexRoundRect;
		
		private var _loadRing			:MovieClip;
		
		//++++++++++++++++++++++++++++++ textfield
		private var _title_nonProfit	:ComplexTextField;
		private var _title_organize		:ComplexTextField;
		private var _title_yMarket		:ComplexTextField;
		private var _text_introcopy		:ComplexTextField;
		private var _text_blackbar		:ComplexTextField;
		
		//++++++++++++++++++++++++++++++ clickables
		private var _btn_home			:BasicButton;
		private var _btn_ym				:BasicButton;
		private var _start				:BasicButton;	

		//++++++++++++++++++++++++++++++ filters
		private var _blurFilter			:BlurFilter = new BlurFilter(30, 30, 1);
		private var _glowFilter			:GlowFilter	= new GlowFilter(0xFFFFFF, .4, 6, 6, 2);
		
		private var _stageW				:int;
		private var _stageH				:int;
		
//-----------------------------------------------------------------------------
//	constructor
//-----------------------------------------------------------------------------
		
		public function Intro() 
		{
			super();
			
			if (stage) 
			{
				init();
			}
			else
			{
				this.addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
			}
		}
		
		private function init(e:Event = null):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			_stageW = 760;
			_stageH = 550;
			
			TweenPlugin.activate([GlowFilterPlugin, BlurFilterPlugin ]);

			this.scrollRect = new Rectangle(0, 0, _stageW, _stageH);
				
			assembleDisplayObjects();
			animateIn();
		}
	
//-----------------------------------------------------------------------------
//							display objects
//-----------------------------------------------------------------------------		
		
		private function assembleDisplayObjects():void
		{
			_canvas 	= new Sprite();
			this.addChild(_canvas);
			
			_campfire	= new Campfire();
			_canvas.addChild(_campfire);
			
			_gfx_redbar 		= new ComplexRoundRect(	_stageW + 10, 
														130, 
														0, 
														"linear", 
														[0x7e2c1b], 
														[1], 
														[1], 
														270, 
														3, 
														0xFFFFFF, 
														1);
			with (_gfx_redbar) 
			{
				x 				= -5;
				y 				= _stageH - (_gfx_redbar.height - 5 );
			}
			_canvas.addChild(_gfx_redbar);
			
			_gfx_blackbar 		= new ComplexRoundRect(	450, 
														80, 
														40, 
														"linear", 
														[0x000000], 
														[1], 
														[1], 
														270, 
														1, 
														0xFFFFFF, 
														0);
			with (_gfx_blackbar) 
			{
				x 				= _stageW - 250;
				y 				= _stageH - 50;
			}
			_canvas.addChild(_gfx_blackbar);
			
			_text_blackbar		= new ComplexTextField(	"Products and Services", 
														"verdana_title", 
														0xFFFFFF, 
														16, 
														0, 
														0, 
														"bold");
			with (_text_blackbar) 
			{
				x = 30;
				y = 8;
			}
			_text_blackbar.filters = [_glowFilter];
			_gfx_blackbar.addChild(_text_blackbar);
			
			_gfx_ring1 			= new ComplexRoundRect(	450, 
														450, 
														450, 
														"linear", 
														[0x000000], 
														[0], 
														[1], 
														270, 
														2, 
														0xFFFFFF, 
														.9);
			with (_gfx_ring1) 
			{
				x 				= -275;
				y 				= 345;
			}
			_gfx_ring1.filters 	= [_glowFilter];
			_gfx_ring1.mouseEnabled 	= false;
			_canvas.addChild(_gfx_ring1);
			
			_gfx_ring2 			= new ComplexRoundRect( 450, 
														450, 
														450,  
														"linear", 
														[0x000000], 
														[0], 
														[1], 
														270, 
														2, 
														0xFFFFFF, 
														.7);
			with (_gfx_ring2) 
			{
				x 				= -245;
				y 				= 370
				;
			}
			_gfx_ring2.filters 	= [_glowFilter];
			_gfx_ring2.mouseEnabled 	= false;
			_canvas.addChild(_gfx_ring2);
			
			_gfx_logo			= new GFX_intro_logo();
			with (_gfx_logo)
			{
				x 				= 80;
				y 				= _stageH - 65;
				scaleX			= .22;
				scaleY			= .22;
			}
			_gfx_logo.filters = [_glowFilter];
			_canvas.addChild(_gfx_logo);
			
			_title_nonProfit 	 = new ComplexTextField(
														"NON-PROFIT", 
														"verdana_title", 
														0xFFFFFF, 
														24, 
														0, 
														0, 
														"bold");
			with (_title_nonProfit)
			{
				x 				= 200;
				y 				= _stageH - 110;
			}
			_title_nonProfit.filters = [_glowFilter];
			_canvas.addChild(_title_nonProfit);
			
			_title_organize 	 = new ComplexTextField(
														"ORGANIZATIONS", 
														"verdana_title", 
														0xFFFFFF, 
														24, 
														0, 
														0, 
														"bold");
			with (_title_organize)
			{
				x 				= 200;
				y 				= _title_nonProfit.y + 30;
			}
			_title_organize.filters = [_glowFilter];
			_canvas.addChild(_title_organize);
			
			_title_yMarket		= new ComplexTextField(	"YOUR MARKET", 
														"verdana_title", 
														0xFFFFFF, 
														14, 
														0, 
														0, 
														"bold");
			with (_title_yMarket)
			{
				x 				= 200;
				y 				= _title_organize.y + 40;
			}
			_title_yMarket.filters = [_glowFilter];
			_canvas.addChild(_title_yMarket);
			
			
			
			//++++++++++++++++++++  copy bar
			
			_gfx_text_backer 	= new ComplexRoundRect( 400, 
														125, 
														25,  
														"linear", 
														[0xFFFFFF, 0xFFFFFF], 
														[.6, .1], 
														[1, 255], 
														180, 
														0, 
														0xFFFFFF, 
														0);
			with (_gfx_text_backer) 
			{
				x				= _stageW - 220;
				y				= 250;
			}
			_gfx_text_backer.filters  		= [new BlurFilter(15, 15, 2)]
			_gfx_text_backer.mouseEnabled	= false;
			_canvas.addChild(_gfx_text_backer);
			
			_text_introcopy		= new ComplexTextField(	"Promotional Items, Garments, Embroidery, Food, Screen Printing, Furniture and more...", 
														"verdana_text", 
														0xffffff, 
														12, 
														250, 
														150);
			with (_text_introcopy) 
			{
				x 				= _gfx_text_backer.x + 25;
				y 				= _gfx_text_backer.y + 20;
			}
			_text_introcopy.filters = [new GlowFilter(0x000000, .3, 6, 6, 2)];
			_canvas.addChild(_text_introcopy);
			
			
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
			

			_start = new BasicButton("large", "dark", "start", "verdana_title", "italic");
			with (_start) 
			{
				x = _stageW - 100;
				y = _stageH - 100;
			}
			_canvas.addChild(_start);
		}
		
		private function animateIn():void
		{			
			TweenLite.from(_campfire,  			1.0, 	{ delay:0.1, x:_campfire.x, 				y:_campfire.y, 			alpha:0		} );
			TweenLite.from(_gfx_redbar,  		0.6, 	{ delay:0.4, x:_gfx_redbar.x, 				y:_gfx_redbar.y + 10, 	alpha:0		} );
			TweenLite.from(_gfx_blackbar,  		0.6, 	{ delay:1.0, x:_gfx_blackbar.x + 100, 		y:_gfx_blackbar.y, 		alpha:0		} );
			TweenLite.from(_gfx_logo,  			1.2,	{ delay:0.8, x:_gfx_logo.x, 				y:_gfx_logo.y, 			alpha:0,	blurFilter:{blurX:20, blurY:10, remove:true}, scaleX:.2, scaleY:.2} );
			TweenLite.from(_title_nonProfit,	0.8, 	{ delay:0.9, x:_title_nonProfit.x + 30, 	y:_title_nonProfit.y, 	alpha:0,	blurFilter:{blurX:20, blurY:10, remove:true}} );
			TweenLite.from(_title_organize, 	0.8, 	{ delay:1.0, x:_title_organize.x + 30, 		y:_title_organize.y, 	alpha:0,	blurFilter:{blurX:20, blurY:10, remove:true}} );
			TweenLite.from(_title_yMarket,  	0.8, 	{ delay:1.1, x:_title_yMarket.x + 30, 		y:_title_yMarket.y, 	alpha:0,	blurFilter:{blurX:20, blurY:10, remove:true}} );
			TweenLite.from(_gfx_ring1,  		0.6, 	{ delay:1.5, x:_gfx_ring1.x + 50, 			y:_gfx_ring1.y, 		alpha:0		} );
			TweenLite.from(_gfx_ring2,  		0.6, 	{ delay:1.7, x:_gfx_ring2.x + 50, 			y:_gfx_ring2.y, 		alpha:0		} );
			TweenLite.from(_text_blackbar,  	0.6,	{ delay:1.5, x:_text_blackbar.x + 20, 		y:_text_blackbar.y, 	alpha:0,	blurFilter:{blurX:20, blurY:10, remove:true}} );
			TweenLite.from(_gfx_text_backer,	1.0, 	{ delay:1.5, x:_gfx_text_backer.x + 50, 	y:_gfx_text_backer.y, 	alpha:0		} );
			TweenLite.from(_text_introcopy, 	1.0, 	{ delay:1.6, x:_text_introcopy.x, 			y:_text_introcopy.y, 	alpha:0,	blurFilter:{blurX:20, blurY:10, remove:true}} );
			TweenLite.from(_gfx_titleLine,  	0.6, 	{ delay:1.8, x:_gfx_titleLine.x + 20, 		y:_gfx_titleLine.y, 	alpha:0		} );
			TweenLite.from(_gfx_title,  		0.6, 	{ delay:2.0, x:_gfx_title.x + 20, 			y:_gfx_title.y, 		alpha:0		} );
			TweenLite.from(_btn_home,  			0.6, 	{ delay:2.0, x:_btn_home.x + 20, 			y:_btn_home.y, 			alpha:0		} );
			TweenLite.from(_btn_ym,  			0.6, 	{ delay:2.0, x:_btn_ym.x + 20, 				y:_btn_ym.y, 			alpha:0		} );
			TweenLite.from(_start,  			0.5, 	{ delay:2.0, x:_start.x, 					y:_start.y, 			alpha:0, onComplete:animateInComplete} );	
		}
		
		private function animateInComplete():void
		{
			addEventHandlers();
		}
//-----------------------------------------------------------------------------
//							eventHandlers
//-----------------------------------------------------------------------------			
		
		
		private function addEventHandlers():void
		{
			_start.addEventListener(MouseEvent.MOUSE_DOWN, startDown, false, 0, true);
			
			_btn_home.addEventListener(MouseEvent.MOUSE_DOWN, linkDown, false, 0, true);
			_btn_ym.addEventListener(MouseEvent.MOUSE_DOWN, linkDown, false, 0, true);
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
			}
			var targetRequest:URLRequest = new URLRequest(targetURL);
			navigateToURL(targetRequest,"_self");
		}
		
		
		private function startDown(e:MouseEvent):void 
		{
			_start.removeEventListener(MouseEvent.MOUSE_DOWN, startDown);
			_btn_home.removeEventListener(MouseEvent.MOUSE_DOWN, linkDown);
			_btn_ym.removeEventListener(MouseEvent.MOUSE_DOWN, linkDown);
			
			animateOut();
		}
		
//-----------------------------------------------------------------------------
//							animate out
//-----------------------------------------------------------------------------			

		
		private function animateOut():void
		{
			TweenLite.to(_campfire,  		0.6, 	{ delay:1.1, x:_campfire.x, 				y:_campfire.y, 			alpha:0, 	onComplete:destroy	} );
			TweenLite.to(_gfx_redbar,  		0.3, 	{ delay:1.4, x:_gfx_redbar.x, 				y:_gfx_redbar.y, 		alpha:0		} );
			TweenLite.to(_gfx_blackbar,  	0.3, 	{ delay:1.3, x:_gfx_blackbar.x - 50, 		y:_gfx_blackbar.y, 		alpha:0		} );
			TweenLite.to(_gfx_logo,  		0.3,	{ delay:1.2, x:_gfx_logo.x, 				y:_gfx_logo.y, 			alpha:0,	blurFilter:{blurX:20, blurY:10, remove:true}, scaleX:.5, scaleY:.5} );
			TweenLite.to(_title_nonProfit,	0.3, 	{ delay:1.0, x:_title_nonProfit.x + 20, 	y:_title_nonProfit.y, 	alpha:0,	blurFilter:{blurX:20, blurY:10, remove:true}} );
			TweenLite.to(_title_organize, 	0.3, 	{ delay:0.9, x:_title_organize.x + 20, 		y:_title_organize.y, 	alpha:0,	blurFilter:{blurX:20, blurY:10, remove:true}} );
			TweenLite.to(_title_yMarket,  	0.3, 	{ delay:0.8, x:_title_yMarket.x + 20, 		y:_title_yMarket.y, 	alpha:0,	blurFilter:{blurX:20, blurY:10, remove:true}} );
			TweenLite.to(_gfx_ring1,  		0.3, 	{ delay:0.6, x:_gfx_ring1.x + 150, 			y:_gfx_ring1.y, 		alpha:0		} );
			TweenLite.to(_gfx_ring2,  		0.3, 	{ delay:0.5, x:_gfx_ring2.x + 150, 			y:_gfx_ring2.y, 		alpha:0		} );
			TweenLite.to(_text_blackbar,  	0.3,	{ delay:0.5, x:_text_blackbar.x + 20, 		y:_text_blackbar.y, 	alpha:0,	blurFilter:{blurX:20, blurY:10, remove:true}} );
			TweenLite.to(_gfx_text_backer,	0.3, 	{ delay:0.4, x:_gfx_text_backer.x + 50, 	y:_gfx_text_backer.y, 	alpha:0		} );
			TweenLite.to(_text_introcopy, 	0.3, 	{ delay:0.4, x:_text_introcopy.x, 			y:_text_introcopy.y, 	alpha:0,	blurFilter:{blurX:20, blurY:10, remove:true}} );
			TweenLite.to(_gfx_titleLine,  	0.3, 	{ delay:0.3, x:_gfx_titleLine.x + 20, 		y:_gfx_titleLine.y, 	alpha:0		} );
			TweenLite.to(_gfx_title,  		0.3, 	{ delay:0.2, x:_gfx_title.x + 20, 			y:_gfx_title.y, 		alpha:0		} );
			TweenLite.to(_btn_home,  		0.3, 	{ delay:0.2, x:_btn_home.x + 20, 			y:_btn_home.y, 			alpha:0		} );
			TweenLite.to(_btn_ym,  			0.3, 	{ delay:0.2, x:_btn_ym.x + 20, 				y:_btn_ym.y, 			alpha:0		} );
			
			_start.x = _stageW + 100;
		}

		
//-----------------------------------------------------------------------------
//							destroy
//-----------------------------------------------------------------------------	

		public function destroy():void
		{
			
			_campfire.destroy(); //destroy();
			_campfire 			= null;
			
			_gfx_redbar.destroy();
			_gfx_redbar 		= null;
			
			_gfx_blackbar.destroy();
			_gfx_blackbar 		= null;
			
			removeMe(_gfx_logo);
			_gfx_logo			= null;
			
			removeMe(_title_nonProfit);
			_title_nonProfit	= null;
			
			_title_organize.destroy()
			_title_organize		= null;
			
			_title_yMarket.destroy();
			_title_yMarket		= null;
			
			_gfx_ring1.destroy();
			_gfx_ring1			= null;
			
			_gfx_ring2.destroy();
			_gfx_ring2			= null;
			
			_text_blackbar.destroy();
			_text_blackbar		= null;
			
			_gfx_text_backer.destroy();
			_gfx_text_backer	= null;
			
			_text_introcopy.destroy();
			_text_introcopy		= null;
			
			_gfx_titleLine.destroy();
			_gfx_titleLine		= null;
			
			removeMe(_gfx_title);
			_gfx_title			= null;
			
			_btn_home.destroy();
			_btn_home			= null;
			
			_btn_ym.destroy();
			_btn_ym				= null;
			
			_start.destroy();
			_start				= null;
			
			removeMe(_canvas);
			_canvas = null;
			
			
			ExternalInterface.call("waCI.nonProfit.activateNavigation");
		}
		
		private function removeMe(obj:DisplayObject):void
		{
			obj.parent.removeChild(obj);
		}
	}
}