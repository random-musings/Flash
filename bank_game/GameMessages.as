package
{

	public class GameMessages
	{
		public static const choiceOK:Array = new Array("OK");
		public static const valueOK:Array = new Array(0);

		public static const choiceLeaveBank:Array = new Array("LEAVE  BANK");
		public static const valueLeaveBank:Array = new Array(0);


		public static const choiceSurrender:Array = new Array("SURRENDER");
		public static const valueSurrender:Array = new Array(0);
		
		public var messages:Array;
		public var displayMessage:Boolean;
		
		public function GameMessages()
		{
			messages = new Array();
			displayMessage=false;
		}
		
		public function add(msg:Message):void
		{
			messages.push(msg);
		}
		
		
	}
}