package
{
	//the class holds all possible tools to be used in the game
	///]this called from AllLevels.Level1  Level2
	//GameStore.as calls this to randomize items in the game store
	public class AllTools
	{
	
		//all of the tools
		public var sledgeHammer:Tool;
		public var lockPickSet:Tool;
		public var nitricAcid:Tool;
		public var pryBar:Tool;
		public var drill:Tool;
		public var dynamite:Tool;
		public var dryIce:Tool;
		public var scope:Tool;
		public var nitrogen:Tool;
		public var liquidDynamite:Tool;
		public var electronicSurge:Tool;
		public var timerCracker:Tool;
		public var cuttingTorch:Tool;
		public var pistol:Tool;
		public var flameThrower:Tool;
		
		public var toolArray:Array;
		
		public function AllTools()
		{
			//the constructor
			initAllTools();
			
			//create an array so it is easy to randomly generate list of array
			initToolArray();
		}		
		
		
		//creates all othe tools for the game
		//called from AllTools intiConstructor
		private function initAllTools():void
		{
				sledgeHammer = new Tool();
				sledgeHammer.init("mauls",
								"Bash your way into a safe.\nDeals 2 damage every 5 seconds.\nCrowd yields within 5 meters", 
								5000, //5 seconds
								2, //2 hit points
								0, // does not aid in picking locks
								0, //does not aid in working with timers
								20, //for 10 pixels around crew member people are paralyzed								
								0,  //has no effect onoverall bank timer
								-1, //can be used indefinetly
								600,//cost to buy
								GameImages.SLEDGEHAMMER,
								false, //in Use?
								true, //requires hands to use
								"missed",
								15,//percentage instrument will miss
								1 // maximum uses that can be carried
								); 

				lockPickSet = new Tool();
				lockPickSet.init("lock picks",
								"Picks a lock every 50 seconds.\n ", 
								50000, //50 seconds
								0, //does no  hit point damage
								1, // aids in picking locks
								0, //does not aid in working with timers
								0, //for 10 pixels around crew member people are paralyzed								
								0,  //has no effect on overall bank timer
								-1, //can be used indefinetly
								1200,//cost to buy
								GameImages.LOCKPICKSET,
								false,//in Use?
								true, //requires hands to use
								"clink",
								30, //percentage instrument will miss
								1 //maximum uses that can be carried
								);
			
				nitricAcid= new Tool();
				nitricAcid.init("Nitric Acid",
								"Dissolves metal i.e. doors, hinges, locks.\nDeals 20 damage every 30 seconds.\nDefeats 1 lock every 30 seconds.", 
								30000, //30 seconds
								20, //does   hit point damage
								1, // aids in picking locks
								0, //does not aid in working with timers
								0, //for 10 pixels around crew member people are paralyzed								
								0,  //has no effect on overall bank timer
								3, //number of uses  (-1 = can be used indefinetly )
								600,//cost to buy
								GameImages.NITRICACID,
								false,//in Use?
								true, //requires hands to use
								"fizzled",
								30 , //percentage instrument will miss	
								3 //maximum uses that can be carried	
								);
				pryBar = new Tool();
				pryBar.init("Pry bar",
								"Prys open safe doors.\nDeals 3 damage every 3 seconds.\nCrowd yields within 4 meters.", 
								3000, //time between attacks
								3, //does   hit point damage
								0, // aids in picking locks
								0, //does not aid in working with timers
								18, //for 10 pixels around crew member people are paralyzed								
								0,  //has no effect on overall bank timer
								-1, //number of uses  (-1 = can be used indefinetly )
								800,//cost to buy
								GameImages.PRYBAR,
								false,//in Use?
								true, //requires hands to use
								"slipped",
								20,//percentage instrument will miss	
								1); //maximum uses that can be carried	
				drill = new Tool();
				drill.init("Drill",
								"Drills holes into locks.\nDefeats 1 lock every 45 seconds.", 
								45000, //time between attacks 
								1, //does   hit point damage
								1, // aids in picking locks
								0, //does not aid in working with timers
								0, //for 10 pixels around crew member people are paralyzed								
								0,  //has no effect on overall bank timer
								-1, //number of uses  (-1 = can be used indefinately )
								2000,//cost to buy
								GameImages.DRILL,
								false,//in Use?
								true, //requires hands to use
								"slipped",
								20 , //percentage instrument will miss	
								1 //maximum uses that can be carried
								);
				
				dynamite = new Tool();
				dynamite.init("dynamite sticks",
								"Blows stuff up.\nDeals 100 damage every 25 seconds.\nHigh failure rate", 
								25000, //time between attacks
								100, //does   hit point damage
								0, // aids in picking locks
								0, //does not aid in working with timers
								0, //for 10 pixels around crew member people are paralyzed								
								0,  //has no effect on overall bank timer
								3, //number of uses  (-1 = can be used indefinately )
								4000,//cost to buy
								GameImages.DYNAMITE,
								false,//in Use?
								true, //requires hands to use
								"dud",
								50,//percentage instrument will miss	
								3 //maximum uses that can be carried
								);
					
				dryIce = new Tool();
				dryIce.init("dry ice",
								"Freezes metal making it shatter.\nDeals 35 damage every 23 seconds.", 
								23000, //time between attacks
								35, //does   hit point damage
								0, // aids in picking locks
								0, //does not aid in working with timers
								0, //for 10 pixels around crew member people are paralyzed								
								0,  //has no effect on overall bank timer
								2, //number of uses  (-1 = can be used indefinately )
								3000,//cost to buy
								GameImages.DRYICE,
								false,//in Use?
								true, //requires hands to use
								"",
								0,//percentage instrument will miss	
								3 //maximum uses that can be carried
								);
				scope = new Tool();
				scope.init("sthethoscopes",
								"Sthethoscope makes lock clicks audible.\nDefeats 1 lock every 40 seconds.", 
								40000, //time between attacks
								0, //does   hit point damage
								1, // aids in picking locks
								0, //does not aid in working with timers
								0, //for 10 pixels around crew member people are paralyzed								
								0,  //has no effect on overall bank timer
								-1, //number of uses  (-1 = can be used indefinately )
								2500,//cost to buy
								GameImages.SCOPE,
								false,//in Use?
								true, //requires hands to use
								"clickety",
								20,//percentage instrument will miss	
								1 //maximum uses that can be carried
								);
				nitrogen = new Tool();
				nitrogen.init("liquid nitrogen",
								"Seeps into cracks and freezes metal.\nDeals 90 damage every 20 seconds", 
								20000, //time between attacks
								90, //does   hit point damage
								0, // aids in picking locks
								0, //does not aid in working with timers
								0, //for 10 pixels around crew member people are paralyzed								
								0,  //has no effect on overall bank timer
								2, //number of uses  (-1 = can be used indefinately )
								10500,//cost to buy
								GameImages.NITROGEN,
								false,//in Use?
								true, //requires hands to use
								"",
								0,//percentage instrument will miss	
								3 //maximum uses that can be carried
								);		
				liquidDynamite = new Tool();
				liquidDynamite.init("liquid dynamite",
								"Seeps into cracks and explodes.\nDeals 110 damage every 27 seconds.\nDefeats 1 lock every 27 seconds", 
								27000, //time between attacks
								110, //does   hit point damage
								1, // aids in picking locks
								0, //does not aid in working with timers
								0, //for 10 pixels around crew member people are paralyzed								
								0,  //has no effect on overall bank timer
								2, //number of uses  (-1 = can be used indefinately )
								10800,//cost to buy
								GameImages.LIQUIDDYNAMITE,
								false,//in Use?
								true, //requires hands to use
								"gurgle",
								30,
								3);//percentage instrument will miss
				electronicSurge = new Tool();
				electronicSurge.init("surge units",
								"Damages electrical mechanisms.\n10 surge damage every 5 seconds.", 
								5000, //time between attacks
								0, //does   hit point damage
								0, // aids in picking locks
								10, //does not aid in working with timers
								0, //for 10 pixels around crew member people are paralyzed								
								0,  //has no effect on overall bank timer
								-1, //number of uses  (-1 = can be used indefinately )
								5000,//cost to buy
								GameImages.ELECTRONICSURGE,
								false,//in Use?
								true, //requires hands to use
								"zap",
								30, //percentage instrument will miss
								1);
				timerCracker = new Tool();
				timerCracker.init("electronic timers",
								"Defeats time protected safes.\n15 surge damage every 9 seconds.", 
								90000, //time between attacks
								0, //does   hit point damage
								0, // aids in picking locks
								15, //does not aid in working with timers
								0, //for 10 pixels around crew member people are paralyzed								
								0,  //has no effect on overall bank timer
								-1, //number of uses  (-1 = can be used indefinately )
								6000,//cost to buy
								GameImages.TIMERCRACKER,
								false,//in Use?
								true, //requires hands to use
								"zap",
								30,//percentage instrument will miss	
								1);	
				cuttingTorch = new Tool();
				cuttingTorch.init("cutting torches",
								"Cuts through Steel.\nDeals 20 damage every 10 seconds.", 
								10000, //time between attacks
								20, //does   hit point damage
								0, // aids in picking locks
								0, //does not aid in working with timers
								0, //for 10 pixels around crew member people are paralyzed								
								0,  //has no effect on overall bank timer
								-1, //number of uses  (-1 = can be used indefinately )
								15500,//cost to buy
								GameImages.TORCH,
								false,//in Use?
								true, //requires hands to use
								"hiss",
								30,
								1);//percentage instrument will miss	
				
				pistol = new Tool();
				pistol.init("pistol",
								"Intimidates bank personnel.\nCrowd yields within 20 meters.", 
								0, //time between attacks
								0, //does   hit point damage
								0, // aids in picking locks
								0, //does not aid in working with timers
								50, //for 10 pixels around crew member people are paralyzed								
								0,  //has no effect on overall bank timer
								-1, //number of uses  (-1 = can be used indefinately )
								8500,//cost to buy
								GameImages.PISTOL,
								false,//in Use?
								true, //requires hands to use
								"hiss",
								30,
								1);//percentage instrument will miss	
								

				flameThrower = new Tool();
				flameThrower.init("flame thrower",
								"Intimidates bank personnel.\nCrowd yields within 25 meters.", 
								0, //time between attacks
								0, //does   hit point damage
								0, // aids in picking locks
								0, //does not aid in working with timers
								55, //for 10 pixels around crew member people are paralyzed								
								0,  //has no effect on overall bank timer
								-1, //number of uses  (-1 = can be used indefinately )
								16500,//cost to buy
								GameImages.FLAMETHROWER,
								false,//in Use?
								true, //requires hands to use
								"hiss",
								30,
								1);//percentage instrument will miss	
		}
		
		
		//this is called from the constructor
		//creates the initToolArray this is used 
		//called from the GameStore.as to randomize the game store
		public function initToolArray():void
		{
		
			//creates the array
			toolArray= new Array (15);
			toolArray[0]= sledgeHammer;
			toolArray[1]= lockPickSet;
			toolArray[2]= nitricAcid;
			toolArray[3]= pryBar;
			toolArray[4]= drill;
			toolArray[5]= dynamite;
			toolArray[6]= dryIce;
			toolArray[7]= scope;
			toolArray[8]= nitrogen;
			toolArray[9]= liquidDynamite;
			toolArray[10]= electronicSurge;
			toolArray[11]= timerCracker;
			toolArray[12]= cuttingTorch;
			toolArray[13]= pistol;
			toolArray[14]= flameThrower;
			
		}
		
		//this is used to determine if the item can be used over and over or 
		//if it has limited applications
		//called from GameStore.as: buyTool
		public function hasInfiniteUses( toolName:String):Boolean
		{
				//scroll through the array and find the tool request
			var length:int = toolArray.length;
			for(var i:int=0;i<length;i++)
			{
				//if uses ==-1 then the tool as unlimited uses
				if(toolArray[i].name ==  toolName)
				{
					return (toolArray[i].uses ==-1);
				}
			}
			
			//could find the tool return false
			return false;
		}
	}

}