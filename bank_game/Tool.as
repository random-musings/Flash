package{

	public class Tool
	{
	
		public var name:String;
		public var description:String;
		public var damageInterval:int; //time in milliseconds
		public var physicalDamage:int;
		public var mechanicalDamage:int;
		public var electronicDamage:int;
		public var intimidationRadius:int;
		public var timerEffect:int;
		public var uses:int;
		public var inUse:Boolean;
		public var timeLastUsed:Number;
		public var cost:int;
		public var imageIndex:int;
		public var requiresHandsToUse:Boolean;
		public var missToolText:String;
		public var missPercentage:int;
		public var maximumUses:int;
		
		public function Tool()
		{
			init("","",-1,-1,-1,-1,-1,-1,-1,-1,-1,false,true,"miss",0,0);
		}

		public function init(	newName:String,
								newDescription:String,
								damageI:int,
								physicalD:int,
								mechanicalD:int,
								electronicD:int,
								intimidationR:int,
								timerE:int,
								newUses:int,
								newCost:Number,
								newImage:int,
								newInUse:Boolean,
								newRequiresHandsToUse:Boolean,
								newMissToolText:String,
								newMissPercentage:int,
								newMaximumUses:int):void
		{
			name = newName;
			description = newDescription;
			damageInterval = damageI;
			physicalDamage = physicalD;
			mechanicalDamage = mechanicalD;
			electronicDamage = electronicD;
			intimidationRadius = intimidationR;
			timerEffect = timerE;
			uses = newUses;
			cost = newCost;
			timeLastUsed =0;
			imageIndex = newImage;
			inUse = newInUse;
			requiresHandsToUse =newRequiresHandsToUse;
			missToolText=newMissToolText;
			missPercentage = newMissPercentage;
			maximumUses = newMaximumUses;
		}	

		public function toolInit( newTool:Tool):void
		{
			init(newTool.name,
				newTool.description,
				newTool.damageInterval,
				newTool.physicalDamage,
				newTool.mechanicalDamage,
				newTool.electronicDamage,
				newTool.intimidationRadius,
				newTool.timerEffect,
				newTool.uses,
				newTool.cost,
				newTool.imageIndex,
				newTool.inUse,
				newTool.requiresHandsToUse,
				newTool.missToolText,
				newTool.missPercentage,
				newTool.maximumUses);
				timeLastUsed = newTool.timeLastUsed;
		}
		
		public function clone():Tool
		{
			var newTool:Tool = new Tool();
			newTool.init(name,
				description,
				damageInterval,
				physicalDamage,
				mechanicalDamage,
				electronicDamage,
				intimidationRadius,
				timerEffect,
				uses,
				cost,
				imageIndex,
				inUse,
				requiresHandsToUse,
				missToolText,
				missPercentage,
				maximumUses);
			newTool.timeLastUsed= timeLastUsed;
			return newTool;
		}
		
		public function copy(newTool:Tool):void
		{
			init(newTool.name,
				newTool.description,
				newTool.damageInterval,
				newTool.physicalDamage,
				newTool.mechanicalDamage,
				newTool.electronicDamage,
				newTool.intimidationRadius,
				newTool.timerEffect,
				newTool.uses,
				newTool.cost,
				newTool.imageIndex,
				newTool.inUse,
				newTool.requiresHandsToUse,
				newTool.missToolText,
				newTool.missPercentage,
				newTool.maximumUses);
				timeLastUsed = newTool.timeLastUsed;
			
		}
		
		public function useTool():DamageDealt
		{
			var damageDealt:DamageDealt = new DamageDealt();
			var currentTime:Date = new Date();
			
			if(  (timeLastUsed+damageInterval)< currentTime.getTime()
				&& uses!=0)
			{
				damageDealt.physicalDamage +=physicalDamage;
				damageDealt.mechanicalDamage +=mechanicalDamage;
				damageDealt.electronicDamage +=electronicDamage;
				damageDealt.doesDamage = true;
				timeLastUsed = currentTime.getTime();
				uses = uses>0?(uses-1):uses;
			}
			return damageDealt;
		}
		
		
		public function selectTool():Boolean
		{
			if(uses!=0)
			{
				var currentDate:Date = new Date();
				timeLastUsed = currentDate.getTime();
				inUse=true;
				return true;
			}
			return false;
		}
		
		public function updateTimeLastUsed(advanceMillis:Number):void
		{
			timeLastUsed += advanceMillis;
		}
		
		
		//determine if tool can be carried
		public function reachedMaxUses(newUses:int):Boolean
		{
			//if we have too many tool return false
			//if we have exceed
			if(uses==-1 || newUses==-1)
			{
				return (2)>maximumUses;
			}
			return ( (newUses+uses)>maximumUses);
		}
		
		
		public function serialize():String
		{
			return "";
		}
		
		public function deserialize(serializedTool:String):void
		{
		
		}

	}

}