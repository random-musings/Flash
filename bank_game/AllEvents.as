package{

	//this class is used to hold events for the Game while robbing the Bank
	//this class is not yet called in code it has been added for future use.
	//
	public class AllEvents
	{
		public var maxEvents:int=100;			//holds a max of 100 events - I pre-defined the array because I wanted to make sure that the garbage collector
																//does not randomly decide to cleanup stuff so I create it once and write to it many times.
		public var randomBankEvents:Array;	//these events will pop up evetn XX seconds.
	
		public var safeRobbedEvents:Array;		//these events will occur when a safe is opened.
		
		
		//constructor
		public function AllEvents()
		{
			//tinitialize the events
			initRandomEvents();
			resetRandomBankEvents();
			
			//initialize the events
			initSafeRobbedEvents();
			resetSafeRobbedEvents();
		}
		
		
		//creates an array of events that can occur - not yet completed
		public function initRandomEvents():void
		{
			//
			randomBankEvents = new Array(maxEvents);
			for(var i:int=0;i<maxEvents;i++)
			{
				randomBankEvents[i] = new GameEvent();
			}		
		}
		
		//creates an array of events that can occur - not yet completed
		public function resetRandomBankEvents():void
		{
			//initialize memory
			randomBankEvents[0].init(newMessage:String,
									newTimerEffect:int,
									newPhysicalDamage:int,
									newElectronicDamage:int,
									newLockPickDamage:int,
									newCashEffect:int);
		}
		
		//create the events array
		//called by constructor
		public function initSafeRobbedEvents():void
		{
			//create the array and assign memory
			safeRobbedEvents = new Array(maxEvents);
			for(var i:int=0;i<maxEvents;i++)
			{
				safeRobbedEvents[i] = new GameEvent();
			}	
		}
		
		//clear out the events
		//so we can reset
		//not currently called
		public function resetSafeRobbedEvents():void
		{
			//place holder for future behavoir
			safeRobbedEvents[0].init();
		}
	
	}
}
