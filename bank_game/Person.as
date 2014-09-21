package
{

	public class Person
	{
		public static const CLASSID:String="PERSON";
		public static const DESTINATION:String="DESTINATION";
		
		public var name:String;
		public var imageIndex:int;
		public var position:cPoint;
		public var velocity:cPoint;
		public var height:int;
		public var width:int;
		public var isCrew:Boolean;
		public var tools:Array;
		public var chanceOfFight:int;
		public var chanceOfRun:int;
		public var cashInWallet:int;
		public var isActive:Boolean;
		public var destination:cPoint;
		public var toolInUse:int;
		public var pathArray:Array;
		public var isRunningAway:Boolean;
		private var isFree:Boolean;
				
		public  function Person(newName:String ="",
					newImage:int = -1,
					newPosition:cPoint = null,
					newVelocity:cPoint = null,
					newHeight:int = 0,
					newWidth:int = 0,
					newIsCrew:Boolean = false,
					newTools:Array = null,
					newChanceOfFight:int = 0,
					newChanceOfRun:int = 0,
					isActive:Boolean = false,
					newCashInWallet:int = 0,
					toolInUse:int  =-1,
					newIsFree:Boolean = false)
			{
				pathArray = new Array();
				init(newName,newImage,newPosition,newVelocity,newHeight, newWidth, newIsCrew, 
					newTools, newChanceOfFight,newChanceOfRun,isActive,newCashInWallet,newPosition,
					toolInUse,newIsFree,null);
			}
		
		
		public function init(newName:String,
					newImage:int,
					newPosition:cPoint,
					newVelocity:cPoint,
					newHeight:int,
					newWidth:int,
					newIsCrew:Boolean,
					newTools:Array,
					newChanceOfFight:int,
					newChanceOfRun:int,
					newIsActive:Boolean,
					newCashInWallet:int,
					newDestination:cPoint,
					newToolInUse:int,
					newIsFree:Boolean,
					newPathArray:Array):void
		{
			name = newName;
			imageIndex = newImage;
			height = newHeight;
			width = newWidth;
			isCrew = newIsCrew;
			chanceOfFight = newChanceOfFight;
			chanceOfRun = newChanceOfRun;
			isActive = newIsActive;
			cashInWallet =  cashInWallet;
			position = cPoint.clone(newPosition);
			velocity =  cPoint.clone(newVelocity);
			destination = cPoint.clone(newDestination);
			toolInUse = newToolInUse;
			isFree = newIsFree;
			
			
			var length:int=0;
			if(newTools!=null)
			{
				tools = new Array(newTools.length);
				length = newTools.length;
				for(var i:int=0;i<length;i++)
				{
					var newTool:Tool = newTools[i];
					if(tools[i]==null)
					{
						tools[i] = new Tool();
					}
					tools[i].copy(newTool);
				}
			}else
			{
				tools = new Array();
			}
			
			if(newPathArray!=null)
			{
				pathArray = new Array(newPathArray.length);
				length = newPathArray.length;
				for(var j:int=0;j<length;j++)
				{
					
					if(newPathArray[j]!=null)
					{
							pathArray[j]= newPathArray[j].clone();
						
					}
				}
			}else
			{
				pathArray = new Array();
			}
		}
		
		public function clone( ):Person
		{
			var person:Person = new Person();
			person.init(name ,
						imageIndex ,
						position,
						velocity,
						height ,
						width,
						isCrew,
						tools,
						chanceOfFight,
						chanceOfRun,
						isActive,
						cashInWallet,
						destination ,
						toolInUse,
						isFree,
						pathArray);
			return person;
		}

		public function copy(tmpPerson:Person ):void
		{
			if(tmpPerson==null)
			{
				return;
			}
			init(tmpPerson.name ,
				tmpPerson.imageIndex ,
				tmpPerson.position,
				tmpPerson.velocity,
				tmpPerson.height ,
				tmpPerson.width,
				tmpPerson.isCrew,
				tmpPerson.tools,
				tmpPerson.chanceOfFight,
				tmpPerson.chanceOfRun,
				tmpPerson.isActive,
				tmpPerson.cashInWallet,
				tmpPerson.destination ,
				tmpPerson.toolInUse,
				tmpPerson.isFree,
				tmpPerson.pathArray);
		}
		
		
		public function cleanup():void
		{
			
			while(tools.length>0)
			{
				tools.pop();
			}
		}
		
		
	
	public function setPath(pathDetails:PathDetails):void
	{
		pathArray=[];
		destination.copy(pathDetails.destination);
		pathArray = pathDetails.path;
		isRunningAway = pathDetails.isRunningAway;
	}
		
		
	public function setVelocity(newDestination:cPoint):void
	{

		if(settings.BLOCKED.equal(newDestination)==true)
		{
			velocity.copy(new cPoint());
			return;
		}
		velocity.copy(newDestination);
		velocity.subtract(position);
		velocity.normalize();
		velocity.multiplyScalar(settings.speed);
		//trace("Person.as:setVelocity  currently here "+position.serialize()+"   moving to "+newDestination.serialize()+ " velocity is "+velocity.serialize());
	}
		
		public function isPersonFree(gameLevel:GameLevel):Boolean
		{
			isFree = !gameLevel.bank.layout.pointInRoom(position);
			return isFree;
		}
		
		public function advancePerson(gameLevel:GameLevel):void
		{
			if(!isActive || isFree)
			{	//if person is free or not active quit
				return;
			}
			if (pathArray==null )
			{	//init the array if it was set to NULL
				pathArray = new Array();
			}
			if(pathArray.length==0)
			{	
				if(!velocity.equal(settings.ZEROVELOCITY))
				{
					velocity.copy(settings.ZEROVELOCITY);
				}
				return;
			}
			
			if(!isCrew)
			{	//if this is a NPC then make sure its path is correct
				if(isPersonFree(gameLevel))
				{	//if person is not in bank set isFree flag so  game manager an assess penalty
					isFree=true;
					return;
				}
			}
			
			//if we have no direction or speed the set out towards our next destination
			var nodePosition:cPoint  = cPoint.clone(pathArray[0].getCentrePoint());
			if( velocity.equal(settings.ZEROVELOCITY))
			{
				setVelocity(nodePosition);
			}
			
			
			// TESTING
			var node:Node = gameLevel.gameMap.getNodeByPoint(position);
	
			
			//TESTING
			
			nodePosition.subtract(position);
			
			//trace("person.as advancePerson  first point on path array "+nodePosition.serialize()+"  currently at "+position.serialize());
			var distance:Number = nodePosition.magnitude() ;
			if(distance< getRadius())
			{	//reached the node destination
				//trace("person.as "+name+" advancePerson  REACHED first point on path array "+node.getCentrePoint().serialize());				
				pathArray.shift();//pop the node
				//will be set during next iteration				
				 velocity.copy(settings.ZEROVELOCITY);
			}else 
			{	//advance the person
				if (distance >	3*getRadius())
				{//if we overshot the node because of rounding error
					setVelocity(pathArray[0].getCentrePoint()); //toggle the veloicty again
				}			
				position.add(velocity);
				//trace("person.as advancePerson  first point on path array "+nodePosition.serialize()+"  Moved to "+position.serialize());
			}
			
		}
		
		
		
		public function getWeaponRadius():Number
		{
			var personRadius:int = getRadius();
			if(toolInUse>=0 && toolInUse<tools.length)
			{
				return personRadius + tools[toolInUse].intimidationRadius;
			}
			return personRadius;
		}

		
		public function getRadius():Number
		{
			return width>length?width/2:length/2;
		}
		
		
		public function clearPath():void
		{
			if(pathArray==null)
			{
				pathArray  = new Array();
			}
			while(pathArray.length>0)
			{
				pathArray.pop();
			}
			velocity.copy(settings.ZEROVELOCITY);
		}
		
		public function isNodeAlreadyVisited(node:cPoint):Boolean
		{
			if(pathArray!=null)
			{
				var length:int = pathArray.length;
				for(var j:int=0;j<length;j++)
				{
					if(pathArray[j].equal(node))
					{
						return true;
					}
				}
			}
			return false;
		}


		//this function is called by trhe PathController to 
		//determine if bank personal is in danger
		//PathController.FindSafePlace()
		public function getSafeRect():Rect
		{
			return new Rect(position.x - getRadius(), position.y-getRadius(),2* getRadius(),2*getRadius());
			
		}
		
		public function getCollisionArea():Rect
		{
			return new Rect(position.x - getRadius(), position.y-getRadius(),width,height);
		}
		
		public function getIntimidationArea():Rect
		{
			return new Rect(position.x - getWeaponRadius()/2, position.y-getWeaponRadius()/2,getWeaponRadius(),getWeaponRadius());
		}
		
		
		public function getDamageDealt():DamageDealt
		{
			var damageDealt:DamageDealt = new DamageDealt();
			var length:int = tools.length;
			for(var i:int=0;i<length ;i++)
			{
				if(tools[i].inUse )
				{
					damageDealt.add(tools[i].useTool());
				}
			}		
			return damageDealt;
		}
		
		
		//select tools
		public function selectTool(toolIx:int):void
		{
			var toolLength:int = tools.length;
			if(toolIx<0 || toolIx>=toolLength)
			{
				return;
			}
			var selectedTool:Tool = tools[toolIx];
			if(selectedTool!=null && selectedTool.uses!=0)
			{
				//stop using all weapons that requires hands to use cause we can only use one
				if(selectedTool.requiresHandsToUse)
				{
					for(var i:int=0; i<toolLength;i++)
					{
						if(i!= toolIx)
						{
							if(tools[i].requiresHandsToUse)
							{
								tools[i].inUse=false;
							}
						}
					}
				}
				var currDate:Date = new Date();
				selectedTool.timeLastUsed = currDate.getTime();
				selectedTool.inUse=true;
				toolInUse = toolIx;
			}
			
		}
		
		
		public function canCarryTool(tool:Tool,uses:int):Boolean
		{
			var toolLength:int = tools.length;
			for(var i:int=0; i<toolLength;i++)
			{
				if(tools[i]!=null)
				{
					if(tools[i].name == tool.name)
					{
						return !tools[i].reachedMaxUses(uses);
					}
				}
			}
			if(toolLength>=settings.maxToolsPerPerson)
			{	//exceeded tools allowed to carry
				return false;
			}			
			return true;
		}
		
		//pickup Tool
		public function pickupTool(newTool:Tool):void
		{
			var toolLength:int = tools.length;
			for(var i:int=0; i<toolLength;i++)
			{
				if(tools[i].name == newTool.name)
				{
					if(tools[i].uses <0)
					{
						tools.push(newTool);
					}else
					{
						tools[i].uses +=newTool.uses;
					}
					return;
				}
			}
			tools.push(newTool);
		}
		
		
		//drop Tool
		public function dropTool(toolIx:int):void
		{
			var toolLength:int = tools.length;
			
			if(toolIx>=0 && toolIx<toolLength)
			{
				if(tools[toolIx].uses<=1 )
				{
					tools.splice(toolIx,1);
				}else
				{
					tools[toolIx].uses--;
				}
			}
			
		}		
		
		public function advanceToolUsageTime(advanceMillis:Number):void
		{
			var toolCount:int = tools.length;
			for(var i:int=0; i<toolCount;i++)
			{
				tools[i].updateTimeLastUsed(advanceMillis);
			}
		}
		
		
		public function dropUsedTools():void
		{
			var toolLength:int = tools.length;
			var i:int=0;
			while(i<toolLength)
			{
				if(tools[i]!=null)
				{
					if(tools[i].uses==0 )
					{
						tools.splice(i,1);
					}
				}
				i++;
			}
		}
		
		
		public function serialize():String
		{
			return "";
		}
		
		
		
		
		
		public function deserialize( serializedPerson:String):void
		{
		
		}
		
		
	
	}

}