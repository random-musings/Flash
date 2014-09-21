package{

	//this class holdsAll Levels for the game
	//when a new level is loaded
	//the class main.as loads a level by calling 
	
	public class AllLevels
	{
	
		//I created a bunch of constants 
		//so I can create arrays once and then just re-init memory
		public static const maxRoomCount:int = 15;		//maximum rooms per bank
		public static const maxPersonCount:int = 10;	//maxmimum number of bank people
		public static const maxCrewCount:int = 10;		//maximum  number of members per crew
		public static const maxToolsPerPersonCount:int = 10;	//maximum number of tools per person
		
		public static const maxLevel:int=2;			//current number of levels
		
		// *********************
		//       TOOLS
		// *********************
		public static var allTools:AllTools = new AllTools();	//all tools that can be used in the game
		public static var allMaps:AllMaps = new AllMaps();	//all the maps for eveny level
	
		public function AllLevels()
		{	
		//the constructor
		}
		
		
		//This is the entry point for this class
		//called  from main.as  loadLevel()
		//creates a gameLevel and returns it (all values are reset)
		public static function getLevel(index:int,gameLevel:GameLevel):GameLevel
		{
			//the requested level is passed in and the appropriate Level1,2,3, function is called
			switch(index)
			{		
				case 1: return AllLevels.Level1(gameLevel);
				case 2: return AllLevels.Level2(gameLevel);
				default: return null;
			}
		}
		
		//thie function resets/initializes levels and all varianbles assoicated
		//this functionis called from deactivateLevel()
		private static function initLevel():GameLevel
		{
			//initialize the level
			var gameLevel:GameLevel = new GameLevel();
			
			//create the bank and all of its rooms
			gameLevel.bank = new Bank();
			gameLevel.bank.rooms = new Array(maxRoomCount);
			for(var i:int = 0;i<maxRoomCount;i++)
			{
				if(gameLevel.bank.rooms[i]==null)
				{
					gameLevel.bank.rooms[i] = new Room();
				}
				gameLevel.bank.rooms[i].isActive=false;
					
			}
			
			//create the bank room
			gameLevel.bank.layout = new Room();
			
			//create the safe
			gameLevel.bank.safe = new Safe();
			
			//create the people in the bank
			gameLevel.bank.people = new Array(maxPersonCount);
			for(var j:int=0;j<maxPersonCount;j++)
			{
				if(gameLevel.bank.people[j]==null)
				{
					gameLevel.bank.people[j] = new Person();
				}
				//set them all to inactive so we can intialize them when necessary
				gameLevel.bank.people[j].isActive=false;
			}				
			
			//create the arrays to hold the robbers
			gameLevel.crew = new Crew();
			gameLevel.crew.members = new Array(maxCrewCount);
			for(var k:int=0;k<maxCrewCount;k++)
			{
				if(gameLevel.crew.members[k]==null)
				{
					gameLevel.crew.members[k] = new Person();
				}
				//set them to inactive so that we only have 
				gameLevel.crew.members[k].isCrew=true;	
				gameLevel.crew.members[k].isActive=false;	
			}	

			return gameLevel;
		}
		
		//set all objects to inactive so that the nextlevel can
		//set them to new values
		//called by Level1, Level2, Level3, etc it resets the arrays 
		private static function deactivateGameLevel(gameLevel:GameLevel,deactivateCrew:Boolean):GameLevel
		{
			//if this is the first time through then initialize the game Levle
			if(gameLevel==null)
			{
				gameLevel = initLevel();
			}

				//if bank has not be set then intialize the ban
			if(gameLevel.bank == null)
			{
				gameLevel.bank = new Bank();
			}
			
			//create the safe it is null
			if(gameLevel.bank.safe==null)
			{
				gameLevel.bank.safe = new Safe();
			}
			
			//create the arrays for the bank
			if(gameLevel.bank.layout==null)
			{
				gameLevel.bank.layout = new Room();
				gameLevel.bank.layout.isActive=true;
			}			
			
			//create the arrays for the bank room
			if(gameLevel.bank.rooms!=null)
			{
				gameLevel.bank.rooms=[];
				gameLevel.bank.rooms = new Array(AllLevels.maxRoomCount);
			}	
			
			//hide all rooms so new level can set them correctly
			if(gameLevel.bank.rooms == null || gameLevel.bank.rooms.length <maxRoomCount)
			{
				gameLevel.bank.rooms = new Array(maxRoomCount);
			}
			
			
			//init the rooms
			for(var i:int = 0;i<maxRoomCount;i++)
			{
				if(gameLevel.bank.rooms[i]==null)
					gameLevel.bank.rooms[i] = new Room();
				gameLevel.bank.rooms[i].isActive=false;
			}		

			//deactivate extra people in bank
			if(gameLevel.bank.people == null || gameLevel.bank.people.length <maxPersonCount)
			{
				gameLevel.bank.people = new Array(maxPersonCount);
			}
			
			//deactivate extra crew we are reseting bank to zero
			if(deactivateCrew)
			{
				for(var j:int=0;j<maxPersonCount;j++)
				{
					if(gameLevel.crew.members[j]==null)
					{
						gameLevel.crew.members[j] = new Person();
					}
					gameLevel.crew.members[j].isCrew=true;
					gameLevel.crew.members[j].isActive=false;
				}
			}	
				return gameLevel;
		}
		

		//  *********************************************
		// 	LEVEL 1
		//  *********************************************
		//adjusts game Level  so it is reflects the new bank layout and people
		//called by getLevel
		private static function Level1(gameLevel:GameLevel):GameLevel
		{
		
			
			//hide previous level items - ensure everything is initialized
			gameLevel = deactivateGameLevel(gameLevel,true);
			
			gameLevel.timeToRob  = 130000;  //in milliseconds
			
			// *******************
			//  GAME MAP LEVEL 1
			// *******************
			gameLevel.id=1;
			gameLevel.gameMap.copyNodes(allMaps.getMap(1));
		
			// ********************
			//       BANK LEVEL 1
			// ********************
			gameLevel.bank.name = "Slave Day Loans";
			gameLevel.bank.layout.init("Bank",0,0,settings.bankRoomWidth,settings.bankRoomHeight, //location and dimensions
									DoorLocation.BOTTOM_CENTER, DoorType.SINGLE, //location and type
									-1, false,true);//image attached to room
									

			// ********************
			//       ROOMS LEVEL 1
			// ********************										
			gameLevel.bank.rooms[0].init("room1",0,0,settings.roomWidth,settings.roomHeight,
									DoorLocation.BOTTOM_LEFT,DoorType.SINGLE,
									-1,false,true);

			gameLevel.bank.rooms[1].init("room2",settings.roomWidth,0,settings.roomWidth,settings.roomHeight,
									DoorLocation.BOTTOM_LEFT,DoorType.SINGLE,
									-1,false,true);

			gameLevel.bank.rooms[2].init("room3",2*settings.roomWidth,0,settings.roomWidth,settings.roomHeight,
									DoorLocation.BOTTOM_LEFT,DoorType.SINGLE,
									-1,false,true);
									
			gameLevel.bank.rooms[3].init("saferoom",3*settings.roomWidth,0,settings.roomWidth+28,settings.roomHeight,
									DoorLocation.BOTTOM_RIGHT,DoorType.SINGLE,
									-1,true,true);


			gameLevel.bank.rooms[4].init("deskLeft",50,150,50,20,
									DoorLocation.NONE,DoorType.NONE,
									-1,false,true);

			gameLevel.bank.rooms[5].init("deskMiddle",170,150,50,20,
									DoorLocation.NONE,DoorType.NONE,
									-1,false,true);

			gameLevel.bank.rooms[6].init("deskRight",290,150,50,20,
									DoorLocation.NONE,DoorType.NONE,
									-1,false,true);
									
			// ********************
			//    SAFE LEVEL 1
			// ********************
			gameLevel.bank.safe.init(
						"Bash  Wildly Model IV",
						80,//var physicalHP:int,
						3,//var mechanicalHP:int,
						-1,//var electronicHP:int,
						GameImages.SAFE2,// var imageIx:int,
						GameImages.SAFE2OPENED,
						false,//var twoPeople:Boolean,
						150,//var newMoney:int);
						true,//is active:Boolean
						false, //has been found
						new cPoint(100,220,0),
						false); //isOpen


			// ********************
			//    PEOPLE IN BANK LEVEL 1
			// ********************			
			
			gameLevel.bank.people[0].init(
					"A",//newName:String,
					-1,//newImage:int,
					new cPoint(30,130,0),//newPosition:cPoint,
					new cPoint(0,0,0),//newVelocity:cPoint,
					settings.personHeight,//newHeight:int,
					settings.personWidth,//newWidth:int,
					false,//newIsCrew:Boolean,
					null,//newTools:Array,
					0,//newChanceOfFight:int,
					100,//newChanceOfRun:int,
					true,//isActive:Boolean,
					0,//newCashInWallet:int
					new cPoint(250,120,0),//destination
					-1,
					false,
					null); //tool in use
					
			gameLevel.bank.people[1].init(
					"B",//newName:String,
					-1,//newImage:int,
					new cPoint(210,120,0),//newPosition:cPoint,
					new cPoint(0,0,0),//newVelocity:cPoint,
					settings.personHeight,//newHeight:int,
					settings.personWidth,//newWidth:int,
					false,//newIsCrew:Boolean,
					null,//newTools:Array,
					0,//newChanceOfFight:int,
					100,//newChanceOfRun:int,
					true,//isActive:Boolean,
					0,//newCashInWallet:int
					new cPoint(70,120,0),  //destination
					-1,
					false,
					null); //tool in use		
						
			gameLevel.bank.people[2].init(
					"C",//newName:String,
					-1,//newImage:int,
					new cPoint(150,50,0),//newPosition:cPoint,
					new cPoint(0,0,0),//newVelocity:cPoint,
					settings.personHeight,//newHeight:int,
					settings.personWidth,//newWidth:int,
					false,//newIsCrew:Boolean,
					null,//newTools:Array,
					0,//newChanceOfFight:int,
					100,//newChanceOfRun:int,
					true,//isActive:Boolean,
					0,//newCashInWallet:int
					new cPoint(70,170,0), //destination
					-1,
					false,
					null);//tool in use;	

			
					
			// ********************
			//      CREW LEVEL 1
			// ********************		
			gameLevel.crew.cash = 100;
			var crew1Tools:Array = new Array();
			var randItem:int = ( Math.random()*100 ) % allTools.toolArray.length;
			crew1Tools.push(allTools.toolArray[randItem].clone());
			crew1Tools[0].inUse=true;
			crew1Tools[0].uses   =crew1Tools[0].uses  >2?2:crew1Tools[0].uses ;
			gameLevel.crew.members[0].init(
					"Chet",//newName:String,
					-1,//newImage:int,
					new cPoint(140,250,0),//newPosition:cPoint,
					new cPoint(0,0,0),//newVelocity:cPoint,
					settings.personHeight,//newHeight:int,
					settings.personWidth,//newWidth:int,
					true,//newIsCrew:Boolean,
					crew1Tools,//newTools:Array,
					0,//newChanceOfFight:int,
					0,//newChanceOfRun:int,
					true,//isActive:Boolean,
					0,//newCashInWallet:int
					new cPoint(140,230,0),//destination
					0,
					false,
					null);  //tool in hand
					
				var crew2Tools:Array = new Array();
				crew2Tools.push(allTools.sledgeHammer.clone());
				crew2Tools[0].inUse=true;
				gameLevel.crew.members[1].init(
					"Dan",//newName:String,
					-1,//newImage:int,
					new cPoint(160,250,0),//newPosition:cPoint,
					new cPoint(0,0,0),//newVelocity:cPoint,
					settings.personHeight,//newHeight:int,
					settings.personWidth,//newWidth:int,
					true,//newIsCrew:Boolean,
					crew2Tools,//newTools:Array,
					0,//newChanceOfFight:int,
					0,//newChanceOfRun:int,
					true,//isActive:Boolean,
					0,//newCashInWallet:int
					new cPoint(160,230,0), //destination
					0,
					false,
					null);  //tool in hand
					
				var crew3Tools:Array = new Array();
				crew3Tools.push(allTools.sledgeHammer.clone());
				crew3Tools[0].inUse=true;
				gameLevel.crew.members[2].init(
					"Roy",//newName:String,
					-1,//newImage:int,
					new cPoint(180,250,0),//newPosition:cPoint,
					new cPoint(0,0,0),//newVelocity:cPoint,
					settings.personHeight,//newHeight:int,
					settings.personWidth,//newWidth:int,
					true,//newIsCrew:Boolean,
					crew3Tools,//newTools:Array,
					0,//newChanceOfFight:int,
					0,//newChanceOfRun:int,
					true,//isActive:Boolean,
					0,//newCashInWallet:int
					new cPoint(180,230,0), //destination
					0,
					false,
					null
					);  //tool in hand

					
			return gameLevel;
		}
		
		
		
		// *************************************
		// *************************************
		// ***********   LEVEL 2 ***************
		// *************************************
		// *************************************
		//called by getLevel()
		public static function Level2(gameLevel:GameLevel):GameLevel
		{
		//hide previous level items - ensure everything is initialized
			gameLevel = AllLevels.deactivateGameLevel(gameLevel,false);
			gameLevel.id=2;
			gameLevel.timeToRob  = 130000;  //in milliseconds
			
			
			// *******************
			//  GAME MAP LEVEL 2
			// *******************
			gameLevel.gameMap.copyNodes(allMaps.getMap(gameLevel.id));
		
			// ********************
			//       BANK  LEVEL 2
			// ********************
			gameLevel.bank.name = "Bank of Indentured Servants";
			gameLevel.bank.layout.init("Bank",0,0,settings.bankRoomWidth,settings.bankRoomHeight, //location and dimensions
									DoorLocation.BOTTOM_CENTER, DoorType.SINGLE, //location and type
									-1, false,true);//image attached to room
									
			// ********************
			//       ROOMS  LEVEL 2
			// ********************										
			gameLevel.bank.rooms[0].init("lefttop",0,0,settings.roomWidth,settings.roomHeight,
									DoorLocation.RIGHT_BOTTOM,DoorType.SINGLE,
									-1,false,true);

			gameLevel.bank.rooms[1].init("leftmiddle",0,settings.roomHeight,settings.roomWidth,settings.roomHeight,
									DoorLocation.RIGHT_BOTTOM,DoorType.SINGLE,
									-1,false,true);

			gameLevel.bank.rooms[2].init("leftbottom",0,2*settings.roomHeight,settings.roomWidth,settings.roomHeight+7,
									DoorLocation.RIGHT_BOTTOM,DoorType.SINGLE,
									-1,false,true);
									
			gameLevel.bank.rooms[3].init("saferoom",3*settings.roomWidth+28,0,settings.roomWidth,settings.roomHeight,
									DoorLocation.LEFT_BOTTOM,DoorType.SINGLE,
									-1,true,true);


			gameLevel.bank.rooms[4].init("deskLeftM",130,70,40,20,
									DoorLocation.NONE,DoorType.NONE,
									-1,false,true);

			gameLevel.bank.rooms[5].init("deskLeftL",130,150,40,20,
									DoorLocation.NONE,DoorType.NONE,
									-1,false,true);

			gameLevel.bank.rooms[6].init("deskLeftU",220,150,40,20,
									DoorLocation.NONE,DoorType.NONE,
									-1,false,true);

			gameLevel.bank.rooms[7].init("deskRightU",220,70,40,20,
									DoorLocation.NONE,DoorType.NONE,
									-1,false,true);									


			gameLevel.bank.rooms[8].init("rightmiddle",3*settings.roomWidth+28,settings.roomHeight,settings.roomWidth,settings.roomHeight,
									DoorLocation.LEFT_BOTTOM,DoorType.SINGLE,
									-1,false,true);
									
			gameLevel.bank.rooms[9].init("rightbottom",3*settings.roomWidth+28,2*settings.roomHeight,settings.roomWidth,settings.roomHeight+7,
									DoorLocation.LEFT_BOTTOM,DoorType.SINGLE,
									-1,false,true);
									
			// ********************
			//    SAFE  LEVEL 2
			// ********************
			gameLevel.bank.safe.init(
						"Cash & Carry CCXII",
						120,//var physicalHP:int,
						3,//var mechanicalHP:int,
						60,//var electronicHP:int,
						GameImages.SAFE3,// var imageIx:int,
						GameImages.SAFE3OPENED,
						false,//var twoPeople:Boolean,
						150,//var newMoney:int);
						true,//is active:Boolean
						false, //has been found
						new cPoint(100,220,0),
						false); //isOpen


			// ********************
			//    PEOPLE IN BANK  LEVEL 2
			// ********************			
			gameLevel.bank.people[0].init(
					"A",//newName:String,
					-1,//newImage:int,
					new cPoint(30,130,0),//newPosition:cPoint,
					new cPoint(0,0,0),//newVelocity:cPoint,
					settings.personHeight,//newHeight:int,
					settings.personWidth,//newWidth:int,
					false,//newIsCrew:Boolean,
					null,//newTools:Array,
					0,//newChanceOfFight:int,
					100,//newChanceOfRun:int,
					true,//isActive:Boolean,
					0,//newCashInWallet:int
					new cPoint(250,120,0),//destination
					-1,
					false,
					null); //tool in use
					
			gameLevel.bank.people[1].init(
					"B",//newName:String,
					-1,//newImage:int,
					new cPoint(200,120,0),//newPosition:cPoint,
					new cPoint(0,0,0),//newVelocity:cPoint,
					settings.personHeight,//newHeight:int,
					settings.personWidth,//newWidth:int,
					false,//newIsCrew:Boolean,
					null,//newTools:Array,
					0,//newChanceOfFight:int,
					100,//newChanceOfRun:int,
					true,//isActive:Boolean,
					0,//newCashInWallet:int
					new cPoint(70,120,0),  //destination
					-1,
					false,
					null); //tool in use		
						
			gameLevel.bank.people[2].init(
					"C",//newName:String,
					-1,//newImage:int,
					new cPoint(150,50,0),//newPosition:cPoint,
					new cPoint(0,0,0),//newVelocity:cPoint,
					settings.personHeight,//newHeight:int,
					settings.personWidth,//newWidth:int,
					false,//newIsCrew:Boolean,
					null,//newTools:Array,
					0,//newChanceOfFight:int,
					100,//newChanceOfRun:int,
					true,//isActive:Boolean,
					0,//newCashInWallet:int
					new cPoint(70,170,0), //destination
					-1,
					false,
					null);//tool in use;	
					
					// ********************
					//   Crew Reset the positions
					// *******************
					var startPosition:cPoint =new cPoint(140,230,0);
					var addPosition:cPoint  = new cPoint(20,0,0);
					var crewCount:int = gameLevel.crew.members.length;
					for(var crewIx:int=0;crewIx<crewCount;crewIx++)
					{
						if(gameLevel.crew.members[crewIx]!=null 
							&& gameLevel.crew.members[crewIx].isActive)
						{
							gameLevel.crew.members[crewIx].position.x = startPosition.x;
							gameLevel.crew.members[crewIx].position.y = startPosition.y;
							startPosition.add(addPosition);
							gameLevel.crew.members[crewIx].setPath(new PathDetails);
						}
					}
				return gameLevel;
		
		}
		
		
		
	}


}