package{
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;

	public class GameSprites
	{
		public var gameSprite:Sprite;
		public var timerSprite:Sprite;
		public var timerSpriteText:TextField;
		public var cashSprite:Sprite;
		public var cashSpriteText:TextField;
		public var safeSprite:Sprite;
		public var safeOpenedSprite:Sprite;
		public var safeNotFoundSprite:TextField;
		public var safeSpriteText:TextField;
		public var messageText:TextField;
		public var messageTextArray:Array;	
		public var messageBoxSprite:Sprite;
		
		public var helpSprite:Sprite;
		public var helpMessage:TextField;
		public var helpIconText:TextField;
		public var helpIconSprite:Sprite;
		
		public var exitSprite:TextField;
		public var exitSpriteHelp:Sprite;
		
		public var menuSpriteText:TextField;
		public var menuSpriteHelp:Sprite;
		
		public var bankSprite:Sprite;
		public var bankNameText:TextField;
		public var peopleSprites:Array;
		public var crewSprites:Array;
		public var crewToolSprites:Array;
		public var destinationSprites:Array;
		public var roomSprites:Array;
		public var safeDamagePhysical:Sprite;
		public var safeDamagePhysicalPoints:TextField;
		public var safeDamageElectrical:Sprite;
		public var safeDamageElectricalPoints:TextField;
		public var safeDamageMechanical:Sprite;
		public var safeDamageMechanicalPoints:TextField;
		public var toolSprites:Array;
		public var toolSelectionSprites:Array;
		public var weaponsRadiusSprites:Array;


	public function GameSprites()
		{
			gameSprite = new Sprite();
			peopleSprites = new Array(AllLevels.maxPersonCount);
			crewToolSprites = new Array(AllLevels.maxCrewCount);
			crewSprites = new Array(AllLevels.maxCrewCount);
			roomSprites = new Array(AllLevels.maxRoomCount);
			toolSprites = new Array(AllLevels.maxToolsPerPersonCount * AllLevels.maxCrewCount) ;
			destinationSprites= new Array(AllLevels.maxCrewCount);
			weaponsRadiusSprites= new Array(AllLevels.maxCrewCount);
			toolSelectionSprites = new Array(AllLevels.maxToolsPerPersonCount * AllLevels.maxCrewCount) ;
			messageTextArray = new Array(settings.messageBoxMaxChoices);
			
		}
	
	
		public function createAllSprites( gameLevel:GameLevel):void
		{
			if(gameSprite==null)
			{	
				gameSprite = new Sprite();
			}	
			if(gameLevel.bank !=null)
			{
				updateBankSprite(gameLevel);
				updateRoomSprites(gameLevel);
				updateCashSprite(gameLevel);
				updateTimerSprite(gameLevel);
				updateSafeSprites(gameLevel);
				resetMenu(gameLevel);
				updatePeopleSprites(gameLevel,peopleSprites,false);
				updatePeopleSprites(gameLevel,crewSprites,true);
				updateToolSprites(gameLevel);
				updateHelpSprites(gameLevel);
				updateMessageBox(gameLevel);
				updateExitSprite(gameLevel);
			}
		}
		
		public function createGameSprite(gameLevel:GameLevel):void
		{
			if(gameSprite==null)
			{	
				gameSprite = new Sprite();
			}	
			gameSprite.removeChildren();
			gameSprite.addChild(bankSprite);
			gameSprite.addChild(bankNameText);
			gameSprite.addChild(timerSprite);
			gameSprite.addChild(cashSprite);

			gameSprite.addChild(menuSpriteHelp);
			gameSprite.addChild(menuSpriteText);

			gameSprite.addChild(safeSpriteText);
			if(gameLevel.bank.safe.isFound)
			{
				if(gameLevel.bank.safe.isOpen)
				{
					gameSprite.addChild(safeOpenedSprite);
				}else
				{
					gameSprite.addChild(safeSprite);
				}
					
				var safe:Safe = gameLevel.bank.safe;
				if(safe.physicalHitPoints>-1)
				{
					gameSprite.addChild(safeDamagePhysical);
					gameSprite.addChild(safeDamagePhysicalPoints);
				}
				if(safe.mechanicalHitPoints>-1)
				{
					gameSprite.addChild(safeDamageMechanical);
					gameSprite.addChild(safeDamageMechanicalPoints);
				}
				if(safe.electronicHitPoints>-1)
				{
					gameSprite.addChild(safeDamageElectrical);
					gameSprite.addChild(safeDamageElectricalPoints);
				}
			}else
			{	
				gameSprite.addChild(safeNotFoundSprite);
			}
			
			
			var length:int = gameLevel.bank.rooms.length;
			var i:int;
			for(i=0;i<length;i++)
			{
				if(roomSprites[i]!=null && gameLevel.bank.rooms[i].isActive)
				{
					gameSprite.addChild(roomSprites[i]);
				}
			}

			length = gameLevel.bank.people.length;
			for(i=0;i<length;i++)
			{
				if(peopleSprites[i]!=null )
				{
					if( gameLevel.bank.people[i].isActive)
						gameSprite.addChild(peopleSprites[i]);
						
				}
			}

			length =  gameLevel.crew.members.length;
			for(i=0;i<length;i++)
			{
				if(crewSprites[i]!=null && gameLevel.crew.members[i].isActive)
				{
					if(!gameLevel.crew.members[i].velocity.equal(settings.ZEROVELOCITY))
						gameSprite.addChild(destinationSprites[i]);
					gameSprite.addChild(crewSprites[i]);
					gameSprite.addChild(crewToolSprites[i]);
					gameSprite.addChild(toolSprites[i]);	
					gameSprite.addChild(weaponsRadiusSprites[i]);
				}
			}
			
			
			
			//add the help tips
			gameSprite.addChild(helpSprite);
			
			//help Icon 
			gameSprite.addChild(helpIconSprite);
			
			//show and in game message
			if(gameLevel.gameState == InGameState.SHOWMESSAGE)
			{
				gameSprite.addChild(messageBoxSprite);
			}
			
			//add the FLEE sprite last - overtop of other sprites
			gameSprite.addChild(exitSpriteHelp);
			gameSprite.addChild(exitSprite);
			
			//helpSprite
			if(gameLevel.hoverMessage.visible)
			{
				gameSprite.addChild(helpMessage);
			}

		}
		
		
		
		public function updateExitSprite(gameLevel:GameLevel):void
		{
			if(exitSprite == null)
			{
				exitSpriteHelp = new Sprite();
				exitSpriteHelp.name = settings.helpIdTag+gameLevel.inGameHelp.FLEE;
				DrawObjects.drawColoredRect(exitSpriteHelp.graphics,
								settings.backgroundColor,
								settings.menuFontSize*2,
								settings.menuFontSize/1.5,
								settings.timerRectCornerRadius,
								settings.lineThickness,
								settings.backgroundColor);
				addHelpEvents(exitSpriteHelp,gameLevel);
								
				exitSprite = new TextField();
				exitSprite = DrawObjects.configureLabel(exitSprite,
									settings.standardFont,
									 "flee",
									 settings.greenColor,
									 settings.menuFontSize);
				addExitEvents(gameLevel);
				
			}
			var entrance:cPoint = gameLevel.bank.layout.getEntrance();
			exitSprite.x = settings.bankX + settings.bankRoomWidth - 30;
			exitSprite.y = settings.bankY +settings.bankMargins;
			exitSpriteHelp.x = exitSprite.x ;
			exitSpriteHelp.y = exitSprite.y;
		}
		
		public function addExitEvents(gameLevel:GameLevel):void
		{
			removeExitEvents(gameLevel);
			if(exitSprite!=null )
				exitSprite.addEventListener(MouseEvent.CLICK, gameLevel.handleEndLevelEnded,false,0,true);	
		}
		
		public function removeExitEvents(gameLevel:GameLevel):void
		{
			exitSprite.removeEventListener(MouseEvent.CLICK, gameLevel.handleEndLevelEnded);
		}
		
		
		public function updateBankSprite(gameLevel:GameLevel):void
		{
			if(bankSprite ==null)
			{
				bankSprite = new Sprite();
			}
			if(bankNameText==null)
			{
				bankNameText= new TextField();
				bankNameText = DrawObjects.configureLabel(bankNameText,
								settings.standardFont,
								 gameLevel.bank.name,
								settings.foregroundColor,
								settings.menuFontSize);
			}
			bankSprite.graphics.clear();
			
			bankNameText.text = gameLevel.bank.name;
			bankNameText.x = settings.bankX + 50;
			bankNameText.y = settings.bankY +settings.bankMargins;
			DrawObjects.drawRoom(bankSprite,gameLevel.bank.layout,0);
			bankSprite.name = Bank.CLASSID;
			bankSprite.x = settings.bankRoomX;
			bankSprite.y = settings.bankRoomY;
			addRoomEvents(bankSprite,gameLevel);
		}
		
		
		public function updateRoomSprites(gameLevel:GameLevel):void
		{
			var length:int = gameLevel.bank.rooms.length;
			roomSprites=[];
			
			for(var i:int=0;i<length;i++)
			{ 
				if(roomSprites[i]==null)
				{
					roomSprites[i]= new Sprite();
					roomSprites[i].name = Room.CLASSID+i;
				}				
				var newRoom:Sprite =roomSprites[i];
				newRoom.graphics.clear();
				newRoom = DrawObjects.drawRoom(newRoom,gameLevel.bank.rooms[i],i);
				if(newRoom,gameLevel.bank.rooms[i].isSafeHere)
				{
					newRoom.name = settings.helpIdTag+gameLevel.inGameHelp.SAFEROOM;
					addHelpEvents(newRoom,gameLevel);
				}
				newRoom.x += bankSprite.x;
				newRoom.y += bankSprite.y;
				addRoomEvents(newRoom,gameLevel);
			}
		}
		
		public function addRoomEvents(roomSprite:Sprite,gameLevel:GameLevel):void
		{
			removeRoomEvents(roomSprite,gameLevel);
			if(roomSprite !=null)
			{
				roomSprite.addEventListener(MouseEvent.CLICK, gameLevel.roomClicked,false,0,true);				
			}
		}
		
		public function removeRoomEvents(roomSprite:Sprite,gameLevel:GameLevel):void
		{
				if(roomSprite!=null && roomSprite.hasEventListener(MouseEvent.CLICK))
				{
					roomSprite.removeEventListener(MouseEvent.CLICK, gameLevel.roomClicked);
				}
		}
		
		
		public function updateTimerSprite(gameLevel:GameLevel):void
		{
			if(timerSprite ==null)
			{ 
				timerSprite = new Sprite();
				var timerRect:Shape = new Shape();
				DrawObjects.drawColoredRect(timerRect.graphics,
								settings.backgroundColor,
								settings.timerRectWidth,
								settings.timerRectHeight,
								settings.timerRectCornerRadius,
								settings.lineThickness,
								settings.foregroundColor);
				timerSprite.x = settings.timerX;
				timerSprite.y = settings.timerY;
				timerSprite.addChild(timerRect);			
				timerSprite.name = settings.helpIdTag+gameLevel.inGameHelp.TIMER;
				addHelpEvents(timerSprite,gameLevel);				
			}
			if(timerSpriteText==null)
			{
				timerSpriteText = new TextField();

				timerSpriteText = DrawObjects.convertToCountDown(timerSpriteText,gameLevel.timeToRob);
				timerSprite.addChild(timerSpriteText);
				timerSprite.x =settings.timerTextX;
				timerSprite.y = settings.timerTextY;
			}
			timerSpriteText.text = DrawObjects.timeToString(gameLevel.timeToRob);
			////trace("GameSprites.as end of updateTimer");
		}

		public function updateCashSprite(gameLevel:GameLevel):void
		{
			if(cashSprite==null)
			{
				cashSprite= new Sprite();
				//area to display total stolen funds
				var cashRect:Shape = new Shape();
				//trace("gamesprites.as updateCashSPrite");
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
				cashSprite.name = settings.helpIdTag+gameLevel.inGameHelp.CASH;
				addHelpEvents(cashSprite,gameLevel);				
			}
			if(cashSpriteText==null)
			{
				cashSpriteText = new TextField();
				cashSpriteText = DrawObjects.convertToMoney(cashSpriteText,gameLevel.crew.cash);
				cashSprite.addChild(cashSpriteText);
			}
			cashSpriteText.text = DrawObjects.moneyToString(gameLevel.crew.cash);
				//trace("gamesprites.as  END OF updateCashSPrite");
		}
		
		public function resetMenu(gameLevel:GameLevel):void
		{	
			if(menuSpriteText==null)
			{
				menuSpriteHelp = new Sprite();
				menuSpriteHelp.name = settings.helpIdTag+gameLevel.inGameHelp.MENU;
				DrawObjects.drawColoredRect(menuSpriteHelp.graphics,
								settings.backgroundColor,
								settings.menuFontSize*2,
								settings.menuFontSize,
								settings.timerRectCornerRadius,
								settings.lineThickness,
								settings.backgroundColor);
				menuSpriteHelp.x = settings.menuX;
				menuSpriteHelp.y = settings.menuY;
				addHelpEvents(menuSpriteHelp,gameLevel);
								
				menuSpriteText = new TextField();
				menuSpriteText = DrawObjects.configureLabel(menuSpriteText,
								settings.standardFont,
								"menu",
								settings.foregroundColor,
								settings.menuFontSize);
				menuSpriteText.x = settings.menuX;
				menuSpriteText.y = settings.menuY;
				addMenuEvents(gameLevel);

			}
			//trace("end of resetMenu");
		}

		public function addMenuEvents(gameLevel:GameLevel):void
		{
			removeMenuEvents(gameLevel);
			menuSpriteText.addEventListener(MouseEvent.CLICK, gameLevel.menuClicked,false,0,true);
		}
		
		public function removeMenuEvents(gameLevel:GameLevel):void
		{
			if(menuSpriteText.hasEventListener(MouseEvent.CLICK))
			{
				menuSpriteText.removeEventListener(MouseEvent.CLICK,gameLevel.menuClicked);
			}
		}

		public function updatePeopleSprites(gameLevel:GameLevel, 
											spriteArray:Array,
											isCrew:Boolean):void
		{
			var length:int =0;
			var personArray:Array;
			var personName:String="";
			if(isCrew)
			{
				personArray = gameLevel.crew.members;
				personName = Crew.CLASSID;
			}
			else
			{	
				personArray = gameLevel.bank.people;
				personName = Person.CLASSID;
			}
			length = personArray.length;			

			for(var i:int=0;i<length;i++)
			{ 

				if(spriteArray[i]==null)
				{
					spriteArray[i]= new Sprite()
					var newPerson:Sprite =spriteArray[i];
					newPerson.useHandCursor=true;
					if(personArray[i].isCrew)
					{
						destinationSprites[i] = new Sprite();
						var destSprite:Sprite = destinationSprites[i];
						destSprite = DrawObjects.drawDestination(destSprite,personArray[i]);
						newPerson = DrawObjects.drawCrew(newPerson,personArray[i]);
						newPerson.name =Crew.CLASSID+gameLevel.crew.members[i].name;
						addPersonEvents(newPerson,gameLevel);

						var helpSprite:Sprite = new Sprite();
						helpSprite.hitArea = newPerson;
						helpSprite.name =	settings.helpIdTag+gameLevel.inGameHelp.CREW; //the ID of the help tag to show when in game help is on
						addHelpEvents(helpSprite,gameLevel);										
						newPerson.addChild(helpSprite);
					}else
					{
						newPerson = DrawObjects.drawPerson(newPerson,personArray[i]);
						newPerson.name =settings.helpIdTag+gameLevel.inGameHelp.PERSON; //indicate what hover text will be show
						addHelpEvents(newPerson,gameLevel);	
						
					}
				}	
				if(personArray[i].isCrew)
				{
					destinationSprites[i].x = personArray[i].destination.x +bankSprite.x;
					destinationSprites[i].y = personArray[i].destination.y +bankSprite.y;	
					var countChildren:int = spriteArray[i].numChildren;
					for(var childIx:int=0;childIx<countChildren;childIx++)
					{
						var childObj:TextField = (spriteArray[i].getChildAt(0) as TextField);
						if(childObj!=null)
						{
							var txFmt:TextFormat = childObj.defaultTextFormat;
							txFmt.color = (gameLevel.crew.selectedMember==i)?settings.greenColor:settings.selectedFontColor;
							childObj.defaultTextFormat = txFmt;
							childObj.textColor = (gameLevel.crew.selectedMember==i)?settings.greenColor:settings.selectedFontColor;
						}
						if(weaponsRadiusSprites[i] == null)
						{
							weaponsRadiusSprites[i] = new Sprite();
						}
						weaponsRadiusSprites[i].graphics.clear();
						weaponsRadiusSprites[i] = DrawObjects.drawWeaponsRadius(weaponsRadiusSprites[i],gameLevel.crew.members[i]);
						weaponsRadiusSprites[i].x = personArray[i].position.x +bankSprite.x - settings.personWidth/2;
						weaponsRadiusSprites[i].y = personArray[i].position.y +bankSprite.y - settings.personWidth/2;
					}
				}else
				{
					//if help is enabled then show the help on bank people otherwise disable it
					spriteArray[i].mouseEnabled = gameLevel.inGameHelp.showHelp;
				}
				
				spriteArray[i].x = personArray[i].position.x +bankSprite.x - settings.personWidth/2;
				spriteArray[i].y = personArray[i].position.y +bankSprite.y - settings.personHeight/2;

			}
			//trace("end of GameSprites.as UpdatePeopleSprites ");
		}
	
		public function addPersonEvents(person:Sprite,gameLevel:GameLevel):void
		{
			removePersonEvents(person,gameLevel);
			person.addEventListener(MouseEvent.CLICK, gameLevel.personClicked,false,0,true);				
		}
		
		public function removePersonEvents(person:Sprite,gameLevel:GameLevel):void
		{
			if(person!=null && person.hasEventListener(MouseEvent.CLICK))
			{
				person.removeEventListener(MouseEvent.CLICK, gameLevel.personClicked);
			}
		}
		
		
		
		// ********************
		// SAFE sprites
		// ********************
		
		public function updateSafeSprites(gameLevel:GameLevel):void
		{
		
			//Print the name of the safe
			if(safeSpriteText==null)
			{
				safeSpriteText = new TextField();
				safeSpriteText = DrawObjects.configureLabel(safeSpriteText,
								settings.standardFont,
								gameLevel.bank.safe.name,
								settings.foregroundColor,
								settings.menuFontSize);
				safeSpriteText.x = gameLevel.bank.safe.position.x;
				safeSpriteText.y = settings.safeY + settings.safeTitleLeftMargin;
			}
			if(safeOpenedSprite ==null)
			{
				safeOpenedSprite = new Sprite();
			}
			if(safeSprite==null)
			{
				safeSprite = new Sprite();
				safeSprite.name = settings.helpIdTag+gameLevel.inGameHelp.BANKVAULT;
				addHelpEvents(safeSprite,gameLevel);
			}
			
			//create the question mark to represent the type of safe
			if(safeNotFoundSprite== null)
			{
				safeNotFoundSprite= new TextField();
				safeNotFoundSprite = DrawObjects.configureLabel(safeNotFoundSprite,
								settings.standardFont,
								"?",
								settings.foregroundColor,
								300);
				safeNotFoundSprite.x =  settings.safeX + settings.safeRectWidth/3;
				safeNotFoundSprite.y = settings.safeY + settings.safeRectHeight/5;
			}
			
			//update the safe text when it is found
			safeSpriteText.text="unknown";			
			if(!gameLevel.bank.safe.isFound)
			{
				safeSpriteText.text = gameLevel.bank.safe.name;
			}
			
			updateSafeDamageSprites(gameLevel);
			
			safeOpenedSprite.removeChildren();
			safeOpenedSprite.addChild(EmbedAssets.getImage(gameLevel.bank.safe.imageOpenedIndex));
			safeOpenedSprite.x = gameLevel.bank.safe.position.x;
			safeOpenedSprite.y = gameLevel.bank.safe.position.y;
			safeSprite.removeChildren();
			safeSprite.addChild(EmbedAssets.getImage(gameLevel.bank.safe.imageIndex));
			safeSprite.x = gameLevel.bank.safe.position.x;
			safeSprite.y = gameLevel.bank.safe.position.y;
			
		}
		
		
		public function updateSafeDamageSprites(gameLevel:GameLevel):void
		{
			//update the damage on the safe
			var safe:Safe = gameLevel.bank.safe;
			var currY:int = settings.safeDamageY;
			if(safeDamagePhysical==null)
			{
				safeDamagePhysical = new Sprite();
				safeDamagePhysical.name = settings.helpIdTag+gameLevel.inGameHelp.PHYSICALDAMAGE;
				safeDamagePhysical.addChild(EmbedAssets.getImage(GameImages.PHYSICALDAMAGE));
				safeDamagePhysical.x = settings.safeDamageX;
				safeDamagePhysical.y = settings.safeDamageY;
				safeDamagePhysicalPoints = new TextField();
				safeDamagePhysicalPoints = DrawObjects.drawSafeHitPoints(safeDamagePhysicalPoints,safe.physicalHitPoints);
				safeDamagePhysicalPoints.x = settings.safeDamagePointsX;
				addHelpEvents(safeDamagePhysical,gameLevel);
			}
			
			if(safeDamageElectrical ==null)
			{
				safeDamageElectrical = new Sprite();
				safeDamageElectrical.name = settings.helpIdTag+gameLevel.inGameHelp.ELECTRICALDAMAGE;
				safeDamageElectrical.addChild(EmbedAssets.getImage(GameImages.ELECTRICALDAMAGE));
				safeDamageElectrical.x = settings.safeDamageX;
				safeDamageElectrical.y = settings.safeDamageY;
				safeDamageElectricalPoints = new TextField();
				safeDamageElectricalPoints = DrawObjects.drawSafeHitPoints(safeDamageElectricalPoints,safe.electronicHitPoints);
				safeDamageElectricalPoints.x = settings.safeDamagePointsX;
				addHelpEvents(safeDamageElectrical,gameLevel);
			}

			if(safeDamageMechanical ==null)
			{
				safeDamageMechanical = new Sprite();
				safeDamageMechanical.name = settings.helpIdTag+gameLevel.inGameHelp.LOCKPICKDAMAGE;
				safeDamageMechanical.addChild(EmbedAssets.getImage(GameImages.LOCKPICKDAMAGE));
				safeDamageMechanical.x = settings.safeDamageX;
				safeDamageMechanical.y = settings.safeDamageY;
				safeDamageMechanicalPoints = new TextField();
				safeDamageMechanicalPoints = DrawObjects.drawSafeHitPoints(safeDamageMechanicalPoints,safe.mechanicalHitPoints);
				safeDamageMechanicalPoints.x = settings.safeDamagePointsX;
				addHelpEvents(safeDamageMechanical,gameLevel);
				
			}		
			
			safeDamageMechanicalPoints.text = ""+safe.mechanicalHitPoints;
			safeDamageElectricalPoints.text = ""+safe.electronicHitPoints;
			safeDamagePhysicalPoints.text = ""+safe.physicalHitPoints;
			
			if(safe.physicalHitPoints>-1)
			{
				
				safeDamagePhysical.y = currY;
				safeDamagePhysicalPoints.y  = currY + settings.safeDamagePointsAlignY;
				currY +=settings.safeDamageYSpacing;
			}
			if(safe.electronicHitPoints>-1)
			{
				safeDamageElectrical.y = currY;
				safeDamageElectricalPoints.y  = currY + settings.safeDamagePointsAlignY;
				currY +=settings.safeDamageYSpacing;
			}
			if(safe.mechanicalHitPoints>-1)
			{
				safeDamageMechanical.y = currY;
				safeDamageMechanicalPoints.y  = currY + settings.safeDamagePointsAlignY;
				currY +=settings.safeDamageYSpacing;
			}
		}
		
		

		
		
		// *********************
		// HELP SPRITE EVENTS
		// *********************
		public function addHelpEvents(sprite:Sprite,gameLevel:GameLevel):void
		{
		
			removeHelpEvents(sprite, gameLevel);
			sprite.addEventListener(MouseEvent.ROLL_OVER, gameLevel.helpHover,false,0,true);				
			sprite.addEventListener(MouseEvent.ROLL_OUT, gameLevel.helpHoverOff,false,0,true);			
		}
		
		public function removeHelpEvents(sprite:Sprite,gameLevel:GameLevel):void
		{
			if(sprite!=null && sprite.hasEventListener(MouseEvent.ROLL_OVER))
			{
				sprite.removeEventListener(MouseEvent.ROLL_OVER, gameLevel.helpHover);				
			}		
	
			if(sprite!=null && sprite.hasEventListener(MouseEvent.ROLL_OUT))
			{
				sprite.removeEventListener(MouseEvent.ROLL_OUT, gameLevel.helpHoverOff);				
			}			
			
		
		}
		
		
		// ********************
		// Tool Area sprites
		// ********************
		
		public function updateToolSprites(gameLevel:GameLevel):void
		{
			//trace("GameSprites. updateToolSprites");
			if (crewToolSprites ==null)
			{
				crewToolSprites = new Array();
			}
			if(gameLevel.crew==null)
			{
				return;
			}
			if(gameLevel.crew.members ==null)
			{
				return;
			}
			//for each person in the crew
			//create a line of weapons up 
			var crewLength:int = gameLevel.crew.members.length;
			var selectedCrew:int = gameLevel.crew.selectedMember;
			for (var i:int=0;i<crewLength;i++)
			{
				//trace("GameSprites.as updateToolSprites i="+i);
				//trace("GameSprites.as updateToolSprites crew="+gameLevel.crew.members[i].name);
				var crew:Person = gameLevel.crew.members[i];
				if(crew!=null )
				{
					if(crew.isActive  && crew.tools!=null)
					{
						//trace("GameSprites.as updateToolSprites i="+i);
						//The crew Image
						if(crewToolSprites[i]==null)
						{
							crewToolSprites[i] = new Sprite(); //sprite not yet defined
						}
						var crewToolsSprite:Sprite = crewToolSprites[i];
						crewToolsSprite.name = getParentCrewImageID(i);
						crewToolsSprite.x = settings.toolDisplayLeftMargin;
						crewToolsSprite.y = settings.toolDisplayTopMargin + i*settings.toolHeight + i*settings.toolMargin;											
						addSelectCrewEvents(crewToolsSprite,gameLevel); //have not removed this need to do extra checking
						//Create the Image of the bankrobber
						UpdateCrewImageSprite(crewToolsSprite,
											gameLevel,
											gameLevel.crew.members[i],
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
										gameLevel,
										gameLevel.crew.members[i],
										i,
										(i==selectedCrew)
										);
					}
					
				}	
			}		
		}
		
		
	 // *******************
		// CREATE CREW IMAGE
		// *******************
		//this creates the crew image on the lower right screen
		//the event GameLevel.selectedCrew member is called when 
		//this sprite is clicked on
		public function UpdateCrewImageSprite(parentSprite:Sprite,
											gameLevel:GameLevel,
											crew:Person,
											index:int,
											selectedCrew:Boolean):void
		{
			
			var childObject:Object  = parentSprite.getChildByName(GameSprites.getCrewImageID(index) );
			var targetSprite:Sprite = ( childObject as Sprite);		
			if(targetSprite == null)
			{
				targetSprite = new Sprite();
				targetSprite = DrawObjects.drawCrewToolId(targetSprite,crew,selectedCrew); //draw the person Destination						
				targetSprite.name = GameSprites.getCrewImageID(index );
				targetSprite.x = 0;
				targetSprite.y = 0;
				parentSprite.addChild(targetSprite);
			}
			
			var crewNameText:TextField;
			if(parentSprite.numChildren>0)
			{
				crewNameText= (parentSprite.getChildByName(GameSprites.getCrewImageTextID(index)) as TextField);
			}
			if(crewNameText==null)
			{
				crewNameText = new TextField();
				crewNameText = DrawObjects.configureLabel(crewNameText,
														settings.standardFont,
														crew.name,
														settings.foregroundColor,
														settings.menuFontSize);
				crewNameText.name = GameSprites.getCrewImageTextID(index);
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
										gameLevel:GameLevel,
										crew:Person,
										crewIx:int,
										selectedCrew:Boolean):void
		{
			//trace("GameSprites.as:updateToolSprites  for a  crew member "+crew.name+"("+crewIx+") Draw image of tool ");
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
					addToolEvents(tempTool,gameLevel);
					parentSprite.addChild(tempTool);
				}
				
				//Creates the top left corner Uses  field
				usesTextField.text = (tool.uses>=0)?""+tool.uses:"";				
				toolPosition++;		
			}
		}
		
		
		public static function getToolSpriteId(crewIx:int, toolIx:int ):String
		{
			return settings.toolImageName+settings.toolSeparator+crewIx+settings.toolSeparator+toolIx;
		}
		
		public static function getToolSelectionSpriteId(crewIx:int, toolIx:int ):String
		{
			return settings.toolSelectionName+settings.toolSeparator+crewIx+settings.toolSeparator+toolIx;
		}		

		public  static function getToolUsesSpriteId(crewIx:int, toolIx:int ):String
		{
			return settings.toolUsesName+settings.toolSeparator+crewIx+settings.toolSeparator+toolIx;
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
		
		
		public static function getParentCrewImageID(index:int):String
		{
			return "ParentBankCrewImage"+settings.storeSeparator+index;
		}
		public static function getCrewImageID(index:int):String
		{
			return "BankCrewImage"+settings.storeSeparator+index;
		}
		
		public static function getCrewImageTextID(index:int):String
		{
			return "BankCrewImageTExtID"+settings.storeSeparator+index;
		}

		
		// *****************************
		//    MESSSAGE BOX SPRITE 
		// ********************************
		public function updateMessageBox(gameLevel:GameLevel):void
		{
			
			if(messageBoxSprite == null)
			{

				messageBoxSprite = new Sprite();
				messageBoxSprite = DrawObjects.drawMessageBox(messageBoxSprite,null,settings.messageBoxWidth,settings.messageBoxHeight);
				messageBoxSprite.x = settings.messageBoxX;
				messageBoxSprite.y = settings.messageBoxY;
				messageText = new TextField();
				messageText = DrawObjects.configureLabel(messageText,
											 settings.standardFont,
											 "",
											 settings.foregroundColor,
											 settings.menuFontSize);	
				messageText.autoSize = TextFieldAutoSize.CENTER;
				messageText.width = settings.messageBoxWidth;
				messageText.wordWrap = true;
				messageText.multiline = true;
				messageTextArray = new Array();
			}
			
			var messageX:int = 0;
			var messageY:int = 0;
			messageY +=settings.messageBoxLineHeight;
			if(gameLevel.gameMessages!=null && gameLevel.gameMessages.messages.length>0)
			{
				var msg:Message = gameLevel.gameMessages.messages[0];
				messageBoxSprite.removeChildren();
				messageBoxSprite.graphics.clear();
				var msgHeight:int = (msg.mainMessage.split("\n").length+ msg.choiceText.length+1) *2.1 *settings.messageBoxLineHeight;
				messageBoxSprite = DrawObjects.drawMessageBox(messageBoxSprite,null,settings.messageBoxWidth,msgHeight);
				messageText.text = msg.title +"\n"+msg.mainMessage;
				var choiceCount:int = msg.choiceText.length;
				messageText.x = messageX;
				messageText.y = messageY;
				messageText.autoSize  = TextFieldAutoSize.CENTER;
				messageText.width = settings.messageBoxWidth;
				messageY +=settings.messageBoxLineHeight;
				messageBoxSprite.addChild(messageText);
				for(var i:int=0;i<choiceCount;i++)
				{
					messageY +=settings.messageBoxLineHeight;
					if(messageTextArray[i]==null)
					{
						messageTextArray[i] = new TextField();
						messageTextArray[i] = DrawObjects.configureLabel(messageTextArray[i] ,
											 settings.standardFont,
											 "",
											 settings.greenColor,
											 settings.menuFontSize);
						messageTextArray[i].autoSize  = TextFieldAutoSize.CENTER;
						messageTextArray[i].width  = settings.messageBoxWidth;
											 
					}
					removeMessageEvents(messageTextArray[i],msg);
					//move down apprpriate spaces
					messageY +=settings.messageBoxLineHeight;
					messageY += settings.messageBoxLineHeight*  msg.mainMessage.split("\n").length;
					if(msg.isActive)
					{
						addMessageEvents(messageTextArray[i],msg);
						messageTextArray[i].text = msg.choiceText[i];
						messageTextArray[i].width = settings.messageBoxWidth;
						messageTextArray[i].name = getMessageChoiceName(i);
						messageTextArray[i].autoSize = TextFieldAutoSize.CENTER;
						messageTextArray[i].x = messageX;
						messageTextArray[i].y = messageY;

						
						messageBoxSprite.addChild(messageTextArray[i]);
					}
				}
			}
		}
		
		
		//manages the tool tip shown at the bottom of the screen
		public function updateHelpSprites(gameLevel:GameLevel):void
		{
		
		
			if(helpIconSprite==null || helpIconText==null)
			{
				helpIconText = new TextField();
				helpIconText = DrawObjects.configureLabel(helpIconText,
											 settings.standardFont,
											 "help",
											 settings.foregroundColor,
											 settings.menuFontSize);
				helpIconText.x =0;
				helpIconText.y =0;
				helpIconSprite = new Sprite();
				helpIconSprite.name = settings.helpIdTag+gameLevel.inGameHelp.HELP;
				helpIconSprite.x = settings.helpIconX;
				helpIconSprite.y = settings.helpIconY;
				helpIconSprite.addChild(helpIconText);
				addHelpEvents(helpIconSprite,gameLevel);
				addHelpIconClickEvents(helpIconSprite,gameLevel);
			
			}
		
			if(helpSprite==null || helpMessage==null)
			{
				helpMessage = new TextField();
				helpMessage = DrawObjects.configureLabel(helpMessage,
											 settings.standardFont,
											 "",
											 settings.foregroundColor,
											 settings.toolFontSize);
											 
				helpSprite = new Sprite();
				helpSprite.x = 0;
				helpSprite.y = 0;
			}
			
			helpSprite.graphics.clear();
			
			//set the font size
			var format:TextFormat = helpMessage.defaultTextFormat;
			format.size = gameLevel.hoverMessage.fontSize;
			helpMessage.setTextFormat( format);
			helpMessage.defaultTextFormat = format;
			
			
			//set the message
			helpMessage.text = gameLevel.hoverMessage.message;
			
			//redraw the message box in case it changed size
			helpSprite = DrawObjects.drawMessageBox(helpSprite,null,
																					 gameLevel.hoverMessage.area.width,
																					  gameLevel.hoverMessage.area.height);
			
			//position it
			helpSprite.x = gameLevel.hoverMessage.area.x;
			helpSprite.y = gameLevel.hoverMessage.area.y;
			helpMessage.x = gameLevel.hoverMessage.area.x;
			helpMessage.y =gameLevel.hoverMessage.area.y;

	 }
		
		
		
		public function addHelpIconClickEvents(sprite:Sprite, gameLevel:GameLevel):void
		{
			removeHelpIconClickEvents(sprite,gameLevel);
			sprite.addEventListener(MouseEvent.CLICK, gameLevel.toggleHelp,false,0,true);	
		}
		
		public function removeHelpIconClickEvents(sprite:Sprite, gameLevel:GameLevel):void
		{
			if(sprite!=null && sprite.hasEventListener(MouseEvent.CLICK))
			{
				sprite.removeEventListener(MouseEvent.CLICK, gameLevel.toggleHelp);
			}
		}
		
		
		
		public function getMessageChoiceName(choiceIndex:int):String
		{
			return settings.CHOICEIX+choiceIndex;
		}
		
		
		public function addMessageEvents(txtMsg:TextField,msg:Message):void
		{
			removeMessageEvents(txtMsg,msg);
			txtMsg.addEventListener(MouseEvent.CLICK, msg.eventHandler,false,0,true);				
		}
		
		public function removeMessageEvents(txtMsg:TextField,msg:Message):void
		{
			if(txtMsg!=null && txtMsg.hasEventListener(MouseEvent.CLICK))
			{
				txtMsg.removeEventListener(MouseEvent.CLICK, msg.eventHandler);
			}
		}
		
		
		public function addToolEvents(tool:Sprite,gameLevel:GameLevel):void
		{
			removeToolEvents(tool,gameLevel);
			tool.addEventListener(MouseEvent.CLICK, gameLevel.toolClicked,false,0,true);				
			tool.addEventListener(MouseEvent.MOUSE_OVER, gameLevel.toolHelpHoverOn,false,0,true);				
			tool.addEventListener(MouseEvent.MOUSE_OUT, gameLevel.helpHoverOff,false,0,true);				
		}
		
		public function removeToolEvents(tool:Sprite,gameLevel:GameLevel):void
		{
			if(tool!=null && tool.hasEventListener(MouseEvent.CLICK))
			{
				tool.removeEventListener(MouseEvent.CLICK, gameLevel.toolClicked);
			}
			if(tool!=null && tool.hasEventListener(MouseEvent.MOUSE_OVER))
			{
				tool.addEventListener(MouseEvent.MOUSE_OVER, gameLevel.toolHelpHoverOn,false,0,true);		
			}
			if(tool!=null && tool.hasEventListener(MouseEvent.MOUSE_OUT))
			{
				tool.addEventListener(MouseEvent.MOUSE_OUT, gameLevel.helpHoverOff,false,0,true);				
			}
		}
		
		public function addSelectCrewEvents(crew:Sprite, gameLevel:GameLevel):void
		{
			removeSelectCrewEvents(crew, gameLevel);
			crew.addEventListener(MouseEvent.CLICK,gameLevel.crewClicked);
		}
		
		public function removeSelectCrewEvents(crew:Sprite, gameLevel:GameLevel):void
		{
			if(crew!=null && crew.hasEventListener(MouseEvent.CLICK))
			{
				crew.removeEventListener(MouseEvent.CLICK, gameLevel.crewClicked);
			}
		}
	
		
		
		
		
		public function removeEvents(gameLevel:GameLevel):void
		{
			removeMenuEvents(gameLevel);
			
			var length:int = roomSprites.length;
			var i:int=0;
			for(i=0;i<length;i++)
			{
				removeRoomEvents(roomSprites[i],gameLevel);
			}
			
			length = peopleSprites.length;
			for(i=0;i<length;i++)
			{
				removePersonEvents(peopleSprites[i],gameLevel);
			}
			
			length = crewSprites.length;
			for(i=0;i<length;i++)
			{
				removePersonEvents(crewSprites[i],gameLevel);
			}

			length = toolSprites.length;
			for(i=0;i<length;i++)
			{
				var childCount:int = toolSprites[i].children;
				for(var childIx:int=0;childIx<childCount;childIx++)
				{
					removeToolEvents(toolSprites[i].childAt(childIx),gameLevel);
				}
			}
			
			
			
		}

		// *******************
		//  REMOVE EVENTS
		// ******************
		public function cleanup(gameLevel:GameLevel):void
		{
			removeEvents(gameLevel);
		}

		
		// clears out the array and forces a har reset
		public function resetLevel():void
		{
				peopleSprites = new Array(AllLevels.maxPersonCount);
				crewSprites = new Array(AllLevels.maxCrewCount);
				roomSprites = new Array(AllLevels.maxRoomCount);
				toolSprites = new Array(AllLevels.maxToolsPerPersonCount * AllLevels.maxCrewCount) ;
				destinationSprites= new Array(AllLevels.maxCrewCount);
				weaponsRadiusSprites= new Array(AllLevels.maxCrewCount);
				toolSelectionSprites = new Array(AllLevels.maxToolsPerPersonCount * AllLevels.maxCrewCount) ;
				messageTextArray = new Array(settings.messageBoxMaxChoices);
		}
		
	}


}