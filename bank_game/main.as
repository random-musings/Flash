package {
	import flash.system.ImageDecodingPolicy;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.Graphics;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.text.TextFormat;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.AntiAliasType;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.system.fscommand;
	
	public class main extends Sprite {
		
		//embeds resources into the SWF file at compile time
		private var resources:EmbedAssets;
		
		//the main backdrop 
		private var mainScreen:MainScreen;
		private var menu:Menu;
		
		//sprites
		private var backdrop:Sprite;

		//Game Loop Timer
		private var timer:Timer;
				
		//GameStates
		private var gameState:int;
		
		//current game level
		private var gameLevel:GameLevel;
		
		//current gameStore
		private var gameStore:GameStore;
		
		//indicates all levels have been finished
		private var gameCompleted:TextField;
		
		
		// **********************
		// The initialization/Constructor
		// **********************
		
		public function main()
		{
			//stage.loaderContext.imageDecodePolicy = ImageDecodingPolicy.ON_LOAD;
			resources = new EmbedAssets();

			//init sprites
			backdrop = new Sprite();
			
			mainScreen = new MainScreen();
			mainScreen.drawMainStage(backdrop); //load the main stage so it will not change
			menu = new Menu();
			
			//Stage settings
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;

			//Set starting Game STATE
			gameState = GameState.SHOWMENU;
			
			//create a gameLevel object that can hold any game levels
			gameLevel = AllLevels.getLevel(1,gameLevel);
			
			//create the store that will be visited 
			gameStore = new GameStore();
			
			//setup & start timer events
			timer = new Timer(settings.ticksPerFrame,1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE,updateGame);
			timer.start();
			
		}
		
		
		// ********************
		// The main game loop
		// ********************
		public function updateGame(e:TimerEvent):void
		{
			//cear all items from the main sprite
			graphics.clear();
			
			//check for game state changes
			handleEvents();
			
			//add the main graphics elements of the game
			this.addChild(backdrop); //the static main screen

			//based on the game state decide what needs to be processed
			switch(gameState)
			{
			 case GameState.SHOWTUTORIAL: doNothing(); break;
			 case GameState.LOADNEWGAME: loadLevel(1); break;
			 case GameState.GAMEINPLAY: manageGame(); break;
			 case GameState.GAMEINSTORE: manageStore(); break;
			 case GameState.LOADSAVEDGAME: doNothing(); break;
			 case GameState.SAVEGAME: doNothing(); break;
			 case GameState.QUITGAME: doNothing(); break;
			 case GameState.GAMECOMPLETED: showEndGame();break;

	 		 default: showMenu(); break;
			}
			
			//reset our timer so that it will be called again
			timer.reset();
			timer.start();
			
		}
		
		
		//this function is a place holder for 
		//the switch events so that Game States can be filled in later
		public function doNothing():void
		{
		}
		
		
		//addss the main game menu to the main sprite
		//called by updateGame()
		//				manageGame()  when game is paused
		//				manageStore() when menu button is clicked in store
		public function showMenu():void
		{
			this.addChild(menu.menuSprite);
		}
		
		
		// ************************
		// Manage In Bank Game Play
		// ************************
		//this is the main game loop  while the player is
		//trying to rob the bank
		public function manageGame():void
		{
			if(gameLevel!=null)
			{
				
				//the the user clicked on the menu button from within the game
				//the game is paused an the menu isshow
				if(gameLevel.gameState == InGameState.SHOWMENU
				|| gameLevel.gameState ==InGameState.PAUSED)
				{
	
					gameLevel.gameState =InGameState.PAUSED;
					menu.reset();
					menu.showReturnGame =  true;
					menu.showReturnStore = false;
					menu.showSaveQuitGame = false; //saving has not yet been implemented
					menu.reset();
					menu.drawMenu(menu.menuSprite);
					showMenu();
					gameState = GameState.SHOWMENU;

					//detect chosen menu item //if it is quit, return to game, save game, load new game
				}else if(gameLevel.gameState ==InGameState.LOADNEXTLEVEL)
				{
					//if the player finished the level by either fleeing the bank or openeing the bank safe
					//drop all items that have zero uses left
					gameLevel.crew.dropUsedItems();

					if(gameLevel.id <AllLevels.maxLevel )
					{
						//copy the game level crew into the store and initialize Store Items
						gameStore.initStore(gameLevel.crew);
						//set the flag that will result in the gamestore being shown to the member
						gameState = GameState.GAMEINSTORE;						
					}else
					{
						menu.showReturnGame =  false;
						menu.showReturnStore = false;
						menu.reset();
						menu.drawMenu(menu.menuSprite);
						gameState = GameState.GAMECOMPLETED;
					}
					
				}else if ( gameLevel.gameState ==InGameState.ENDLEVELFAILURE && gameLevel.endLevel) 
				{	//game ended because vault wasn't opened or user  failed to pay crew  ransom demands
					gameState = GameState.SHOWMENU;
					menu.reset();
					menu.showReturnGame =  false;
					menu.showReturnStore = false;
					menu.showSaveQuitGame = false;

				}else if(gameState == GameState.GAMEINPLAY)
				{
					//player is currently trying to open the safe
					//advance characters in the bank and update the game sprite
					gameLevel.update();		

					//add the sprite to the stage
					addChild(gameLevel.getMainSprite());
				}
				
			}
		}
		
		// ************************
		// Manage In Store Game Play
		// ************************
		public function manageStore():void
		{
				//player is in store buying tools/weapons for next round
				gameStore.update();
				if(gameStore.gameState == InGameState.SHOWMENU)
				{
					//indicate what 
					menu.showReturnGame =  false;
					menu.showReturnStore =true;
					menu.showSaveQuitGame = false;		
					menu.reset();
					menu.drawMenu(menu.menuSprite);
					showMenu();
					gameState = GameState.SHOWMENU;
				}
				else if(gameStore.gameState == InGameState.LEAVESTORE)
				{
						//player chooses to leave store and orb bank
						///copy the crew from the store (and all their shiny new weapons into the game level)
						gameLevel.crew.copy(gameStore.crew);
						
						//load the next level in the game
						loadLevel(gameLevel.id+1);
						
						//	reset the  state so that the end of the next level will take us back there	
						gameStore.gameState  = GameState.GAMEINSTORE;

				}else  if(gameState == GameState.GAMEINSTORE)
				{			
					//player is in store show the player all of the wepons this store has to offer
					addChild(gameStore.getMainSprite());
				}
		}
		
		
		
		// ************************
		// Show End Game
		// ************************
		public function showEndGame():void
		{
			showMenu();
			if(gameCompleted==null)
			{
				gameCompleted = new TextField();
				gameCompleted = DrawObjects.configureLabel(gameCompleted,
								 settings.titleFont,
								"Game Completed",
								 settings.foregroundColor,
								 settings.titleFontSize);
				gameCompleted.x = settings.bankX;
				gameCompleted.y = settings.bankY;
			}
			addChild(gameCompleted);
		}
		
		
		
		// *********************
		//  Game State Change
		// ********************* 
		//checks when the game state changes. unloads the current game state
		//loads the new game state... performs any cleanup or initialization
		// called by manageGame() when the 'menu' is clicked
		// called by the manageStore() when the 'menu' is clicked, 
		//						when the safe id opened and the level is broken into , 
		//						when the flee button is pressed
		public function handleEvents():void
		{
			
			var changedGameState:int = gameState;
			switch(gameState)
			{
			
			 case GameState.LOADNEWGAME: doNothing(); break;
			 case GameState.GAMEINPLAY: doNothing(); break;
			 case GameState.LOADSAVEDGAME: doNothing(); break;
			 case GameState.SAVEGAME: doNothing(); break;
			 case GameState.QUITGAME: fscommand("quit");; break;
			 case GameState.GAMEINSTORE: doNothing(); break;
	 		 default:  //Show Menu determine if a choice has been made
					changedGameState = menu.chosenItem>=0? menu.chosenItem: gameState;
					break;
			}
			
			//the game State changed 
			//cleanup the old game state
			//initialize the new Game State
			if(changedGameState!=gameState && changedGameState>-1)
			{
				initNewGameState(changedGameState);
				cleanupOldGameState(gameState);
				gameState = changedGameState;
			}
			
		}
		
		// initializes the new game state if required
		private function initNewGameState(newState:int):void
		{
			switch(newState)
			{
			
			 case GameState.LOADNEWGAME: 	loadLevel(1); break;
			 case GameState.GAMEINPLAY: 	gameLevel.resumePlay(); break; //will resume the game play if pause 
			 case GameState.LOADSAVEDGAME: 	doNothing(); break;
			 case GameState.SAVEGAME: 		doNothing(); break;
			 case GameState.QUITGAME: 		doNothing(); break;
			 case GameState.GAMEINSTORE:  	gameStore.initStore(gameLevel.crew); break; //will randomly assign tools to the game store
			 case GameState.GAMECOMPLETED: doNothing();break;
	 		 default:  //Show Menu
					menu.reset();
					menu.drawMenu(menu.menuSprite);
					break;
			}
		}
		
		
		//cleanups the old game state
		//destroys and resets any levels
		private function cleanupOldGameState(oldState:int):void
		{
			trace("main.as in cleanupOldGameState");
			switch(gameState)
			{
			
			 case GameState.LOADNEWGAME: 	doNothing(); break;
			 case GameState.GAMEINPLAY: 	doNothing(); break;
			 case GameState.LOADSAVEDGAME: 	doNothing(); break;
			 case GameState.SAVEGAME: 		doNothing(); break;
			 case GameState.QUITGAME: 		doNothing(); break;
			 case GameState.GAMEINSTORE: 	doNothing(); break;
	 		 default:  //Show Menu
					menu.reset()
					break;
			}		
		}
		
		
		//loads the requested level into the gameLevel so it can be played
		private function loadLevel(leveId:int):void
		{
			trace("main.as in loadLevel");
			gameLevel = AllLevels.getLevel(leveId,gameLevel);
			if(gameLevel!=null)
			{
				trace("main.as loadlevle() resetGameSprite");
				gameLevel.start();
				gameState = GameState.GAMEINPLAY;
				
			}else
			{	//we ended the game
				gameState = GameState.GAMECOMPLETED;
			
			}
		}
		
	}
		
}