package
{
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	
	public class StoreSprites
	{
		public var storeSprite:Sprite; //main sprite
		
		private var eventManager:EventManager;
		
		//Title
		public var storeName:TextField;
		
		//Sprite to show List of available tools
		public var toolsForSaleTitle:TextField;
		public var toolsForSale:Array;	
		public var toolsForSaleUses:Array;	
		public var toolsForSaleDesc:Array;
		
		//menu sprite
		public var menuSpriteText:TextField;
		public var leaveSpriteText:TextField;
		public var leaveSprite:Sprite;
		
		//Cash on hand
		public var cashSprite:Sprite;
		public var cashSpriteText:TextField;

		//buying and trading area
		public var tradeToolSprite:Sprite;
		public var tradeToolCrew:Sprite;
		public var tradeToolCost:TextField;
		public var tradeToolDesc:TextField;
		
		public var unknownTradeTool:TextField;
		public var unknownTradeCrew:TextField;
		
		//Sprites to display Crew & Weapons
		public var crewSprites:Array; //all crewMembers
		public var toolSprites:Array;
		public var toolSelectionSprites:Array;
		public var toolUsesSprites:Array;

		//sprites to act as buttons
		public var buyButton:Sprite;
		public var sellButton:Sprite;
		public var negotiateButton:Sprite;
		public var negotiateText:TextField;
		public var sellText:TextField;
		public var buyText:TextField;
	
	
		//help 
		public var messageText:TextField;
		public var helpSprite:TextField;
		
		
		public function StoreSprites()
		{	
			eventManager = new EventManager();
			crewSprites = new Array(AllLevels.maxCrewCount);	
			toolSelectionSprites = new Array(AllLevels.maxToolsPerPersonCount * AllLevels.maxCrewCount) ;
			toolSprites = new Array(AllLevels.maxToolsPerPersonCount * AllLevels.maxCrewCount) ;
			toolUsesSprites = new Array(AllLevels.maxToolsPerPersonCount * AllLevels.maxCrewCount) ;
			toolsForSaleDesc = new Array(AllLevels.maxToolsPerPersonCount * AllLevels.maxCrewCount);
			toolsForSale = new Array(settings.maxToolsPerStore);
			toolsForSaleUses = new Array(settings.maxToolsPerStore);
		}
		
		public function createAllSprites( gameStore:GameStore):void
		{
			if(storeSprite==null)
			{	
				storeSprite = new Sprite();
			}	
			if(gameStore !=null)
			{
				updateStoreName();
				updateToolsForSale(gameStore);
				updateTradingArea(gameStore);
				updateCashSprite(gameStore);
				resetMenu(gameStore);
				resetLeaveStore(gameStore);
				resetTradeButtons(gameStore);
				updateToolSprites(gameStore);
				updateHelpSprites(gameStore);
			}
		}
		
		public function createStoreSprite(gameStore:GameStore):void
		{
			if(storeSprite==null)
			{	
				storeSprite = new Sprite();
			}	
			storeSprite.removeChildren();

			var i:int =0;
			var length:int =toolsForSale.length;
			length  =toolsForSale.length	
			for(i=0;i<length;i++)
			{
				storeSprite.addChild(toolsForSale[i]);
				storeSprite.addChild(toolsForSaleUses[i]);
			}
			storeSprite.addChild(toolsForSaleTitle);
			
			//the store name
			storeSprite.addChild(storeName);
			
			//menu sprite
			storeSprite.addChild(menuSpriteText);
			storeSprite.addChild(leaveSprite);
			storeSprite.addChild(leaveSpriteText);
			
			
			//Cash on hand
			storeSprite.addChild(cashSprite);

			//buying and trading area
			storeSprite.addChild(tradeToolCrew);
			storeSprite.addChild(tradeToolCost);
			storeSprite.addChild(tradeToolSprite);
			storeSprite.addChild(tradeToolDesc);
			
			//sprites to act as buttons
			if(gameStore.tradeToolIx!=-1 && gameStore.tradeCrewIx!=-1)
			{
				if(gameStore.isStoreTool)
				{
					storeSprite.addChild(buyButton);
				}else
				{
					if(gameStore.tradeToolIx!=-1)
					{
						storeSprite.addChild(sellButton);
					}
				}
			}
			
			//storeSprite.addChild(negotiateButton);
	
			
			
			//Sprites to display Crew & Weapons
			length = crewSprites.length;
			for(i=0;i<length;i++)
			{
				if(crewSprites[i]!=null)
				{
						storeSprite.addChild(crewSprites[i]);
				}
			}
			
			length = toolSprites.length;
			for(i=0;i<length;i++)
			{
				if(toolSprites[i]!=null)
				{
						storeSprite.addChild(toolSprites[i]);
				}
			}
	
		//help 
		if(messageText!=null)
		{
			storeSprite.addChild(messageText);
		}
		if(helpSprite!=null)
		{
			storeSprite.addChild(helpSprite);
		}
		
	}
	
	// ********************************
	//  Tools For sale (Left Side Bar)
	// ********************************
	
	public function updateToolsForSale(gameStore:GameStore):void
	{
		if(toolsForSale==null)
		{
			toolsForSale = new Array();		
			toolsForSaleUses = new Array();
			toolsForSaleDesc = new Array();
		}
		if(toolsForSaleTitle==null)
		{
			toolsForSaleTitle = new TextField();
			toolsForSaleTitle = DrawObjects.configureLabel(toolsForSaleTitle,
												 settings.standardFont,
												 settings.toolsForSaleText,
												 settings.foregroundColor,
												 settings.menuFontSize);
			toolsForSaleTitle.y = settings.storeSellToolsTitleY;
			toolsForSaleTitle.x = settings.storeSellToolsTitleX;		
		}
		var toolsForSaleCount:int = gameStore.toolsForSale.length;
		var currentY:int = settings.storeSellToolsY;
		for(var i:int=0;i<toolsForSaleCount;i++)
		{
			if(gameStore.toolsForSale[i]!=null)
			{
				if(toolsForSale[i]==null || toolsForSaleUses[i]==null)
				{
					var toolSprite:Sprite = new Sprite();
					var toolImage:Sprite = new Sprite();
					var usesTextField:TextField = new TextField();
					var costTextField:TextField = new TextField();

					//Sets the number of uses for the tool
					usesTextField.name= getToolStoreUsesSpriteId(i);
					usesTextField.x = 20;
					usesTextField.y = currentY;
					usesTextField.mouseEnabled= false;
					
					toolImage = DrawObjects.drawTool(toolImage,usesTextField,null,gameStore.toolsForSale[i]);
					toolImage.x = 5;
					toolImage.y = 0;
					toolImage.name = "Img"+getToolSpriteId(i);	
					toolImage.mouseEnabled = false;
					
					//Tool For Sale Description Label
					var descTextField:TextField = new TextField();
					descTextField = DrawObjects.configureLabel(descTextField,
												 settings.standardFont,
												 gameStore.toolsForSale[i].description,
												 settings.foregroundColor,
												 settings.toolFontSize);
					descTextField.x = settings.storeSellToolsDescX;
					descTextField.y = settings.toolFontSize;
					descTextField.wordWrap = true;
					descTextField.multiline = true;
					descTextField.width  = settings.sellDescriptionWidth;

					//Tool For Sale Cost Label
					costTextField =  DrawObjects.configureLabel(costTextField,
												 settings.standardFont,
												 "$"+gameStore.toolsForSale[i].cost,
												 settings.foregroundColor,
												 settings.toolFontSize);
					costTextField.x = settings.storeSellToolsDescX;
												 
					var hitArea:Sprite  =new Sprite();
					hitArea.graphics.beginFill(0x000000);
					hitArea.graphics.drawRect( settings.storeSellToolsX,
											currentY,
											(settings.toolWidth+settings.sellDescriptionWidth),
											settings.storeToolHeight);
					
 				    toolSprite.x = settings.storeSellToolsX;
					toolSprite.y = currentY;
					toolSprite.name = getToolSpriteId(i);					
					toolSprite.addChild(costTextField);
					toolSprite.addChild(descTextField);
					toolSprite.addChild(usesTextField);
					toolSprite.addChild(toolImage);
					
					addSellToolEvents(toolSprite,gameStore);				
					toolsForSale[i] = toolSprite;
					toolsForSaleUses[i] = usesTextField;
					toolsForSaleDesc[i] = descTextField;
				}
				toolsForSaleUses[i].text = ""+gameStore.toolsForSale[i].uses;
				toolsForSaleDesc[i].text = gameStore.toolsForSale[i].description;
			}
			
			currentY   += settings.storeToolHeight +settings.bankMargins;
		}
	}
	
	// ********************
	//  BUY SELL EVENTS
	// *******************
		
		
		public function addSellToolEvents(toolSprite:Sprite,gameStore:GameStore):void
		{
			removeSellToolsEvents(toolSprite,gameStore);
			toolSprite.addEventListener(MouseEvent.CLICK, gameStore.selectToolForSale,false,0,true);
			eventManager.trackEvent(toolSprite,gameStore.selectToolForSale);
		}
		
		public function removeSellToolsEvents(toolSprite:Sprite,gameStore:GameStore):void
		{
			if(toolSprite.hasEventListener(MouseEvent.CLICK))
			{
				toolSprite.removeEventListener(MouseEvent.CLICK,gameStore.selectToolForSale);
				eventManager.removeEvent(toolSprite);
			}
		}
		
		
		// *******************
		// UNIQUE SPRITE IDS
		// *******************
		
		public static function getToolSpriteId( toolIx:int ):String
		{
			return settings.toolImageName+settings.storeSeparator+toolIx;
		}
		
		public static function getToolSelectionSpriteId(crewIx:int, toolIx:int ):String
		{
			return settings.toolSelectionName+settings.storeSeparator+crewIx+settings.storeSeparator+toolIx;
		}		

		public  static function getToolStoreUsesSpriteId( toolIx:int ):String
		{
			return settings.toolSellingUsesName+settings.storeSeparator+toolIx;
		}
		
	
		// ****************************
		//   BUY SELL AREA
		// ****************************
		
		public function updateTradingArea(gameStore:GameStore):void
		{
			if( unknownTradeTool==null)
			{
				unknownTradeTool= new TextField();
				unknownTradeTool  = DrawObjects.configureLabel(unknownTradeTool,
											 settings.standardFont,
											 "  ?",
											 settings.foregroundColor,
											 settings.titleFontSize);
			}
			if( unknownTradeCrew==null)
			{
				unknownTradeCrew= new TextField();
				unknownTradeCrew  = DrawObjects.configureLabel(unknownTradeCrew,
											 settings.standardFont,
											 "  ?",
											 settings.foregroundColor,
											 settings.titleFontSize);
			}			
			
			if(tradeToolCrew ==null)
			{
				tradeToolCrew = new Sprite();
				DrawObjects.drawColoredRect(tradeToolCrew.graphics, 
												settings.backgroundColor,
												settings.toolWidth,
												settings.toolHeight,
												10,
												settings.lineThickness,
												settings.foregroundColor);
				tradeToolCrew.x = settings.tradeToolCrewX;				
				tradeToolCrew.y = settings.tradeToolCrewY;
			}
			if(tradeToolSprite==null)
			{
				tradeToolSprite = new Sprite();
				DrawObjects.drawColoredRect(tradeToolSprite.graphics, 
												settings.backgroundColor,
												settings.toolWidth,
												settings.toolHeight,
												10,
												settings.lineThickness,
												settings.foregroundColor);	
				tradeToolSprite.x = settings.tradeToolSpriteX;				
				tradeToolSprite.y = settings.tradeToolSpriteY;
			}
			if(tradeToolCost ==null)
			{
				tradeToolCost = new TextField();
				tradeToolCost = DrawObjects.configureLabel(tradeToolCost,
											settings.standardFont,
											 "0.00",
											 settings.foregroundColor,
											 settings.toolFontSize);
				tradeToolCost.x = settings.tradeToolPriceX;
				tradeToolCost.y = settings.tradeToolPriceY; 
			}
			if(tradeToolDesc == null)
			{
				tradeToolDesc = new TextField();
				tradeToolDesc = DrawObjects.configureLabel(tradeToolDesc,
											settings.standardFont,
											 "",
											 settings.foregroundColor,
											 settings.toolFontSize);
				tradeToolDesc.x = settings.tradeToolPriceX ;
				tradeToolDesc.y = settings.tradeToolPriceY + settings.toolFontSize; 
			}
			tradeToolCost.text = "$"+gameStore.tradeToolPrice;
			var tool:Tool =null;

			var description:String = "";
			if(gameStore.tradeToolIx>-1)
			{
				if(gameStore.isStoreTool)
				{
					tool = gameStore.toolsForSale[gameStore.tradeToolIx];
				}else
				{
					tool = gameStore.crew.members[gameStore.tradeCrewIx].tools[gameStore.tradeToolIx];
				}
				if(tool!=null)
				{
					description = tool.description;
				}
			}


			tradeToolDesc.text = description;
			
			tradeToolSprite.removeChildren();
			tradeToolCrew.removeChildren();
			
			if(gameStore.tradeCrewIx==-1)
			{
				tradeToolCrew.addChild(unknownTradeCrew);
			}else
			{
				tradeToolCrew  = DrawObjects.drawCrewToolId(tradeToolCrew,gameStore.crew.members[gameStore.tradeCrewIx], true);
			}
			if(gameStore.tradeToolIx==-1)
			{
				tradeToolSprite.addChild(unknownTradeTool);
			}else
			{
				
				if(tool==null)
				{
					tradeToolSprite.addChild(unknownTradeTool);
				}else
				{
					tradeToolSprite.graphics.clear();
					tradeToolSprite  = DrawObjects.drawTool(tradeToolSprite, null, null, tool) ;
					DrawObjects.drawColoredRect(tradeToolSprite.graphics, 
												settings.backgroundColor,
												settings.toolWidth,
												settings.toolHeight,
												10,
												settings.lineThickness,
												settings.foregroundColor);						
				}
				
			}
			
		}
		
		
		// ********************
		// CASH Text
		// ********************
		public function updateCashSprite(gameStore:GameStore):void
		{
			if(cashSprite==null)
			{
				cashSprite= new Sprite();
				//area to display total stolen funds
				var cashRect:Shape = new Shape();
				trace("gamesprites.as updateCashSPrite");
				DrawObjects.drawColoredRect(cashRect.graphics,
								settings.backgroundColor,
								settings.cashRectWidth,
								settings.cashRectHeight,
								settings.cashRectCornerRadius,
								settings.lineThickness,
								settings.foregroundColor);
				cashSprite.x = settings.cashX;
				cashSprite.y = settings.cashY;
				cashSprite.addChild(cashRect);
			}
			if(cashSpriteText==null)
			{
				cashSpriteText = new TextField();
				cashSpriteText = DrawObjects.convertToMoney(cashSpriteText,gameStore.crew.cash);
				cashSprite.addChild(cashSpriteText);
			}
			cashSpriteText.text = DrawObjects.moneyToString(gameStore.crew.cash);
				trace("gamesprites.as  END OF updateCashSPrite");
		}
		
		
		// ********************
		// MENU BUTTON
		// ********************
		public function resetMenu(gameStore:GameStore):void
		{	
			if(menuSpriteText==null)
			{
				menuSpriteText = new TextField();
				menuSpriteText = DrawObjects.configureLabel(menuSpriteText,
								settings.standardFont,
								"menu",
								settings.foregroundColor,
								settings.menuFontSize);
				menuSpriteText.x = settings.menuX;
				menuSpriteText.y = settings.menuY;
				addMenuEvents(gameStore);
			}
			trace("end of resetMenu");
		}
		
		public function addMenuEvents(gameStore:GameStore):void
		{
			removeMenuEvents(gameStore);
			menuSpriteText.addEventListener(MouseEvent.CLICK, gameStore.menuClicked,false,0,true);
			eventManager.trackEvent(menuSpriteText,gameStore.menuClicked);
		}
		
		public function removeMenuEvents(gameStore:GameStore):void
		{
			if(menuSpriteText.hasEventListener(MouseEvent.CLICK))
			{
				menuSpriteText.removeEventListener(MouseEvent.CLICK,gameStore.menuClicked);
				eventManager.removeEvent(menuSpriteText);
			}
		}
		


	// **********************************
	//  SELL BUY NEGOTIATE BUTTONS
	// *******************************
	public function resetTradeButtons(gameStore:GameStore):void
	{
		if(sellButton==null)
		{
			sellButton = new Sprite();
			sellText = new TextField();
			sellText  = DrawObjects.configureLabel(sellText,
								settings.standardFont,
								"Sell",
								settings.greenColor,
								settings.menuFontSize);
			sellButton.addChild(sellText);
			sellButton.x = settings.sellX;
			sellButton.y = settings.sellY;
			addSpriteEvents(sellButton,gameStore.sellTool);

		}
		if(buyButton==null)
		{
			buyButton = new Sprite();
			buyText = new TextField();
			buyText  = DrawObjects.configureLabel(buyText,
								settings.standardFont,
								"Buy",
								settings.greenColor,
								settings.menuFontSize);
			buyButton.addChild(buyText);
			buyButton.x = settings.buyX;
			buyButton.y = settings.buyY; 
			addSpriteEvents(buyButton,gameStore.buyTool);

		}
		if(negotiateButton ==null)
		{
			negotiateButton = new Sprite();
			negotiateText = new TextField();
			negotiateText  = DrawObjects.configureLabel(negotiateText,
								settings.standardFont,
								"Haggle",
								settings.foregroundColor,
								settings.menuFontSize);
			negotiateButton.addChild(negotiateText);
			negotiateButton.x = settings.negotiateX;
			negotiateButton.y = settings.negotiateY; 
		}
		var sellFormat:TextFormat = sellText.defaultTextFormat;
		var buyFormat:TextFormat = buyText.defaultTextFormat;
		var negotiateFormat:TextFormat = negotiateText.defaultTextFormat;
		
		sellButton.mouseEnabled = !gameStore.isStoreTool;
		buyButton.mouseEnabled = gameStore.isStoreTool;
		negotiateButton.mouseEnabled = !gameStore.isStoreTool;
		
		sellFormat.color = gameStore.isStoreTool?settings.deselectedFontColor : settings.selectedFontColor;
		buyFormat.color =  gameStore.isStoreTool?settings.selectedFontColor : settings.deselectedFontColor;
		negotiateFormat.color =  gameStore.isStoreTool?settings.deselectedFontColor : settings.selectedFontColor;
			
		sellText.defaultTextFormat  = sellFormat;
		buyText.defaultTextFormat  = buyFormat;
		negotiateText.defaultTextFormat  = negotiateFormat;
		
	}
	
	public function addSpriteEvents(sprite:Sprite, eventFunction:Function):void
	{
		sprite.addEventListener(MouseEvent.CLICK, eventFunction,false,0,true);
		eventManager.trackEvent(sprite,eventFunction);
	}
	
	public function removeSpriteEvents(sprite:Sprite, eventFunction:Function):void
	{
			if(sprite.hasEventListener(MouseEvent.CLICK))
			{
				sprite.removeEventListener(MouseEvent.CLICK,eventFunction);
				eventManager.removeEvent(sprite);
			}
	}
	
		

		// ********************
		// LEAVE STORE BUTTON
		// ********************
	public function resetLeaveStore(gameStore:GameStore):void
		{	
			if(leaveSpriteText==null)
			{
				leaveSprite = new Sprite();
				leaveSprite.x = settings.leaveX;
				leaveSprite.y = settings.leaveY;
				leaveSpriteText = new TextField();
				leaveSpriteText = DrawObjects.configureLabel(leaveSpriteText,
								settings.standardFont,
								" rob bank",
								settings.greenColor,
								settings.menuFontSize);
				leaveSpriteText.x = settings.leaveX;
				leaveSpriteText.y = settings.leaveY;
				addLeaveEvents(gameStore);
			}
			trace("end of resetMenu");
		}
			
		
		public function addLeaveEvents(gameStore:GameStore):void
		{
			removeLeaveEvents(gameStore);
			leaveSpriteText.addEventListener(MouseEvent.CLICK, gameStore.leaveClicked,false,0,true);
			eventManager.trackEvent(leaveSpriteText,gameStore.leaveClicked);
		}
		
		public function removeLeaveEvents(gameStore:GameStore):void
		{
			if(leaveSpriteText.hasEventListener(MouseEvent.CLICK))
			{
				leaveSpriteText.removeEventListener(MouseEvent.CLICK,gameStore.leaveClicked);
				eventManager.removeEvent(leaveSpriteText);
			}
		}
		
		
		// *************************
		// HELP Text Area
		// ********************
		
		
			//manages the tool tip shown at the bottom of the screen
		public function updateHelpSprites(gameStore:GameStore):void
		{
			trace("update Help Sprites");
			if(helpSprite==null)
			{
				helpSprite = new TextField();
				helpSprite = DrawObjects.configureLabel(helpSprite,
											 settings.standardFont,
											 "  ",
											 settings.foregroundColor,
											 settings.toolFontSize);
				helpSprite.wordWrap = true;
				helpSprite.multiline = true;
				helpSprite.width = settings.storeHelpWidth;
				helpSprite.x = settings.storeHelpX;
				helpSprite.y = settings.storeHelpY;
			}
			if(gameStore.helpMessage!=null)
			{
				helpSprite.text = gameStore.helpMessage;
			}
		}
		
		// *********************
		// TITLE OF STORE
		// *********************
		public function updateStoreName():void
		{
			if(storeName==null)
			{
				storeName = new TextField();
				storeName = DrawObjects.configureLabel(storeName,
											 settings.standardFont,
											 "Tumbler Trading Post",
											 settings.foregroundColor,
											 settings.menuFontSize);
				storeName.x = settings.storeTitleX;
				storeName.y = settings.storeTitleY;
			}
		}
		
		
		
		// ******************
		// CREW SPRITES
		// ******************
		

		public function updateToolSprites(gameStore:GameStore):void
		{
			trace("GameSprites. updateToolSprites");
			if (crewSprites ==null)
			{
				crewSprites = new Array();
			}
			if(gameStore.crew==null)
			{
				return;
			}
			if(gameStore.crew.members ==null)
			{
				return;
			}
			//for each person in the crew
			//create a line of weapons up 
			var crewLength:int = gameStore.crew.members.length;
			var selectedCrew:int = gameStore.tradeCrewIx;
			for (var i:int=0;i<crewLength;i++)
			{
				trace("StoreSprites.as updateToolSprites i="+i);
				trace("StoreSprites.as updateToolSprites crew="+gameStore.crew.members[i].name);
				var crew:Person = gameStore.crew.members[i];
				if(crew!=null )
				{
					if(crew.isActive  && crew.tools!=null)
					{
						trace("StoreSprites.as updateToolSprites i="+i);
						//The crew Image
						if(crewSprites[i]==null)
						{
							crewSprites[i] = new Sprite(); //sprite not yet defined
						}
						var crewToolsSprite:Sprite = crewSprites[i];
						crewToolsSprite.name = getParentCrewImageID(i);
						crewToolsSprite.x = settings.toolDisplayLeftMargin;
						crewToolsSprite.y = settings.toolDisplayTopMargin + i*settings.toolHeight + i*settings.toolMargin;											
						addSelectCrewEvents(crewToolsSprite,gameStore); //have not removed this need to do extra checking
						//Create the Image of the bankrobber
						UpdateCrewImageSprite(crewToolsSprite,
											gameStore,
											gameStore.crew.members[i],
											i,
											(i==selectedCrew)
										);
						
						//The tool List
						var toolList:Sprite;						
						if(toolSprites[i]==null)
						{
							toolSprites[i] = new Sprite(); //sprite not yet defined
						}
						toolList = toolSprites[i];
						toolList.x = settings.toolDisplayLeftMargin + settings.toolWidth;
						toolList.y = settings.toolDisplayTopMargin + i*settings.toolHeight + i*settings.toolMargin;						
						UpdateCrewTools(toolList,
										gameStore,
										gameStore.crew.members[i],
										i,
										(i==selectedCrew)
										);
						trace(" after adding crew "+gameStore.crew.members[i].name+" & tools ");
						trace(" children of main sprite are "+toolSprites[i].numChildren);
						trace(" children of main sprite located at "+crewToolsSprite.x+" ," +crewToolsSprite.y);
					}
					
				}	
			}		
		}
		
		
		// *******************
		// CREATE CREW IMAGE
		// *******************
		//this creates the crew image on the lower right screen
		//the event GameStore.selectedCrew member is called when 
		//this sprite is clicked on
		public function UpdateCrewImageSprite(parentSprite:Sprite,
											gameStore:GameStore,
											crew:Person,
											index:int,
											selectedCrew:Boolean):void
		{
			
			var childObject:Object  = parentSprite.getChildByName(StoreSprites.getCrewImageID(index) );
			var targetSprite:Sprite = ( childObject as Sprite);		
			if(targetSprite == null)
			{
				targetSprite = new Sprite();
				targetSprite = DrawObjects.drawCrewToolId(targetSprite,crew,selectedCrew); //draw the person Destination						
				targetSprite.name = StoreSprites.getCrewImageID(index );
				targetSprite.x = 0;
				targetSprite.y = 0;
				parentSprite.addChild(targetSprite);
			}
			
			var crewNameText:TextField;
			if(parentSprite.numChildren>0)
			{
				crewNameText= (parentSprite.getChildByName(StoreSprites.getCrewImageTextID(index)) as TextField);
			}
			if(crewNameText==null)
			{
				crewNameText = new TextField();
				crewNameText = DrawObjects.configureLabel(crewNameText,
														settings.standardFont,
														crew.name,
														settings.foregroundColor,
														settings.menuFontSize);
				crewNameText.name = StoreSprites.getCrewImageTextID(index);
				parentSprite.addChild(crewNameText);
			}		
			var tf:TextFormat = new TextFormat();
			tf.color = selectedCrew?settings.selectedFontColor: settings.deselectedFontColor;
			crewNameText.setTextFormat(tf);
			crewNameText.text = crew.name;
		}
		
		
		
		// **************************
		// CREATE CREW TOOLS
		// *************************
		
		public function UpdateCrewTools(parentSprite:Sprite,
										gameStore:GameStore,
										crew:Person,
										crewIx:int,
										selectedCrew:Boolean):void
		{
			trace("GameSprites.as:updateToolSprites  for a  crew member "+crew.name+"("+crewIx+") Draw image of tool ");
			if(parentSprite==null)
			{
				return;
			}
			
			var toolCount:int = crew.tools.length;
			var toolPosition:int =0;
			for(var toolIx:int =0;toolIx<toolCount;toolIx++)
			{
				var tool:Tool = crew.tools[toolIx];
				var selectedSprite:Sprite;
				
				
				//Reset the rectangle indicating the tool is selected/in use
				selectedSprite= (parentSprite.getChildByName( getCrewToolSelectionSpriteId(crewIx,toolIx)) as Sprite);
				if(selectedSprite==null )
				{
					trace("creating selected Sprite");
					selectedSprite =new Sprite();
					selectedSprite = DrawObjects.drawToolSelected(selectedSprite,tool,selectedCrew);
					selectedSprite.name = getCrewToolSelectionSpriteId(crewIx,toolIx);								
					selectedSprite.x = toolPosition*settings.toolWidth + toolPosition* settings.toolWidthSpacing;
					selectedSprite.y = 0;
					parentSprite.addChild(selectedSprite);
				}
				selectedSprite.graphics.clear();
				selectedSprite = DrawObjects.drawToolSelected(selectedSprite,tool,selectedCrew);	

				//Creates the actual tool Image
				var tempTool:Sprite = (parentSprite.getChildByName(getCrewToolSpriteId(crewIx,toolIx) ) as Sprite);
				var usesTextField:TextField;
				if(tempTool != null)
				{
					//Draws the image of the tool and number of uses
					usesTextField = (tempTool.getChildByName( getCrewToolUsesSpriteId(crewIx,toolIx)) as TextField);				
				}
				if(tempTool ==null||usesTextField==null)
				{
					usesTextField= new TextField();
					usesTextField.name = getCrewToolUsesSpriteId(crewIx,toolIx);	
					usesTextField.x = 0;
					usesTextField.y = 0;
					tempTool = new Sprite();
					tempTool = DrawObjects.drawTool(tempTool,usesTextField,crew,tool);
					tempTool.name = getCrewToolSpriteId(crewIx,toolIx);
					tempTool.y =0;
					tempTool.x = toolPosition*settings.toolWidth + toolPosition* settings.toolWidthSpacing;
					tempTool.addChild(usesTextField);
					addToolEvents(tempTool,gameStore);
					parentSprite.addChild(tempTool);
				}
				
				//Creates the top left corner Uses  field
				usesTextField.text = (tool.uses>=0)?""+tool.uses:"";				
				toolPosition++;		
			}
		}
		
		
		// ********************
		// RESET CREW SPRITE
		// *******************
		//this function deletes a sprite and all of its events 
		public function removeCrewSprite(crewIx:int,func:Function):void
		{
			var crewSprite:Sprite = toolSprites[crewIx];
			var length:int = crewSprite.numChildren;
			if(crewSprite !=null)
			{
				for(var i:int=0;i<length;i++)
				{
					var child:Object = crewSprite.getChildAt(i);
					if( (child as Sprite)!=null)
					{
						removeSpriteEvents((child as Sprite),func);
					}
					child=null; //invoke the wrath of the garbage collector.
				}
			}
			toolSprites[crewIx].removeChildren();
		}
		
		public static function getParentCrewImageID(index:int):String
		{
			return "ParentStoreCrewImage"+settings.storeSeparator+index;
		}
		public static function getCrewImageID(index:int):String
		{
			return "StoreCrewImage"+settings.storeSeparator+index;
		}
		
		public static function getCrewImageTextID(index:int):String
		{
			return "StoreCrewImageTExtID"+settings.storeSeparator+index;
		}
		
		public static function getCrewToolSpriteId(crewIx:int, toolIx:int ):String
		{
			return settings.toolImageName+settings.toolSeparator+crewIx+settings.toolSeparator+toolIx;
		}
		
		public static function getCrewToolSelectionSpriteId(crewIx:int, toolIx:int ):String
		{
			return settings.toolSelectionName+settings.toolSeparator+crewIx+settings.toolSeparator+toolIx;
		}		

		public  static function getCrewToolUsesSpriteId(crewIx:int, toolIx:int ):String
		{
			return settings.toolUsesName+settings.toolSeparator+crewIx+settings.toolSeparator+toolIx;
		}
		
		public function addSelectCrewEvents(crew:Sprite, gameStore:GameStore):void
		{
			removeSelectCrewEvents(crew, gameStore);
			crew.addEventListener(MouseEvent.CLICK,gameStore.selectCrewMember);
			eventManager.trackEvent(crew,gameStore.selectCrewMember);
		}
		
		public function removeSelectCrewEvents(crew:Sprite, gameStore:GameStore):void
		{
			if(crew!=null && crew.hasEventListener(MouseEvent.CLICK))
			{
				crew.removeEventListener(MouseEvent.CLICK, gameStore.selectCrewMember);
				eventManager.removeEvent(crew);

			}
		}
		
		
		public function addToolEvents(tool:Sprite,gameStore:GameStore):void
		{
			removeToolEvents(tool,gameStore);
			tool.addEventListener(MouseEvent.CLICK, gameStore.selectCrewTool,false,0,true);		
			eventManager.trackEvent(tool,gameStore.selectCrewTool);
		}
		
		public function removeToolEvents(tool:Sprite,gameStore:GameStore):void
		{
			if(tool!=null && tool.hasEventListener(MouseEvent.CLICK))
			{
				tool.removeEventListener(MouseEvent.CLICK, gameStore.selectCrewTool);
				eventManager.removeEvent(tool);
			}
		}		
		
		
		
		public function cleanupLevel():void
		{
			//remove All events from all fields
			var i:int=0;
			var length:int = toolsForSale.length;
			for(i=0;i<length;i++)
			{
				eventManager.removeEvent(toolsForSale[i]);
				eventManager.removeEvent(toolsForSaleUses[i]);	
				eventManager.removeEvent(toolsForSaleDesc[i]);
			}
		
			//invoking the wrath of the garbage collector
			//Sprite to show List of available tools
			for(i=0;i<length;i++)
			{
				eventManager.removeEvent(toolsForSale[i]);	
				eventManager.removeEvent(toolsForSaleUses[i]);	
				eventManager.removeEvent(toolsForSaleDesc[i]);
			}

			reset();

		
		}
		
		public function cleanupAll():void
		{
			eventManager.removeAllEvents();
		}
		


		public function reset():void
		{
			crewSprites=[]; //all crewMembers
			toolSprites=[];
			toolSelectionSprites=[];
			toolUsesSprites=[];
			toolsForSale=[];	
			toolsForSaleUses=[];	
			toolsForSaleDesc=[];			
		}
		
	}


}