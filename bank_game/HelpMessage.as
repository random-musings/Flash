package
{

	//this class display the mouse over  help on the Game Level while crew is in the bank
	//
	public class HelpMessage
	{
		public var message:String;	//the message to be displayed
		public var  area:Rect;			//the area and location to display the message
		public var visible:Boolean;	//show the message
		public var fontSize:int;
	
		//the constructor set everything to empty and visible to false
		public function HelpMessage()
		{
			area = new Rect(0,0,0,0);
			message = "";
			visible = false;
			fontSize=0;
		}
		
		//set a new location and message
		public function setMessage( newMessage:String,
														newX:int, 
														newY:int,
														newFontSize:int,
														newVisible:Boolean):void
		{
			message = newMessage;
			area.x  = newX;
			area.y = newY;			
			fontSize = newFontSize;
			var lineCount:Array = newMessage.split(settings.newLine);
			var charCount:int = 0;
			for(var i:int=0;i<lineCount.length;i++)
			{
				if(lineCount[i].length>charCount)
				{
					charCount = lineCount[i].length;
				}
			}
			
			area.height =  fontSize* (lineCount.length +1);
			area.width = charCount* fontSize/2.25;
			visible = newVisible;
		}
		
		
	
	}

}