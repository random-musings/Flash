package
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	
	//this class holds all event references to textfields and sprites
	//so that at the end of the level or scene in a game we can easily 
	//delete the events and not cause memory leaks
	
	public class ObjectEvent
	{
		private var sprite:Sprite;
		private var textField:TextField;
		private var eventFunction:Function;
		
		//the constructor
		public function ObjectEvent()
		{
		
		}
		
		//add a new event to begin tracking
		public function addEvent(newDisplayObject:DisplayObject, newEventFunction:Function):void
		{
			//if this is a sprite store it in the sprite obect
			if((newDisplayObject as Sprite)!=null)
			{
				sprite =( newDisplayObject as Sprite);
			}
			
			//this is a text field store it in the textfiel object
			if((newDisplayObject as TextField)	!=null)
			{
				textField = (newDisplayObject as TextField);
			}
			eventFunction = newEventFunction;
		}
		
	
		//remo
		public function removeEvent():void
		{
			//if the sprite was set then remove its event
			if(sprite !=null)
			{
				if(sprite.hasEventListener(MouseEvent.CLICK))
				{
					sprite.removeEventListener(MouseEvent.CLICK,eventFunction);
				}
			}
			
			//if the textfield was set then remove its textfield as a listener
			if(textField !=null)
			{
				if(textField.hasEventListener(MouseEvent.CLICK))
				{
					textField.removeEventListener(MouseEvent.CLICK,eventFunction);
				}
			}
			
		}
		
		//get the name of the sprite 
		//called by event manager
		public function getName():String
		{
			if(sprite !=null)
			{
				return sprite.name;
			}
			if(textField !=null)
			{
				return textField.name;
			}
				return "";	
		}
	}

}