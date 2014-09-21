package{

	public class Message
	{
		public var id:String; //name this message so it can be found later?
		public var title:String;
		public var mainMessage:String;
		public var choiceValues:Array;
		public var choiceText:Array;
		public var isActive:Boolean;
		public var eventHandler:Function;
		
		public function Message()
		{
			init("","",null,null,null,true);
		}
		
		public function init(
			newTitle:String,
			newMainMessage:String,
			newChoiceValues:Array,
			newChoiceTextArray:Array,
			newEventHandler:Function,
			newIsActive:Boolean):void
		{
			title  = newTitle;
			mainMessage = newMainMessage;
			isActive = newIsActive;
			if(newChoiceValues==null)
			{
				choiceValues = new Array();
			}else
			{
				choiceValues  = newChoiceValues;
			}
			
			if(newChoiceTextArray==null)
			{
				choiceText = new Array();
			}else
			{
				choiceText = newChoiceTextArray;				
			}
			
			eventHandler = newEventHandler;
		}
	}

}