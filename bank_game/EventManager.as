
package
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.TextField;


	public class EventManager
	{
		private var linkedEvents:Array;
		public function EventManager()
		{
			linkedEvents = new Array();
		}
		
		public function trackEvent(newDisplayObject:DisplayObject, newEventFunction:Function):void
		{
			var objEvent:ObjectEvent = new ObjectEvent();
			objEvent.addEvent(newDisplayObject,newEventFunction);
			linkedEvents.push(objEvent);
		}
		
		public function removeEvent(newDisplayObject:DisplayObject):void
		{
			var length:int = linkedEvents.length;
			for(var i:int=0;i<length;i++)
			{
				var objEvent:ObjectEvent = linkedEvents[i];
				if(newDisplayObject.name == objEvent.getName())
				{
					objEvent.removeEvent();
				}
			}
			linkedEvents.splice(i,1);
		}

		
		public function removeAllEvents():void
		{
			var length:int = linkedEvents.length;
			for(var i:int=0;i<length;i++)
			{
				var objEvent:ObjectEvent = linkedEvents[i];
				objEvent.removeEvent();
			}
		}
		
		
	}
}