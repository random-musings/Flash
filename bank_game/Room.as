

package{

	
	public class Room
	{
		public static const CLASSID:String="ROOM";	 //used to uniquely identify our sprites as rooms
		public static const DOORCLASSID:String="DOOR";	 //used to uniquely identify our doors
		public var name:String;
		public var x:int;
		public var y:int;
		public var width:int;
		public var height:int;
		public var isSafeHere:Boolean;
		public var doorLocation:int;
		public var doorType:int;
		public var doorImageIx:int;
		public var isActive:Boolean;
		
		public function Room(  	newName:String="room",
								newX:int = 0,
								newY:int = 0,
								newWidth:int = 0,
								newHeight:int = 0,
								doorL:int = 0,//DoorLocation.NONE,
								doorT:int = 0,//DoorType.NONE,
								image:int = -1,
								safeRoom:Boolean = false,
								newIsActive:Boolean = false)
		{
			init(newName,newX,newY, newWidth,newHeight, doorL,doorL, image,safeRoom,newIsActive);
		}
		
		public function init( 	newName:String,
								newX:int,
								newY:int,
								newWidth:int,
								newHeight:int,
								doorL:int,
								doorT:int,
								image:int,
								safeRoom:Boolean,
								newActive:Boolean):void
		{
			name=newName;
			x = newX;
			y = newY;
			width = newWidth;
			height = newHeight;
			doorLocation = doorL;
			doorType = doorT;
			doorImageIx = image;
			isSafeHere = safeRoom;
			isActive = newActive;
		}
		
		public function clone():Room
		{
			var room:Room =  new Room(
								name,
								x,
								y,
								width,
								height,
								doorLocation,
								doorType,
								doorImageIx,
								isSafeHere,
								isActive			);
			return room;
		}
		
		public function getExit():cPoint
		{
			var halfDoor:Number = settings.doorWidth/2;
			var qtrDoor:Number = settings.doorWidth/1.5;
			var entryHeight:Number = settings.doorWidth/3;
			switch(doorLocation)
			{
				case DoorLocation.TOP_LEFT:		return new cPoint(x+halfDoor ,y-entryHeight,0);
				case DoorLocation.TOP_RIGHT:	return new cPoint(x + width - settings.doorWidth,y-entryHeight,0);
				case DoorLocation.LEFT_TOP: 	return new cPoint(x-entryHeight,y,0);
				case DoorLocation.LEFT_BOTTOM: 	return new cPoint(x-entryHeight,y+height - entryHeight,0);
				case DoorLocation.RIGHT_TOP: 	return new cPoint(x+width+halfDoor,y,0);
				case DoorLocation.RIGHT_BOTTOM:	return new cPoint(x+width+halfDoor,y+height-qtrDoor,0);
				case DoorLocation.BOTTOM_RIGHT:	return new cPoint(x+ width - halfDoor,y+height+entryHeight,0);
				case DoorLocation.BOTTOM_LEFT:	return new cPoint(x+entryHeight,y+height+entryHeight,0);
				case DoorLocation.BOTTOM_CENTER:return new cPoint(x+width/2-halfDoor ,y+height+entryHeight,0);
				case DoorLocation.TOP_CENTER:	return new cPoint(x+width/2-halfDoor ,y-entryHeight,0);
				case DoorLocation.LEFT_CENTER:	return new cPoint(x-entryHeight,y+height/2 - halfDoor);
				case DoorLocation.RIGHT_CENTER:	return new cPoint(x+width+entryHeight,y+height/2 - halfDoor);				
				default: return settings.BLOCKED;			
			}
		}
		
		
		//called by getDoor 
		//gets a point just outside of the room
		public function getEntrance():cPoint
		{
			var halfDoor:Number = settings.doorWidth/2;
			var qtrDoor:Number = settings.doorWidth/1.5;
			var entryHeight:Number = halfDoor;
			switch(doorLocation)
			{
				case DoorLocation.TOP_LEFT:		return new cPoint(x+halfDoor ,y+entryHeight,0);
				case DoorLocation.TOP_RIGHT:	return new cPoint(x + width - settings.doorWidth,y+entryHeight,0);
				case DoorLocation.LEFT_TOP: 	return new cPoint(x+entryHeight,y,0);
				case DoorLocation.LEFT_BOTTOM: 	return new cPoint(x+entryHeight,y+height - entryHeight,0);
				case DoorLocation.RIGHT_TOP: 	return new cPoint(x+width-halfDoor,y,0);
				case DoorLocation.RIGHT_BOTTOM:	return new cPoint(x+width -halfDoor,y+height - qtrDoor,0);
				case DoorLocation.BOTTOM_RIGHT:	return new cPoint(x+ width - halfDoor,y+height-entryHeight,0);
				case DoorLocation.BOTTOM_LEFT:	return new cPoint(x+entryHeight,y+height-entryHeight,0);
				case DoorLocation.BOTTOM_CENTER:return new cPoint(x+width/2-halfDoor ,y+height-entryHeight,0);
				case DoorLocation.TOP_CENTER:	return new cPoint(x+width/2-halfDoor ,y+entryHeight,0);
				case DoorLocation.LEFT_CENTER:	return new cPoint(x+entryHeight,y+height/2 - halfDoor);
				case DoorLocation.RIGHT_CENTER:	return new cPoint(x+width-entryHeight,y+height/2 - halfDoor);				
				default: return settings.BLOCKED;
			}
		}
		
		//called by the collision detection to determine
		//if person is standing in the door way
		public function getDoor():Rect
		{
			var halfDoor:Number = settings.doorWidth/2;
			var doorExit:cPoint = getExit();
			var doorEntrance:cPoint = getEntrance();
			if(doorExit.equal(settings.BLOCKED))
			{
				return new Rect(-1,-1,-1,-1);
			}
			
			var doorX:int = Math.min(doorExit.x, doorEntrance.x);
			var doorY:int  = Math.min(doorExit.y,doorEntrance.y);
			var doorWidth:int = Math.abs(doorExit.x- doorEntrance.x);
			var doorHeight:int  = Math.abs(doorExit.y -doorEntrance.y);
			//adjust the door so it is the correct width
			if(doorWidth==0)
			{//door is vertical adjust it to correct width
				doorX += -halfDoor;
				doorWidth = halfDoor;
			}
			if(doorHeight==0)
			{	//door is horizontal adjust it to correct height
			//	doorY += -halfDoor;
				doorHeight =halfDoor;
			}
			//trace("returning rect "+name+" at ("+doorX+","+doorY+")  dimensions "+doorWidth+"x"+doorHeight);
			return new Rect(doorX,doorY,doorWidth,doorHeight);
		}		
		
		
		public function pointInRoom(position:cPoint):Boolean
		{
			if(position.x>=x && position.x<=(x+width))
			{
				if(position.y>=y && position.y<= (y+ height))
				{
					return true;
				}
			}
			return false;
		}
		
		
		
		//called from GameLevel detect Collisison
		public function collidesWithWalls(rect:Rect):Boolean
		{
			//trace(" room  "+name+"  "+x+","+y+"  "+width+"x"+height);
			//trace(" person "+rect.x+","+rect.y+"  "+rect.width+"x"+rect.height);
			if(doorType== DoorType.NONE)
			{ //if we can exist in room then check against entire room
				var wholeRoom:Rect = new Rect(x,y,width,height);
				if(Rect.rectOverlap(rect,wholeRoom))
				{
					//trace("Room.as "+name+" collide with desk(room with no doors)");
					return true;
				}
			
			}
			var topWall:Rect  = new Rect(x, y, width,1);
			var leftWall:Rect  = new Rect(x, y, 1,height);
			var bottomWall:Rect  = new Rect(x, y+height, width,1);
			var rightWall:Rect  = new Rect(x+width, y, 1,height);

			//trace(" Overlap topWall? "+Rect.rectOverlap(topWall,rect));
			//trace(" Overlap leftWall? "+Rect.rectOverlap(leftWall,rect));
			//trace(" Overlap bottomWall? "+Rect.rectOverlap(bottomWall,rect));
			//trace(" Overlap rightWall? "+Rect.rectOverlap(rightWall,rect));
			var nearDoor:Boolean = false;
			if(doorType!= DoorType.NONE)
			{
				var doorRect:Rect =getDoor() ;
				nearDoor = Rect.rectOverlap(rect,doorRect) || Rect.rectOverlap(doorRect,rect);
				
				//trace (" collideWithWalls distance to Door "+nearDoor);
				if (nearDoor )
				{
					return false;
				}
			}
			if(  Rect.rectOverlap(topWall,rect) || //top Wall
					Rect.rectOverlap(bottomWall,rect) || //bottom Wall
					Rect.rectOverlap(leftWall,rect) || //left Wall
					Rect.rectOverlap(rightWall,rect)  ||	//right Wall
					Rect.rectOverlap(rect,leftWall) || //topleft
					Rect.rectOverlap(rect,rightWall)  //RIGHT Wall
			)
			{			
					//trace("Room.as collision occurs returning true");
					return true;
			}
			//trace("Room.as collision occurs returning false");
			return false;
		}
	
	
		
		
		public function getInsetRoom(radius:int):Room
		{
			//if person is wider then the width of the room
			//then the only safe place is the centre
			var insetRect:int = radius;
			var tmpRoom:Room = this.clone();
			//if person is wider then the width of the room
			//then the only safe place is the centre
			tmpRoom.x = x+insetRect;
			tmpRoom.y = y+insetRect;
			tmpRoom.width = tmpRoom.width - 2*insetRect;
			tmpRoom.height = tmpRoom.height - 2*insetRect;	
			return tmpRoom;
		}
		
		
		public function serialize():String
		{
			return "";
		}
		
		public function deserialize(serializedRoom:String):void
		{
		
		}

		
		//this ensures that the point is within the room and will not result in 
		//player being drawn outside of room
		//create a rectangle within the room
		//called by gameLevel handleRoom Select to ensure that players are moved to 
		//safe places in the room
		public function resetAvailablePointInRoom(newPoint:cPoint,radius:int):cPoint
		{
			var insetRect:int = radius;
			var tmpRoom:Room = getInsetRoom(radius);		
			
			if(!tmpRoom.pointInRoom(newPoint))
			{	//not in safe part of the room- reset the point
				var middlePoint:cPoint = new cPoint(tmpRoom.x+ tmpRoom.width/2, tmpRoom.y+tmpRoom.height/2,0);
				var velocity:cPoint  = new cPoint(0,0,0);
				velocity.copy(middlePoint);
				velocity.subtract(newPoint);
				velocity.normalize();			
				while(!tmpRoom.pointInRoom(newPoint))
				{
					newPoint.add(velocity);
				}
			}
			
			return newPoint;
		}
		
	}
	
}