package{

public class GameEvent
{	
	public var message:String;
	public var timerEffect:int;
	public var physicalDamage:int;
	public var electronicDamage:int;
	public var lockPickDamage:int;
	public var cashEffect:int;
	public var isActive:Boolean;
	
	public function GameEvent()
	{
		message = "";
		timerEffect = 0;
		physicalDamage = 0;
		electronicDamage= 0;
		lockPickDamage = 0;
		cashEffect = 0;
		isActive = false;
	}
	
	
	public function init(
				newMessage:String,
				newTimerEffect:int,
				newPhysicalDamage:int,
				newElectronicDamage:int,
				newLockPickDamage:int,
				newCashEffect:int):void
	{
		message = newMessage;
		timerEffect = newTimerEffect;
		physicalDamage = newPhysicalDamage;
		electronicDamage= newElectronicDamage;
		lockPickDamage = newLockPickDamage;
		cashEffect = newCashEffect;
	}
	
	


}

}