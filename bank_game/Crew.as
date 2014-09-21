package{

	//these are bank robbers
	//the are kept in the GameLevel.as an GameStore.as
	//the crew consists of the cash on hand and the members that rob the bank
	public class Crew
	{	
		public static const CLASSID:String="CREW";	//the class iD used for naming sprites, serializeing and deserializeing items
		public var members:Array;			//the bank robber are an array of peopl
		public var cash:int;					//the cash on hand
		public var selectedMember:int;	//the member that is currently selected..used by game level to show who is highlighted
		
		//teh constructor
		//called from GameLevel.as COnstructor
		public function Crew()
		{
			//unselect all members
			selectedMember =-1;
			
			//create the array
			members = new Array();
			
			//init the cash at zero
			cash =0;
		}
		
		//cleans up all people ensures we don't leak
		//this is called by GameLevel.as:cleanup
		public function cleanup():void
		{
			//scroll through all people and remove them and their tools
			var length:int = members.length-1;
			for(var i:int =length;i>=0;i--)
			{
				members[i].cleanup();
			}
			
			//delete the empty elements
			members =[];
		}
		
		
		
		//make a copy of the crew
		//this is called from main.as when copying crew between the gamelevel and the game store
		public function copy(newCrew:Crew):void
		{
			//uninitialize members of current crew
			deactivateCrew();
			
			//create array if currently null
			if(members == null)
			{
				members = new Array();
			}
			
			//if passed in crew is null then quit
			if(newCrew==null)
			{
				return;
			}
			
			//assign the cash
			cash = newCrew.cash;

			//assign the selected member
			selectedMember = newCrew.selectedMember;
			
			//scroll through the crew and assign their tools and people
			var length:int = newCrew.members.length-1;
			for(var i:int =length;i>=0;i--)
			{
				if(members[i]==null)
				{
					//if current memebrs is empty
					//make copy the person
					var tmpPerson:Person = new Person();
					tmpPerson.copy(newCrew.members[i]);
					
					//add them to our array
					members.push(tmpPerson);
				}else
				{
					//overwrite the current member at this slot
					members[i].copy(newCrew.members[i]);
				}
			}
		
		}
		
		//called from copy()
		//this will set all crew members to false
		//used to re-init an array without deleting/creating new memory
		public function deactivateCrew():void
		{
			//SCROLL through the entire array and set them to active
			var length:int = members.length;
			for(var i:int=0;i<length;i++)
			{	
				members[i].isActive=false;
			}
		}
		
		//this is called from GameLevel.as:resumePlay
		//it updates the tool usage time so that when games are resumed after
		//a long pause the tools are used in the correct sequence
		public function advanceCrewToolUsage(advanceMillis:Number):void
		{
			//scroll through all members 
			var length:int = members.length;
			for(var i:int=0;i<length;i++)
			{	
				//advaqnceToolUsage will check to see what tool is being used and upate it accordingley
				members[i].advanceToolUsageTime(advanceMillis);
			}
		}
		
		
	
		//called by main.as to remove all items 
		//that have no more uses left
		public function dropUsedItems():void
		{
			//this function is called from main.as manage game when switching from GameLevel to Game Store
			var length:int = members.length;
			for(var i:int=0;i<length;i++)
			{	
				if( members[i].isActive)
				{
					//function will scroll throguh all tools is tool/uses =0 it will be removed from the toolArray
					members[i].dropUsedTools();
				}
			}
		}
		
		
		//gets the number of active members in the crew
		//called from GameLevel.as:endLevelSuccessfully
		///used to split the cut from teh safe amongst active members
		public function getActiveMembers():int
		{
			var count:int =0;
			var length:int = members.length;
			for(var i:int=0;i<length;i++)
			{		
				//if the memebr is active then we count them
				if( members[i].isActive)
				{
					count++;
				}
			}
			//return the count
			return count;
		}
		
	}
}