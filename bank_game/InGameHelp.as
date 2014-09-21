package
{

	//this class is held by the game level
	//it provides an array and variables for
	//displaying help hover messages when the help is turned on
	public class InGameHelp
	{
	
		public var showHelp:Boolean;
		public var TIMER:int=0;
		public var CASH:int=1;
		public var MENU:int=2;
		public var SAFEROOM:int=3;
		public var PERSON:int=4;
		public var CREW:int=5;
		public var WEAPONS:int=6;
		public var BANKEXIT:int=7;
		public var MESSAGEPOPUP:int=8;
		public var BANKVAULT:int=9;
		public var PHYSICALDAMAGE:int=10;
		public var ELECTRICALDAMAGE:int=11;
		public var LOCKPICKDAMAGE:int=12;
		public var FLEE:int=13;
		public var HELP:int=14;
		
		public var maxMessages:int=15;

		public var helpMessages:Array;
		
		public function InGameHelp()
		{
			helpMessages = new Array(maxMessages);
			showHelp=false;
			init();
		}
		
		
		private function init():void
		{
			helpMessages[TIMER] = " The timer ticks down.\n If the crew fails to open the vault\n before the timer runs out,\n The game ends.";
			helpMessages[CASH] = " This is the amount of cash you have. \n Cash can be spent in the store\n after each successful robbery. ";
			helpMessages[MENU] = " Click this to pause the game or quit.";
			helpMessages[SAFEROOM] = " The bank vault is located here.\n Bring the crew into this room\n to begin cracking the vault.";
			helpMessages[PERSON] = " These are the banks employees and clientele.\n Time penatlies are incurred if they escape.";
			helpMessages[CREW] = " These are your crew.\n "+
														"They can be move  by clicking on the X and then a room in the bank\n "+
														"The grey circle around each X indicates the distance a bank person\n"+
														" tries to keep from the robber.  Weapons can grow or shrink the circle.";
			helpMessages[WEAPONS] = " These are the weapons used to pull of the robbery.\n Numbers in the top left corner indicate\n how many uses the weapon has.";
			helpMessages[BANKEXIT] = " Guard this area to prevent people from escaping";
			helpMessages[MESSAGEPOPUP] = " Click the green letters to close the pop up ";
			helpMessages[BANKVAULT] = " This is the vault you are trying to crack.\n To Defeat a safe:\n "+
																"1.  move one or more of your crew members into the safe room\n "+
																"2. select a weapon to crack the safe.\n "+
																"    hovering over a weapon will show you what damage it will inflict.";
			helpMessages[PHYSICALDAMAGE] = " Physical damage that must be done to the safe before it is opened.\n "+
																				"Tools like maul, pry bar, cutting torches, dynamite\n deplete the physical hit points"; 
			helpMessages[ELECTRICALDAMAGE] = " Electrical or surge damage that must be done to the safe before it will open.\n surge units, timers defeat electrical mechanisms.";
			helpMessages[LOCKPICKDAMAGE] = " The number of locks that must be defeated before the safe will open.\n lock picks,  acid, liquid nitrogen destroy locks";
			helpMessages[HELP] = "Click this to turn help on or off.\n hovering over items will bring up tips & information \n on how to play the game";
			helpMessages[FLEE] = "Click this to leave the bank before openeing the safe.\n the crew will still demand payment.\n if you can't pay, the game ends.";
		
		}
		
		public function getHelpMessage(spriteName:String):String
		{
			var helpMessageID:int = int(spriteName.substring(settings.helpIdTag.length, spriteName.length));
			return helpMessages[helpMessageID];
			
		}
		
	
	
	
	}


}