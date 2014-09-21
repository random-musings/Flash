

package
{
	import flash.text.TextField;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	public class Menu
	{
		 private  var OUTOFSITE:int = -100;
		 private var menuTitle:String = "Menu";
		 private var items:Array =  new Array( "Welcome ",
											"New Game",
											"Return To Game",
											"Return To Store",
											"Continue Saved Game",
											"Save Game",
											"Quit");
		private var menuLabels:Array;
		public var menuSprite:Sprite;
		private var gunLeft:Sprite;
		private var gunRight:Sprite;
		
		public static const GUNRIGHTID:String="GUNRIGHT";
		public static const GUNLEFTID:String="GUNLEFT";
		
		public var message:String;              //a message that can be displayed
		public var showReturnGame:Boolean;      //inidcate if user can return to game 
		public var showReturnStore:Boolean		//indicate if user can return to store
		public var showSaveQuitGame:Boolean;    //indicate if use can save a game
		public var showContinueGame:Boolean; //indicate if we can continue a saved game
		public var chosenItem:int;				//records the actual click of the item
		public var highlighted:int; 			//records which item has gun bullets
		public var images:EmbedAssets;
		
		public function Menu( )
		{
			//set the starting choices
			menuSprite = new Sprite();
			showReturnStore = false;
			showReturnGame = false;
			showSaveQuitGame = false;
			showContinueGame = false;
			initMenuItems();
		}
		
		//events
		private function clickHandler(event:MouseEvent):void 
		{
			trace("menu.as clickHandler");
			highlighted = GetHighlighted(event);
			chosenItem  =getSelectedAction();
			
		}

		private function mouseMoveHandler(event:MouseEvent):void 
		{
			highlighted = GetHighlighted(event);
			moveGuns(highlighted);
		}		
		
		
		private function moveGuns(menuIndex:int):void
		{
			if(menuIndex>=0 && menuIndex<menuLabels.length)
			{
				var startX:int = settings.menuListingX - gunLeft.width;
				var startY:int = settings.menuListingY;
				var length:int =menuLabels.length;
				var lineHeight:int  = settings.menuFontSize * 1.5;
				for(var i:int=0;i<length;i++)
				{
					if( (i !=GameState.SAVEGAME || showSaveQuitGame)
					   && (i !=GameState.GAMEINPLAY || showReturnGame)
					   && (i !=GameState.GAMEINSTORE || showReturnStore)
					   && (i != GameState.LOADSAVEDGAME || showContinueGame)
					   )
					{
						if(i==menuIndex)
						{
							gunLeft.x =  startX;
							gunLeft.y = startY;
							return;
						}
						startY +=lineHeight;
					}
				}
			}		
		}
		
		private function initMenuItems():void
		{
			reset();
			menuLabels = new Array(items.length);
			
			var length:int =items.length;
			for(var i:int=0;i<length;i++)
			{
				var newMenuItem:TextField = new TextField();
				var menuText:String =  items[i];
				DrawObjects.configureLabel(newMenuItem,
								 settings.standardFont,
								menuText,
								 settings.foregroundColor,
								 settings.menuFontSize);
								 
				menuLabels[i] = newMenuItem;
			}
			
			//Create the menu bullets
			gunLeft = new Sprite();
			gunLeft.name=GUNLEFTID;
			gunLeft.addChild(EmbedAssets.getImage(GameImages.GUNLEFT));
			gunLeft.x = OUTOFSITE;			
			
			gunRight = new Sprite();
			gunLeft.name=GUNRIGHTID;
			gunRight.addChild(EmbedAssets.getImage(GameImages.GUNLEFT));
			gunRight.x = OUTOFSITE;			
			
			drawMenu(menuSprite);
		}
		
		 //change the highlighted item in the menu to the previous entry
		//if their is no previous entry move highlighted entry to last 
		//menu item
		public function highlightPrevious():void
		{
		  highlighted = highlighted<=0?items.length-1:(highlighted-1);   
		  if(highlighted ==GameState.GAMEINPLAY
				  && !showReturnGame)
			  highlightPrevious();
		  if(highlighted ==GameState.SAVEGAME
				  && !showSaveQuitGame)
			  highlightPrevious();      
		}
		
		//change the highlighted item in the menu to the next entry
		//if their is no next entry move highlighted entry to first 
		//menu item
		public function highlightNext():void
		{
		  highlighted = highlighted>=(items.length-1)?0:(highlighted+1);  
		  if(highlighted ==GameState.GAMEINPLAY
				  && !showReturnGame)
			  highlightNext();
		  if(highlighted ==GameState.SAVEGAME
				  && !showSaveQuitGame)
			  highlightNext();
		}
    
    
		//users pressed the fire button figure out what action was selected and return it
		public function getSelectedAction():int
		{
			switch(highlighted)
			{
				case 0: chosenItem = GameState.SHOWMENU; break;
				case 1: chosenItem = GameState.LOADNEWGAME; break;
				case 2: chosenItem = GameState.GAMEINPLAY; break;
				case 3: chosenItem = GameState.GAMEINSTORE; break;
				case 4: chosenItem = GameState.LOADSAVEDGAME; break;
				case 5: chosenItem = GameState.SAVEGAME; break;
				case 6: chosenItem = GameState.QUITGAME; break;
			}
			return chosenItem;
		}
		
		//figure if the mouse is hovering over a menu item
		public function GetHighlighted(mouse:MouseEvent):int
		{
			var index:int =0;
			while(index<menuLabels.length)
			{
				if( (index !=GameState.SAVEGAME || showSaveQuitGame)
                   && (index !=GameState.GAMEINPLAY || showReturnGame)
				   && (index != GameState.GAMEINSTORE || showReturnStore))
                {
					if(		mouse.stageX >= menuLabels[index].x 
						&&  mouse.stageX <= menuLabels[index].x + settings.menuListingWidth
						&&  mouse.stageY >= menuLabels[index].y
						&&  mouse.stageY <= menuLabels[index].y + settings.menuFontSize )
						{					
							return index;
						}
                }
				index++;
			}
			return -1;
		}
		
		//draw the menu
		public function drawMenu(g:Sprite):void
		{
			g.removeChildren();
			g.addChild(gunLeft);

			var startX:int = settings.menuListingX;
			var startY:int = settings.menuListingY;
			var lineHeight:int  = settings.menuFontSize * 1.5;
			removeEvents();
			var length:int =menuLabels.length;
			for(var i:int=0;i<length;i++)
			{
				if( (i !=GameState.SAVEGAME || showSaveQuitGame)
                   && (i !=GameState.GAMEINPLAY || showReturnGame)
				    && (i != GameState.GAMEINSTORE || showReturnStore)
					&& (i != GameState.LOADSAVEDGAME || showContinueGame)
					)
                {
					menuLabels[i].x = startX;
					menuLabels[i].y = startY;
					menuLabels[i].addEventListener(MouseEvent.CLICK, clickHandler,false,0,true);
					menuLabels[i].addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler,false,0,true);
                    g.addChild(menuLabels[i]);
                    startY +=lineHeight;
                }
				
			}
			
		}
		
		public function removeEvents():void
		{
			var length:int=menuLabels.length;
			for(var i:int=0;i<length;i++)
			{
				if(menuLabels[i].hasEventListener(MouseEvent.CLICK))
				{
					menuLabels[i].removeEventListener(MouseEvent.CLICK,clickHandler);
				}
				if(menuLabels[i].hasEventListener(MouseEvent.MOUSE_OVER))
				{
					menuLabels[i].removeEventListener(MouseEvent.MOUSE_OVER,mouseMoveHandler);
				}
			}
		}
		
	
		public function cleanup():void
		{
			removeEvents();
			while(menuLabels.length>0)
			{
				menuLabels.pop();
			}
		}
		
		public function reset():void
		{
			if(gunLeft!=null)
				gunLeft.x =OUTOFSITE;
			if(gunRight!=null)
				gunRight.x = OUTOFSITE
			highlighted=-1;
			chosenItem=-1;
		}
		
		
	
	
	}

}