package{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
public class GameStore
{
	public var gameSprite:StoreSprites;
	public var toolsForSale:Array;
	public var crew:Crew;
	public var leaveStore:Boolean;
	public var gameState:int;
	public var helpMessage:String;
	
	//index to reference tool being bought or sold
	public var tradeCrewIx:int; 
	public var tradeToolIx:int;
	public var tradeToolPrice:int; 
	public var isStoreTool:Boolean; //indicates if tool on trading is from in Store
	
	//HELP MESSAGES
	private var zeroCashMessage:String ="Feel like robbing a bank yet? Click 'rob bank' to exit store.";
	private var maxCarryMessage:String ="You can't carry any more ";
	private var notEnoughMoneyMessage:String = "Not enough cash to buy this item. ";
	private var toolSoldOutMessage:String = "Tool is sold out";
	private var selectToolMessage:String ="Select a tool from the store to buy; Or from a crew member to sell. ";
	private var selectCrewMessage:String ="A crew member must be selected before buying a tool";
	private var welcomeMessage:String ="Welcome to the store. \n "+
								"Buying: Select a tool from the left and crew below. Click 'Buy'. \n"+
								"Selling: Select a tool from a crew member below. Click 'Sell'.\n"+
								"Don't need anything? Click 'rob bank' to exit store.";
	
	public function GameStore()
	{
		tradeCrewIx =-1;
		tradeToolIx = -1;
		tradeToolPrice=0;
		if(toolsForSale==null)
		{
			initStore(null);
		}
		isStoreTool = false;
	}

	public function cleanup():void
	{
		gameSprite.cleanupLevel();
		tradeCrewIx=-1;
		tradeToolIx=-1;
		tradeToolPrice=-1;
		isStoreTool=false;
		helpMessage = welcomeMessage;
		gameState = GameState.GAMEINSTORE;
		
	}
	
	// *****************
	// Store Loop
	// ***************
	
public  function update():void //if verifyAllObject = true then ensure that rooms, 
								//and other stuff have not moved..otherwise just check 
								//people,crews,time,cash,safe hitpoints
{
	
	if(gameSprite == null)
	{	//if this is the first time through create all of the sprites
		gameSprite = new StoreSprites();
		gameSprite.createAllSprites(this);
		gameSprite.createStoreSprite(this);
		helpMessage = welcomeMessage;
	}else
	{		
		gameSprite.createStoreSprite(this);
	}
}			
	
	
// ***********************
//     EVENTS
// ***********************

	//users clicked the 'menu' 
	// game is paused  and the menu is shown
		public function menuClicked(event:MouseEvent):void
		{
			trace("GameStore.as menuClicked");
			gameState = InGameState.SHOWMENU;
		}

		//user clicked 'rob bank' so we leave the store and begin the robbery
		public function leaveClicked(event:MouseEvent):void
		{
			trace("GameStore.as leaveClicked");
			gameState = InGameState.LEAVESTORE;
		}
		
		//
	public function selectToolForSale(event:MouseEvent):void
	{
		trace("handle selectToolForSale");
		var selectedSprite:Sprite = (event.currentTarget as Sprite);
		var spriteIx:Array = selectedSprite.name.split(settings.storeSeparator);
		tradeToolIx =  (spriteIx.length>=2)?spriteIx[1]:-1;
		helpMessage = toolsForSale[tradeToolIx].uses>0?welcomeMessage:toolSoldOutMessage;
		tradeToolIx = (toolsForSale[tradeToolIx].uses!=0)?tradeToolIx:-1;
		isStoreTool = (tradeToolIx>=0);
		if(tradeToolIx>=0)
		{
			tradeToolPrice = toolsForSale[tradeToolIx].cost;
		}
		gameSprite.updateTradingArea(this);
		gameSprite.resetTradeButtons(this);
		gameSprite.updateHelpSprites(this);
		

	}
	
	public function selectCrewMember(event:MouseEvent):void
	{
		trace("handle selectCrewMember");
		helpMessage = welcomeMessage;		
		var selectedSprite:Sprite = (event.currentTarget as Sprite);
		var spriteIx:Array = selectedSprite.name.split(settings.storeSeparator);
		tradeCrewIx = (spriteIx.length>=2)?spriteIx[1]:-1;
		if(!isStoreTool)
		{
			tradeToolIx =  (tradeToolIx>=crew.members[tradeCrewIx].tools.length)?-1:tradeToolIx;
			tradeToolPrice = (tradeToolIx==-1)?0:crew.members[tradeCrewIx].tools[tradeToolIx].cost/2;
		}
		if(tradeToolIx==-1)
		{
			helpMessage=selectToolMessage;
		}
		crew.selectedMember  = tradeCrewIx;
		gameSprite.updateTradingArea(this);
		gameSprite.updateToolSprites(this);
		gameSprite.updateHelpSprites(this);
	}

	public function selectCrewTool(event:MouseEvent):void
	{
		trace("handle selectCrewTool");
		helpMessage = welcomeMessage;		
		var selectedSprite:Sprite = (event.currentTarget as Sprite);
		var spriteIx:Array = selectedSprite.name.split(settings.storeSeparator);
		tradeCrewIx = (spriteIx.length>=3)?spriteIx[1]:-1;
		tradeToolIx = (spriteIx.length>=3)?spriteIx[2]:-1;
		if(tradeToolIx>=0 && tradeCrewIx>=0)
		{
			crew.selectedMember  = tradeCrewIx;
			crew.members[tradeCrewIx].selectTool(tradeToolIx);
			if (crew.members[tradeCrewIx].tools.uses==0)
			{
				tradeToolPrice=0;
			}else
			{
				tradeToolPrice = crew.members[tradeCrewIx].tools[tradeToolIx].cost/2;		
			}
		}
		isStoreTool = false;
		gameSprite.updateTradingArea(this);
		gameSprite.resetTradeButtons(this);		
		gameSprite.updateToolSprites(this);
		gameSprite.updateHelpSprites(this);

	}	
	
	public function buyTool(eventMouse:MouseEvent):void
	{
		trace("handle buyTool");
		helpMessage = welcomeMessage;

		if(isStoreTool)
		{
			if( toolsForSale[tradeToolIx].uses!=0)
			{			
				var newTool:Tool =toolsForSale[tradeToolIx].clone();
				if(crew.members[tradeCrewIx].canCarryTool(newTool,1))
				{				
					if(crew.cash>=newTool.cost)
					{
						if(toolsForSale[tradeToolIx].uses>0)
						{	
							toolsForSale[tradeToolIx].uses = toolsForSale[tradeToolIx].uses-1;
							var allTools:AllTools = new AllTools();
							newTool.uses = (allTools.hasInfiniteUses(newTool.name)?-1:1);
						}
						if(	toolsForSale[tradeToolIx].uses ==0)
						{
							toolsForSale[tradeToolIx].description = "SOLD OUT";
						}

						crew.cash -= tradeToolPrice;
						crew.members[tradeCrewIx].pickupTool(newTool);
						isStoreTool = false;
						tradeToolIx = -1;
						tradeToolPrice = 0;
						gameSprite.updateToolsForSale(this);
						gameSprite.updateTradingArea(this);
						gameSprite.updateCashSprite(this);	
						gameSprite.updateToolSprites(this);					
					}else
					{
						helpMessage = notEnoughMoneyMessage;
					}
				}else
				{
					helpMessage = maxCarryMessage + newTool.name;
				}
			}
		}
		gameSprite.updateHelpSprites(this);
	}
	
	
	public function sellTool(eventMouse:MouseEvent):void
	{
		trace("handle sellTool");
		helpMessage = welcomeMessage;		
		if(!isStoreTool)
		{
			var tmpUses:int=crew.members[tradeCrewIx].tools[tradeToolIx].uses;
			if( tmpUses!=0)
			{			
				crew.members[tradeCrewIx].dropTool(tradeToolIx);
				crew.cash +=tradeToolPrice;
				tradeToolIx=-1;
				tradeToolPrice = 0;
				gameSprite.removeCrewSprite(tradeCrewIx,selectCrewTool);
				gameSprite.updateTradingArea(this);
				gameSprite.updateCashSprite(this);
				gameSprite.updateToolSprites(this);
			}
		}
		gameSprite.updateHelpSprites(this);
	}
	
	
	public function randomizeGameStore():void
	{
		var theTools:AllTools = new AllTools();
		toolsForSale  = new Array(settings.maxToolsPerStore);
		 
		var numTools:int = theTools.toolArray.length;
		var length:int = toolsForSale.length;
		var i:int=0;
		while(i<length)
		{
			var numUses:int = (Math.random()* 100) % settings.maxUses;
			var randTool:int = (Math.random()* 100) % numTools;
			var tmpTool:Tool = theTools.toolArray[randTool];
			if(! toolForSale(tmpTool))
			{
				if(toolsForSale[i] ==null)
				{
					toolsForSale[i]= new Tool();
				}
				toolsForSale[i].copy(tmpTool);
				toolsForSale[i].uses = (numUses+1);
				i++;
			}
		}
		
	
	}
	
	
	public function toolForSale(tool:Tool):Boolean
	{
		var length:int = toolsForSale.length;
		for(var i:int=0;i<length;i++)
		{
			if(toolsForSale[i]!=null)
			{
				if(toolsForSale[i].name == tool.name)
				{
					return true;
				}
			}
		}
		return false;
	}
	
	
	public function getMainSprite():Sprite
	{
		return gameSprite.storeSprite;
	}
	
	
	public function initStore(newCrew:Crew):void
	{
			
		helpMessage = welcomeMessage;
		if (crew == null)
		{
			crew = new Crew();
		}
		crew.copy(newCrew);
	
		randomizeGameStore();
		if(gameSprite==null)
		{
			gameSprite = new StoreSprites();
		}
		gameSprite.reset();
		gameSprite.createAllSprites(this);
		gameState = GameState.GAMEINSTORE;
	
	}
	
	public function serialize():String
	{
		return "";
	}
	
	public function deserialize(data:String):void
	{
	
	}
}


}