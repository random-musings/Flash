package{

	//this class is used to transport the dmage that all tools will do to a safe
	//during a current turn.
	//instantiated by GameLevel.as: UpdateCrew
	public class DamageDealt
	{
	
		public var electronicDamage:int;	//the number of eletronic points to attack a safe with
		public var mechanicalDamage:int;	//the number of locking mechanisms defeated 
		public var physicalDamage:int; //the physical hit points
		public var timerEffect:int;	//does it affect the timer of the game (currently no tools do this)
		public var doesDamage:Boolean;	//indicates if damage is incurred
		
		//the constructor
		public function DamageDealt()
		{	
			//initialize all variables to 0
			electronicDamage =0;
			mechanicalDamage =0;
			physicalDamage =0;
			timerEffect=0;
			doesDamage=false;
		}

		
		public function add(damageDealt:DamageDealt):void
		{
			//add the damage dealt from a weapon to this class
			electronicDamage += damageDealt.electronicDamage;
			mechanicalDamage += damageDealt.mechanicalDamage;
			physicalDamage += damageDealt.physicalDamage;
			timerEffect += damageDealt.timerEffect;

			//indicate that damage is set
			doesDamage = ( electronicDamage>0 || mechanicalDamage>0 ||physicalDamage);
		}
	}


}