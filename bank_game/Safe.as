
package
{

	public class Safe
	{
		public const CLASSID:String="SAFE";	
		public var name:String;
		public var physicalHitPoints:int;
		public var mechanicalHitPoints:int;
		public var electronicHitPoints:int;
		public var imageIndex:int;
		public var imageOpenedIndex:int;
		public var requiresTwoPeople:Boolean;
		public var money:int;
		public var isActive:Boolean;
		public var isFound:Boolean;
		public var isOpen:Boolean;
		public var position:cPoint;

		public function Safe(
						newName:String ="Safe",
						physicalHP:int = -1,
						mechanicalHP:int  = -1,
						electronicHP:int = -1,
						imageIx:int = -1,
						imageOpenedIx:int = -1,
						twoPeople:Boolean = false,
						newMoney:int = 0,
						newIsActive:Boolean = true,
						newPosition:cPoint = null,
						newIsOpen:Boolean= false)
		{
			init(newName,
				physicalHP,
				mechanicalHP,
				electronicHP,
				imageIx,
				imageOpenedIx,
				twoPeople,
				newMoney,
				newIsActive,
				false,
				newPosition,
				newIsOpen);
		}
		
		public function init(
						newName:String,
						physicalHP:int,
						mechanicalHP:int,
						electronicHP:int,
						imageIx:int,
						imageOpenedIx:int,
						twoPeople:Boolean,
						newMoney:int,
						newIsActive:Boolean,
						newIsFound:Boolean,
						newPosition:cPoint,
						newIsOpen:Boolean):void
		{
			name = newName;
			physicalHitPoints = physicalHP;
			mechanicalHitPoints = mechanicalHP; 
			electronicHitPoints = electronicHP;
			imageIndex = imageIx;
			imageOpenedIndex = imageOpenedIx
			requiresTwoPeople = twoPeople;
			money = newMoney;
			isFound= newIsFound;
			isOpen = newIsOpen;
			position = new cPoint();
			if(newPosition!=null)
			{
				position.copy(newPosition);
			}
		}
		
		
		public function updateSafeDamage(damageDealt:DamageDealt):void
		{
			//adjust damage dealt in the evven that the tool being used has no effect on the safe
			damageDealt.electronicDamage  =(electronicHitPoints>0)?damageDealt.electronicDamage:0;
			damageDealt.physicalDamage  =(physicalHitPoints>0)?damageDealt.physicalDamage:0;
			damageDealt.mechanicalDamage  =(mechanicalHitPoints>0)?damageDealt.mechanicalDamage:0;
			
			physicalHitPoints  -= damageDealt.physicalDamage;
			mechanicalHitPoints -= damageDealt.mechanicalDamage; 
			electronicHitPoints -= damageDealt.electronicDamage;
			if(damageDealt.physicalDamage>0 && physicalHitPoints<=0)
			{
				physicalHitPoints=0;
				isOpen=true;
			}

			if(damageDealt.mechanicalDamage>0 && mechanicalHitPoints<=0)
			{
				mechanicalHitPoints=0;
				isOpen=true;
			}
			
			if(damageDealt.electronicDamage>0 && electronicHitPoints<=0)
			{
				electronicHitPoints=0;
				isOpen=true;
			}

		}
		
		public function cleanup():void
		{
			physicalHitPoints = -1;
			electronicHitPoints = -1;
			mechanicalHitPoints = -1;
			isOpen=false;
			isFound= false;
		}
		
		public function serialize():String
		{
			return "";
		}
		
		public function deserialize(serializedSafe:String):void
		{
			
		}
			
	}

}