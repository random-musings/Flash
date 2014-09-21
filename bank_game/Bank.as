package{
	
	//this class is held in the GameStore.as
	//it holds 
	//all of the rooms in the bank
	//the safe
	//the people
	public class Bank
	{
	
	
		public static const CLASSID:String="BANK";//this is the class id it is used when we serialize or deserialize or naming sprites
		public var name:String;	//the name of the bank displayed at the top of the game screen
		public var people:Array;	//the people in the bank
		public var rooms:Array;	//the rooms of the bank
		public var layout:Room;	//the bank istelf
		public var safe:Safe;	//the safe in the bank
		
		//the construtor
		public function Bank()
		{
			//initializes the bank and its variables
		name="";
		 people = new Array();
		 rooms = new Array();
		 layout = new Room();
		 safe = new Safe();
		}
		
		//this is reserved for future use to save the current state of the bank
		public function serialize():String
		{ //reserved for future use
			return "";
		}
		
		//used to restore the current state 
		public function deserialize(serializedBank:String):void
		{
			//reserved for future use
		}
		
		//deactive all memory so we don't leak
		//called from gamelevel.cleanup
		public function cleanup():void
		{
		
			//remove the people 
			var length:int= people.length -1;
			for(var i:int=length;i>=0;i--)
			{
				people[i].cleanup();
				people.pop();
			}
			
			//destroy the rooms
			length = rooms.length -1;
			for( i=length;i>=0;i--)
			{
				rooms[i].cleanup();
				rooms.pop();
			}
			
			//cleanup us the safe
			safe.cleanup();
			name="";
			
			
		}
		
		//determines is a person is standing the safe
		//called from GameLevel.as updateCrew
		public function detectPointInSafe(point:cPoint):Boolean
		{
			//scroll through the rooms and determine if a robber is standing the bank
			var length:int = rooms.length;
			for(var i:int=0;i<length;i++)
			{
				var room:Room = rooms[i];
				if(room.isSafeHere && room.pointInRoom(point))
				{	//robber found in safe
					return true;
				}
			}
			//noone found in safe return false
			return false;
		}
		
		
		
		
		//will return the index of the room that that point originated in
		//game from GameLevel.as: handleRoomSelect
		//PathController.as setNPCPath,getPath
		public function getRoomUsingPoint(position:cPoint):Room
		{
			var length:int = rooms.length;
			for(var i:int=0;i<length;i++)
			{
				if(rooms[i].pointInRoom(position))
				{	//found a room inside the bank room
					return rooms[i];
				}
			}
			if(layout.pointInRoom(position) || position.equal(layout.getExit()))
			{	//person in the main bank area
				return layout;
			}
			//no room found
			return null;
		}
	
	
	}


}
