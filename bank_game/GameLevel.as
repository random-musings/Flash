package
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	//this is the main game level 
	//this class handles the robbing of the bank.
	public class GameLevel
	{
		public var id:int;												//current levelid
		public var bank:Bank;										//the bank
		public var crew:Crew;										//the bank robbers
		public var timeToRob:int;									//amount of time to pul lof the heist
		public var gameSprite:GameSprites;				//all images/graphics are stored here
		private var lastTimeChecked:Number;			//current time line
		public var gameState:int;									//keeps track of what is being shown to the player
		public var gameMap:Map;									//the map of the room - used for setting NPC paths
		public var endLevel:Boolean;							//indicates if level has finished
		public var gameMessages:GameMessages;	//the messages to show to the player
		public var hoverMessage:HelpMessage;			//hover over messages for help 
		public var pathController:PathController;		//used to determin the path
		public var inGameHelp:InGameHelp;			//shows help hover
		
		//the constructor
		public function GameLevel()
		{
			//initialize all of the variables
			inGameHelp = new InGameHelp();
			id= 0;																
			bank =  new Bank();
			crew =  new Crew();
			timeToRob = 0;	
			gameSprite = new GameSprites();
			lastTimeChecked  =0;
			endLevel = false;										
			gameMessages = new GameMessages();
			hoverMessage = new HelpMessage();	
			pathController = new PathController();
			gameMap = new Map( 							
								settings.mapWidth,
								settings.mapHeight,
								settings.mapNodeSize,
								settings.mapNodeSize);
		} 
		
		
		//cleansup the level 
		public function cleanup():void
		{
			//this removes the 
			bank.cleanup();
			//crew.cleanup();//don't cleanup crew cause we want to move them to the next level
			endLevel=false;
			hoverMessage.message="";//remove current help over messages
			gameMessages.messages =[]; //remove all messages
			gameState= InGameState.PAUSED; 
			timeToRob=0;
			lastTimeChecked=0;
		
		}
		
		
		//future place holders to all saving and restoring of games
		public function serialize():String
		{	//reserved for future use 
			return "";
		}
		
		//instantiates a gamelevel from a string
		//not used
		public function deserialize():void
		{	//reserverd for future use
			
		}

		// **************************
		// GAME LOOP EVENTS
		// **************************
		
		public  function update():void //if verifyAllObject = true then ensure that rooms, 
																		//and other stuff have not moved..otherwise just check 
																		//people,crews,time,cash,safe hitpoints
		{

			if(gameSprite == null)
			{	
				trace("gamelevel.as before createGameSprite");
				gameSprite = new GameSprites();
				gameSprite.createAllSprites(this);
				gameSprite.createGameSprite(this);
				trace("gamelevel.as after createGameSprite");
			}else
			{					
				switch(gameState)
				{
					case InGameState.INBANK: 											//this is standard game play all pieces in action
											updateBankGamePieces(); 
											gameSprite.createGameSprite(this);		//update the game sprites
											break;
					case InGameState.SHOWMESSAGE:								//a message is popped up the user must click it off to continue
											gameSprite.createGameSprite(this);
											break;
					case InGameState.SHOWMENU: 									//player clicked on the menu button main.as handles the paly once it detects this state
											break;
					case InGameState.PAUSED: 											//main.as sets gameState to paused when user has paused the game 
											break;
					case InGameState.ENDLEVELSUCCESS:  					//users opened the safe
											endLevelSuccessfully();
											gameSprite.createGameSprite(this);		//show the user how much money they found
											break;
					case InGameState.ENDLEVELFAILURE:						//time ran out - heist failed
											endLevelFailure();
											gameSprite.createGameSprite(this);		//show the user the failed message
											break;
					case InGameState.ENDLEVELABANDONED:				//user pressed the flee button
											endLevelAbandoned();
											gameSprite.createGameSprite(this);		//show the user the crew ransom demand
											break;
					case InGameState.RESUME:											//game was previously paused -continue game play
										resumePlay();
										gameState = InGameState.INBANK;
										//create the screen
										gameSprite.createGameSprite(this);			//update the game sprites
										break;
				}
				

			}
			
		}
		
		
		//*********************
		//  RESUME GAME
		//*********************
		//reset items so that game proceeds as if it was never paused
		//Called after game is pasued and when player is shown an in game message (liek a person escaping the bank)
		//called from main.as 
		//called from update()
		public function resumePlay():void
		{
			//updateTools so they do not fire off out of sequence when we return
			var currDate:Date = new Date();
			crew.advanceCrewToolUsage(currDate.getTime() - lastTimeChecked);
			gameState = InGameState.INBANK;
			//updateClock so it continues where it left off
			lastTimeChecked =0;
			
			//remove the last message that was shown to the user
			if(gameMessages.messages.length>0)
			{
				gameMessages.messages.shift();
			}
		}
		
		//this function is called when a user clicked off an
		//in game message
		//currently used for when a memebr leaves a bank
		public function eventResumePlay(event:MouseEvent):void
		{
			//call the resume function
			resumePlay();
		}
		
		// ********************
		// UPDATE GAME PLAY
		// ********************
		//manages the movement of players as the bank is being robbed
		//called from update()
		public function updateBankGamePieces():void
		{
		
			//check if we opened the safe
			if(bank.safe.isOpen )
			{
				gameState = InGameState.ENDLEVELSUCCESS;
				return;
			}
			
			//check if we ran out of time
			if( timeToRob<=0)
			{
				gameState = InGameState.ENDLEVELFAILURE;
				return;
			}
	
			var currDate:Date = new Date();
			//update timer
			if(lastTimeChecked==0)
			{
				lastTimeChecked = currDate.getTime();
			}				
			if( updateTimer(lastTimeChecked))
			{
				gameSprite.updateTimerSprite(this);
			}
			
			//update people motion
			if(updateBankPeople())
			{
				gameSprite.updatePeopleSprites(this,gameSprite.peopleSprites,false);
			}
			
			//update Crew to new Positions or safe to new Damage
			if(updateCrew())
			{
				gameSprite.updatePeopleSprites(this,gameSprite.crewSprites,true);		
				gameSprite.updateSafeDamageSprites(this);

			}
			
			//check Events see if any messages waiting
			//if message waiting
			//display Messages
				
			lastTimeChecked  = currDate.getTime();
				
		}
		
		
		// **********************************
		//  Bank Safe Successfully opened
		/// **********************************
		//called from update()
		//when the bank Safe is opened
		public function endLevelSuccessfully():void
		{
			trace("gameLevel.as  EndLevelSuccessfully");
		
			//randomly generate Cash for Crew
			var cashFound:Number = (uint(Math.random() * settings.maxRandomCash) + settings.minRandomCash ); //ensure that we get at least $1000 found
			var totalCash:Number = cashFound * crew.getActiveMembers();

			//update Cash Totals
			crew.cash += cashFound ;
			gameSprite.updateCashSprite(this);
			
			//create the message
			var msg:Message = new Message();
			msg.init("Safe Opened!",
				"$"+totalCash+" found in the safe. \n Your cut is $"+cashFound+"\n",
				GameMessages.valueOK,
				GameMessages.choiceOK,
				handleEndLevelOK,
				true);
				
			//add the message to the queue
			gameMessages.add(msg); //push the message so that it will be display when loop is iterated
			gameSprite.updateMessageBox(this);
			
			//show end of level message with Return to Main Page
			gameState = InGameState.SHOWMESSAGE;
		}
		
		
		// **********************************
		//  Time ran out
		/// **********************************
		//called when the time runs out , crew is in the bank
		//called from update()
		public function endLevelFailure():void
		{
				trace("gameLevel.as  EndLevelFAILED");
				
				//create the message to show to player
				var msg:Message = new Message();
				msg.init("Bank Heist Failed",
					"The bank is surrounded!\nyou've been busted.\n",
					GameMessages.valueSurrender,
					GameMessages.choiceSurrender,
					handleEndLevelFail,
					true);
					
					//add the messages to the queue
				gameMessages.add(msg); //push the message so that it will be display when loop is iterated
				gameSprite.updateMessageBox(this);
				
				//set the game state
				gameState = InGameState.SHOWMESSAGE;	
		
		}
		
		
		// ***************************
		// Player left bank before opening safe
		// ****************************
		//called from update()
		public function endLevelAbandoned():void
		{
			trace("gameLevel.as  EndLevelAbandoned");

			//calculate a mathematically random fee to penalize the member  for fleeing a bank
			var paymentDemanded:Number = -1 * uint(Math.random() * settings.crewRansom);

			//update Cash Totals
			crew.cash += paymentDemanded;
			gameSprite.updateCashSprite(this);

			//set what function to call after message has been shown to use
			var calledFunction:Function = handleEndLevelOK;
			var message:String ="crew demands payment of $"+Math.abs(paymentDemanded)+"\n";
			
			//if you don't have enough money to pay your crew they revolt
			//game ends
			if(crew.cash<=0)
			{
					calledFunction= handleEndLevelFail;
					message+="\n You don't have enough money to pay them. \nGame Over.\n";
			}
			
			//Creates  the message to show to the user
			var msg:Message = new Message();
			msg.init("Bank Heist Failed",
				message,
				GameMessages.valueLeaveBank,
				GameMessages.choiceLeaveBank,
				calledFunction,
				true);
				
			//Updates the message sprite and changes the inGameState
			//so that the message will be shown to the user
			gameMessages.add(msg); //push the message so that it will be display when loop is iterated
			gameSprite.updateMessageBox(this);			
			gameState = InGameState.SHOWMESSAGE;	
		}
		
		
				
		// ****************
		// Returns main sprite
		// ****************
		// called by manageGame()
		// to add the bank to the main sprite
		public function getMainSprite():Sprite
		{
			return gameSprite.gameSprite;
		}
		
		
		// ******************
		//  Starts a Level
		// *****************
		// called byloadLevel to begin
		// the clock ticking and start the robbery
		//called from main.as Loadlevel()
		public function start():void
		{
			gameState = InGameState.INBANK;
			inGameHelp.showHelp= (id==1);  //automatically show help if this is the first level
			endLevel = false;
			
			resetGameSprite();
			lastTimeChecked = 0;
			endLevel =false;

			//This code has been left in - but commented out
			//because it generates the map for new levels
			//trace("creating map");
			//gameMap.createMap(DetectCollision);
			//gameMap.printMap();
			gameMap.checkNodeIndexes();
			
			//reset the messages so we don't have messages from previous levels
			gameMessages.messages =[];
			
			//ensures that the bank is not open
			bank.safe.isOpen = false;
		}
		
		
		// ********************
		// recreates a game sprite 
		// ********************
		//called from start()
		public  function resetGameSprite():void
		{
			//resets the sprites so that they match new data
			gameSprite.resetLevel();
			gameSprite.createAllSprites(this);
			gameSprite.createGameSprite(this);
		
		}
		
		
		
		// ***********************
		//     EVENTS
		// ***********************
	
		//when the user clicks the help text the tool tips are turned on or off
		public function toggleHelp(event:MouseEvent):void
		{
			//set the flag so that hover tips are turned off.
			trace("toggleHelp");
			inGameHelp.showHelp = !inGameHelp.showHelp;
		}
	

		//user  does not unlock the bank vault within the correct amount
		//level is ended and game is over
		//user just clicked SURRENDER OR OK to dismiss the message indicating 
		//that the level is over becuase they ran out of time or decided to flee but didn't have enough money to 
		//pay the crew ransom
		public function handleEndLevelFail(event:MouseEvent):void
		{
			//remove messages and set the status to the update will push the game to a new status
			trace("handle LevelFAIL");
			gameState= InGameState.ENDLEVELFAILURE;
			gameMessages.messages.shift();
			endLevel = true;
		}
		
		
		//User opened the bank vault and has already been shown the messages
		//indicating how muchmoney they have found.
		//the user just finished clicing OK and we will now load the next level (tak ethem to the store)
		public function handleEndLevelOK(event:MouseEvent):void
		{
			//users accepted the "you have completed" message so set the state so that the user us forwarded to the game store
			trace("handle Level Completed");
			endLevel = true;
			gameState= InGameState.LOADNEXTLEVEL;
			gameMessages.messages.shift();
		}

		//User chose to flee and had enough money to pay the crew ransom
		public function handleEndLevelEnded(event:MouseEvent):void
		{
			//user clicked flee and we have shown them the message with this event
			trace(" handle level abandoned :");
			gameState= InGameState.ENDLEVELABANDONED;
			if(gameMessages.messages.length>0)
			{
				//state changed and message removed
				gameMessages.messages.shift();
			}
			trace("handle LevelFAIL");
		}
		
		
		//users clicked the menu buttons
		//the menu is shown and the game is paused 
		public function menuClicked(event:MouseEvent):void
		{
			//menu icon clicked update will pause game an show menu on next iteration
			trace("GameLevel.as menuClicked");
			gameState = InGameState.SHOWMENU;
			
		}
		
		//room was clicked
		//called when user clicks on the bank 
		//if a bank crew member was already selected then
		//handleRoomSelect will call the path controller to set the 
		//path to the clicked room.
		public function roomClicked(event:MouseEvent):void
		{
			//room was clicked handle the selection of room and setting of path for a bank robber
			trace("GameLevel.as roomClicked");
			handleRoomSelect( event);
		}

		//fired only when user clicked
		//on an X or the members name
		//this selects a crew member 
		public function personClicked(event:MouseEvent):void
		{
			trace("GameLevel.as personClicked");
			//get sprite name
			var clickedSprite:Sprite = (event.currentTarget as Sprite);
			if(clickedSprite !=null)
			{
				//crew was clicked handle the update of sprites and path items
				trace(" clicked on Sprite "+clickedSprite.name);
				handleCrewMemberClick(clickedSprite);
			}
		}
		
		
		//tool was selected from the tool area at the bottom of the screen
		//this forces the bank crew memer to dropp any previously slected tool
		//and begin using this tool
		public function toolClicked(event:MouseEvent):void
		{
			var clickedSprite:Sprite = (event.currentTarget as Sprite);
			if(clickedSprite!=null)
			{
				//side bar tool was clicked so update all sprites and change the tool being used by the crew member
				var toolId:Array = clickedSprite.name.split(settings.toolSeparator);
				var crewIx:int = toolId[1];
				var toolIx:int = toolId[2];
				crew.members[crewIx].selectTool(toolIx);
				crew.selectedMember  = crewIx;
				gameSprite.updateToolSprites(this);
			}
			
		}
		
		//crew name was clicked from tool area
		//highlight the crew member
		public function crewClicked(event:MouseEvent):void
		{
			var nameSprite:Sprite = (event.currentTarget as Sprite);
			if(nameSprite!=null)
			{
				//using the name of the sprite figure out what crew member was clicked
				var crewIxArray:Array = nameSprite.name.split(settings.toolSeparator);
				crew.selectedMember = crewIxArray[1];
				gameSprite.updateToolSprites(this);
			}
		}
		
		
		// ***************************
		// MOUSE OVER HELP FUNCTIONS
		// ***************************
		//Mouse over of a tool
		//will display the tool description
		public function toolHelpHoverOn(event:MouseEvent):void
		{
			var hoveredSprite:Sprite = (event.currentTarget as Sprite);
				if(hoveredSprite!=null)
				{
		
					//get which tool was hovered its ID will be used to determin which tag should be shown
					var toolId:Array = hoveredSprite.name.split(settings.toolSeparator);
					var crewIx:int = toolId[1];
					var toolIx:int = toolId[2];
					
					//get the message
					var message:String = 	crew.members[crewIx].tools[toolIx].name.toUpperCase()+settings.newLine+crew.members[crewIx].tools[toolIx].description;
					//create the message to show to the user
					hoverMessage.setMessage(	message,
																	event.stageX,
																	event.stageY,
																	settings.toolFontSize,
																	true);
					gameSprite.updateHelpSprites(this);
				}
		}


		//Mouse is no longer hovering orver a sprite that has the help evnts added to it
		//will hide the currently displayed message 
		public function  helpHoverOff(event:MouseEvent):void
		{
			//destroy the message because the mouse is no longer over the object
			var hoveredSprite:Sprite = (event.currentTarget as Sprite);
				if(hoveredSprite!=null)
				{
					//hide the mouse over
					hoverMessage.setMessage(	"",0,0,0,false);
					gameSprite.updateHelpSprites(this);
				}
		}
		
		
		
		//called when Mouse over safe damage sprites
		// bank people
		//bank robbers
		// the help menu
		//the menu
		//the flee menu
		//the timer box
		//the cash box
		public function helpHover(event:MouseEvent):void
		{
			//if user has elected to have help tips
			if(inGameHelp.showHelp)
			{
				//get the id of the sprite
				var hoveredSprite:Sprite = (event.currentTarget as Sprite);
				if(hoveredSprite!=null)
				{
					//USE THE SPRITE ID To get the actual text
					var message:String= inGameHelp.getHelpMessage(hoveredSprite.name);
					hoverMessage.setMessage(	message,
																event.stageX,
																event.stageY,
																settings.toolFontSize,
																true);
					gameSprite.updateHelpSprites(this);
				}
			}
		}		
		
		
		// *********************
		//   GAME LOOP UPDATES		
		// *********************
		//this keeps track of updates
		//and used to determin when tools were last used
		//called from update
		public function updateTimer(lastTime:Number):Boolean
		{
			//updates the countdown clock
			//trace(" gameLevel.as UpdateTimer");
			var currDate:Date = new Date();
			timeToRob -= (currDate.getTime() - lastTime);
			timeToRob = timeToRob<0?0:timeToRob;
			return true;
		}

		
		// *****************
		//  People Updates
		// *****************
		//called from update()
		//called from updatebankpieces
		//determines new paths for them
		public function updateBankPeople():Boolean
		{
			//trace(" gameLevel.as UpdateBankPeople");
			//Path Controller using hueristics to determine the next move of the
			//person
			var pathController:PathController = new PathController();
			var someoneMoved:Boolean = true;
			var length:int = bank.people.length;
			
			//scroll through all of the active bank people
			for(var i:int=0;i<length;i++)
			{
				var person:Person = bank.people[i];
				if(person.isActive)
				{	
					//check the persons path plot a new destination if required
					var pathDetails:PathDetails =pathController.setNPCPath(person ,this);
					if(!pathDetails.destination.equal(settings.BLOCKED))
					{
						person.setPath(pathDetails);
					}
					
					//advance the person on their path
					person.advancePerson(this);
					
					//check to see if this person escaped the bank
					//if so then set of flags and events to penalize bank robbers
					if(person.isPersonFree(this))
					{	//person has left the bank - remove them from the game
						person.isActive=false;
						applyPersonLeftBankEvent();
					}
					
					if(!person.isActive)
					{	//if not active then stop drawing sprite 
						gameSprite.gameSprite.removeChild(gameSprite.peopleSprites[i]);
					}
				}
			}
			
			//return true at this time because we have not yet implement items that 
			//would allow us to determine this before scrolling through all of the bank people
			return someoneMoved;
			
		}
		
		
		// *********************
		//  UPDATE BANK ROBBERS
		// *********************
		//called from updatebankpieces
		//handles the advancing crew members inthe bank and inflicting damage on the safe
		public function updateCrew():Boolean
		{
			//trace(" gameLevel.as UpdateCrew");
		
			var someoneMoved:Boolean  =true;									//sent back to indicate if we have to update the sprites
			var damageDealt:DamageDealt = new DamageDealt();		//indicates if damage was done to the safe
			var someoneInSafeRoom:Boolean;										//indicates if someon is in safe room - if this is false then a ? is shown instead of vault image

			//scroll through all active bank members
			var length:int = crew.members.length;			
			for(var i:int=0;i<length;i++)
			{
				var crewMember:Person = crew.members[i];
				if(crewMember.isActive)
				{
					//if in safe Room
					//	update Safe Damage
					if(bank.detectPointInSafe(crewMember.position))
					{
						someoneInSafeRoom = true;
						//only apply damage if the person is not moving - this ensure that they have finished their "path" before attacking vault
						if(crewMember.velocity.equal(settings.ZEROVELOCITY))
						{
							//check to see if the tool they are using will be applying damage this turn
							damageDealt.add( crewMember.getDamageDealt());
						}
					}
					//advance crewMember
					crewMember.advancePerson(this);

					//future enhancements
					//if crewMember within pickPocketRadius
					//	setEventPickPersonsPocket
					//if crewOverwelmedBy BankPeople
					//	setRandomEventFight()
					
				}
			}	
			
			//if there is damage to be applied to the safe
			if(damageDealt.doesDamage)
			{
				//update the safe with new totals
				bank.safe.updateSafeDamage(damageDealt);
				
				//update the toolSprites (decrements the number of uses)
				gameSprite.updateToolSprites(this);
			}
			
			//ensure that if crew leaves the safe room the user is notified that no damage is happening to safe
			bank.safe.isFound= someoneInSafeRoom;
			return someoneMoved;
		}
		
		
		// **********************
		// SELECT/HIGHLIGHT CREW MEMBER
		// **********************
		//called when the Crew member name is clicked in the tools section
		//highlights the crew name and selected tool (changes font from grey to white
		public function handleCrewMemberClick(crewMember:Sprite):void
		{
			trace(" gameLevel.as handleCrewMemberClick");

			// highlight tool bar of tools
			// highlight crew member on Screen
			// start first half of destination event
			var length:int = crew.members.length;
			for(var i:int=0;i<length;i++)
			{
				if(crew.members[i].isActive && crewMember.name == Crew.CLASSID+crew.members[i].name )
				{
					//sets the selected crew member 
					crew.selectedMember = i;
					gameSprite.updateToolSprites(this);					
					return;
				}
			}

			//if now crew member found then delsect all creww members
			DeselectCrew(); 
			
		}
		
		// *******************
		// SELECT ROOM
		// ******************
		//called when a room in the bank is clicked
		//this function checks to see if a crew member is selected 
		//if so then it finds a path to the room form the selected crew member
		public function handleRoomSelect( event:MouseEvent):void
		{
			//ensure event is not null
			if(event ==null)
			{
				DeselectCrew();//deselect the crew
				return;			
			}
			
			//gets the position in the bank
			var point:cPoint  = new cPoint(event.localX,event.localY,0);
			var room:Room  = bank.getRoomUsingPoint(point);
			if(room==null)
			{
				DeselectCrew();//deselect the crew
				return;
			}

			//ensure they don't click on a non-traversable space
			if(room.doorType== DoorType.NONE)
			{	//do not allow selections inside of doorless rooms
				return;
			}
			if(crew.selectedMember>-1)
			{
				//if a crew member was previously selected then set a path to the room that was selected
				if( crew.selectedMember< crew.members.length
					&& crew.members[crew.selectedMember].isActive)
				{
					//get the robber
					var robber:Person = crew.members[crew.selectedMember];
					point = room.resetAvailablePointInRoom(point,robber.getRadius());
					
					//clear the existing path
					robber.clearPath();
					
					//get a new path
					var destination:cPoint = new cPoint(point.x,point.y,0);
					trace(" move to point "+destination.serialize());
					trace("GameLevel.as: 729 RoomSelect callin path COntroller");
					robber.setPath(pathController.determinePath(destination,robber, this));
				}
			}	
			DeselectCrew();//deselect the crew
		}
		
		
		// ***********************
		// * DESELECT CREW
		// ***********************		
		//called from handleRoomSelect
		//handleCrewMemberClick
		public function DeselectCrew():void
		{
			//deselect all crew
			crew.selectedMember = -1; //deselect the CrewMember
			gameSprite.updateToolSprites(this);
		}
		
		
		// ***********************
		// *  COLLISIONS
		// ***********************
		//this function is not called during game play
		//it is here because it is passed to the map class 
		//when creating new levels
		//new level maps are not created on the fly because they cause significant lag (sigh)
		// when loading a new level
		//see AllMaps.as to view the output from the map
		public function DetectCollision(obstacle:Rect):int
		{
			//scroll through all rooms 
			//determine if collision with room
			//determine if point outside of bank

			//figure out what is a safe distance fro the walls would be
			var radius:int =Math.max(obstacle.width,obstacle.height);
			
			//scroll through the rooms determining if we are standing in 
			var length:int= bank.rooms.length;
			for(var i:int=0;i<length;i++)
			{
				var room:Room = bank.rooms[i];
				if(room.collidesWithWalls(obstacle) )
				{
					return NodeState.OBSTACLE;
				}	
			}
		
			//verify that the point is in the room or not
			if(bank.layout.collidesWithWalls(obstacle) 
			|| !bank.layout.pointInRoom(new cPoint(obstacle.x,obstacle.y,0)))
			{	//we are not in the bank
				// or we collided with its outer walls 
				//so return WALL/Obstacle indicator
				return NodeState.OBSTACLE;
			}

			//we didn't hit anything  and we are standing in a room  so indicate that it is open
			return NodeState.OPEN;
		}
		
		
		
		//called form updatePerson() 
		//when a person manages to flee the bank
		//we penalize th bank robber 10 seconds
		public function applyPersonLeftBankEvent():void
		{
			//decrement the time to rob
			timeToRob -= settings.penaltyPersonLeftBank;

			var timeString:String = DrawObjects.timeToString(timeToRob);
			timeString += (timeString.indexOf(":"))?"":" seconds";
			
			//create the message
			var msg:Message = new Message();
			msg.init("Someone Escaped!",
				"You have "+timeString+" left.\n",
				GameMessages.valueOK,
				GameMessages.choiceOK,
				eventResumePlay,
				true);
				
			//add the message to the queue
			gameMessages.add(msg); //push the message so that it will be display when loop is iterated
			gameSprite.updateMessageBox(this);
			
			//show end of level message with Return to Main Page
			gameState = InGameState.SHOWMESSAGE;
		}


		
	}


}