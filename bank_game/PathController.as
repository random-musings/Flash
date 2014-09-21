package
{
	//this class finds a save path to desired destinations
	//it implements a version of a* with some heuristics
	public class PathController
	{
	
		public function PathController()
		{
		}
		
		
		
		//					Bank (NPC Character) Decision Tree
		//							
		//							is bank robber near you? 
		//							/              \
		//						  /                 \
		//						 yes				no
		//		is there a node to back up? 			\ 	
		//					/		 \					is door blocked
		//				  /				\				/              \
		//				yes 				no		yes   				no
		//		move to safer node			don't move				is path to door blocked
		//								         						/				\
		//															yes					no
		//														 don't move 		set path to door exit
		//						
		public function setNPCPath(person:Person,gameLevel:GameLevel):PathDetails
		{
			if(person==null || !person.isActive)
			{
				return null;
			}

			//create a node that will stop the NPC from moving
			var stopMoving:PathDetails = new PathDetails();
			stopMoving.destination.copy(person.position);
				
			
			//is a bank robber near the person is yes then they are in danger
			var robber:Person = IsCrewSafeDistance(person.getSafeRect(),gameLevel.crew.members) 
			if( robber !=null && !person.isRunningAway)
			{	
				//we are within a weapons radius of a crew member - find a safer place
				//we are withing the radius of a bank person - moveoff of them
				
				//look for a safe point - one not occupied by a person or crew member
				var safePoint:cPoint = FindSafePlace(person,robber,gameLevel);
				//if the safe point is set then plot a path to the set path
				if(!safePoint.equal(settings.BLOCKED) && !person.position.equal(safePoint))
				{
					var pathDetails:PathDetails = (determinePath(safePoint,
												person,
												gameLevel));
					pathDetails.isRunningAway=true;
					return pathDetails;
				}
				person.isRunningAway =false;
				return stopMoving;
			}else
			{
			person.isRunningAway =false;
				if(person.pathArray.length==0)
				{	//NPC has no path set so lets try to reach the exit.
					var room:Room= gameLevel.bank.getRoomUsingPoint(person.position);	
					//trace(" person "+ person.name+"   Door "+room.getDoor().x+" "+room.getDoor().y);
					//trace(" person "+ person.name+"   IsCrewWithinArea "+IsCrewWithinArea(room.getDoor(),gameLevel.crew.members));
					//trace(" person "+ person.name+"   IsPathToExitBlocked "+IsPathToExitBlocked(room.getExit(),person,gameLevel.crew));
					
					if(!IsCrewWithinArea(room.getDoor(),gameLevel.crew.members)
						&& !IsPathToExitBlocked(room.getExit(),person,gameLevel.crew))
					{
						return determinePath(room.getExit(),
													person,
													gameLevel);
					}
					//crew is blocking exit but NPC is not in danger
					//so stop moving
					return stopMoving;
				}
			}
			//carry on with the current path
			return new PathDetails();
		}
	
	
		//returns a path to the nodes or an empty path if
		//no valid path can be found
		//this is called by GameLevel during the update
		//all bank personal and crew use this function to 
		//find a path to their desire destination
		public function determinePath(destination:cPoint,
									person:Person,
									gameLevel:GameLevel):PathDetails
		{
			var pathDetails:PathDetails = new PathDetails();

			//get start and end nodes
			var start:Node = gameLevel.gameMap.getNodeByPoint(person.position);
			var end:Node = gameLevel.gameMap.getNodeByPoint(destination);

			//check if desitination  is possible to get too
			//quit if it is blocked
			if( start==null || 
				end == null ||
				end.isBlocked())
			{
				return pathDetails;
			}

			return getPath(start,end,gameLevel);
		}
	

		//called by determinePath 
		//puts together the array 
		// uses the rooms from the gameLevel to apply room hueristics
		// to shorten the path search
		public function getPath(startNode:Node, 
								endNode:Node,
								gameLevel:GameLevel):PathDetails
		{		
			var pathDetails:PathDetails = new PathDetails();
			pathDetails.destination.copy(endNode.getCentrePoint());
			
			//where we are starting from
			var currentNode:Node =startNode.clone();
			
			//where we are going to set our current destination to be the start
			//so on the first loop through we setup a path to a new destination
			var destinationNode:Node  = startNode.clone();
			
			//get the room that we are currently in
			var currentRoom:Room = gameLevel.bank.getRoomUsingPoint(currentNode.getCentrePoint());
			if(currentRoom==null)
			{
				return pathDetails;
			}
			
			var currentRoomEntrance:Node= gameLevel.gameMap.getNodeByPoint( currentRoom.getEntrance());
			var currentRoomExit:Node= gameLevel.gameMap.getNodeByPoint( currentRoom.getExit());
			//get the room we want to be in
			var destinationRoom:Room = gameLevel.bank.getRoomUsingPoint(endNode.getCentrePoint());
			if(destinationRoom==null)
			{
					endNode = gameLevel.gameMap.getNodeByPoint( gameLevel.bank.layout.getExit());
					destinationRoom = gameLevel.bank.layout;
			}
			//the point outside of the room we want to be in
			var destinationRoomExit:Node =  gameLevel.gameMap.getNodeByPoint(destinationRoom.getExit());

			
			//get the name of the room that is just outside of the room we WANT to be in
			//since rooms are never linked more than 1 deep
			//this provides efficient huersitics and ensure that we are always moving towards the
			//the door and not searching the walls for the door entrance
			
			var roomOutsideDestination:Room = gameLevel.bank.getRoomUsingPoint(destinationRoomExit.getCentrePoint()); 
			if(roomOutsideDestination==null)
			{
				roomOutsideDestination =gameLevel.bank.layout; //we couldn't find a room so lets set it to the bank
			}			
			
			
			var maxInterations:int = 15;
			var numIterations:int=0;
			while(!currentNode.equal(endNode) && pathDetails.path.length< settings.maxPath )
			{
				//trace(" currentRoom.name "+currentRoom.name+"   at position: "+currentNode.getCentrePoint().serialize() );					
				//trace(" destinationRoom.name "+destinationRoom.name);				
				numIterations++;
				if(numIterations>maxInterations)
				{
					return pathDetails;
				}
				//if we have reached the next destination on our route find a new destination
				if(currentRoom.name == destinationRoom.name )
				{	//we are standing in same room as desired destination
					//trace(" we are in final room move to final destination "+endNode.getCentrePoint().serialize());
					destinationNode.copy(endNode);
				}else 
				if (destinationRoomExit.equal(currentNode)
				&& roomOutsideDestination!=null
				&& roomOutsideDestination.name == currentRoom.name) 
				{
					//if we are standing outside of the desired room
					//then step into the entrance
					destinationNode.copy(gameLevel.gameMap.getNodeByPoint(destinationRoom.getEntrance()));
					//trace("we standing at exit of desired room move to entrance of final room "+destinationNode.getCentrePoint().serialize());
				}else
				if ( roomOutsideDestination !=null 
					&& roomOutsideDestination.name ==currentRoom.name )
				{
					//if we are standing outside of the desired  room
					//move to the door of the room we want 
					destinationNode.copy(gameLevel.gameMap.getNodeByPoint(destinationRoom.getExit()));
					//trace("we are in room outside of destination room the final room's exit is here "+destinationNode.getCentrePoint().serialize());
				}else
				{
					//the exit/entrance to the destination room is not in this room so leave it
					//first move to the entrance
					//trace(" are we standing At entrance ("+currentRoomEntrance.getCentrePoint().serialize()+")    "+currentRoomEntrance.equal(currentNode));					
					//then step to out of the room to the exit
					if( currentRoom.name!=destinationRoom.name)
					{			
						if( currentRoomEntrance.equal(currentNode))  //if we are not standing in the entrance of the current room
						{
							//trace(" moving to exit of current Room "+currentRoom.getExit().serialize());
							destinationNode.copy(gameLevel.gameMap.getNodeByPoint(currentRoom.getExit()));
						}
						else
						{
							//trace(" moving to entrance of current Room "+currentRoom.getEntrance().serialize());
							destinationNode.copy(gameLevel.gameMap.getNodeByPoint(currentRoom.getEntrance()));
						}
					}
				}
				
				//get a list of nodes to the destination
				var journey:Array = getPathNodes(currentNode,destinationNode,gameLevel.gameMap);
				pathDetails.path = pathDetails.path.concat(journey);
				
				//if we didn't find any nodes to go to - quit
				if(pathDetails.path.length==0)
				{
					return pathDetails;
				}
				
				//update our current position to the next node
				currentNode = pathDetails.path[pathDetails.path.length-1];
				
				//updat the current room that we are in (entrances & exits)
				currentRoom =  gameLevel.bank.getRoomUsingPoint(currentNode.getCentrePoint());
				if(currentRoom==null)
				{
					//if we have left the bank then quit because we have our path
					return pathDetails;
				}
				currentRoomEntrance = gameLevel.gameMap.getNodeByPoint( currentRoom.getEntrance());
				currentRoomExit = gameLevel.gameMap.getNodeByPoint( currentRoom.getExit());
			}
			
			//return that path that we have
			return pathDetails;
		}
	
	
		//get all nodes that make up a path to the destination
		//called by getPath
		public function getPathNodes(startNode:Node, endNode:Node, gameMap:Map):Array
		{
		
			//create a blank node to compare it against
			var blankNode:Node = new Node(new cPoint(-1,-1,-1),0,0,0,0,0);
			
			//the array of nodes we tested already
			var visited:Array = new Array();
			
			//the path we will follow to the destination
			var currentPath:Array = new Array();
			
			//the cost parameters for determining where to go next
			var hCost:int = 0;
			var gCost:int =0;
			var ttlCost:int =-1;
			
			//the node we want to go 
			var destinationNode:Node = endNode.clone();
			var centrePoint:cPoint= cPoint.clone( destinationNode.getCentrePoint());
			
			//where we are starting from
			var currentNode:Node =  startNode.clone();
			visited.push(startNode);

			//ensure we don't spend forever searching
			var maxAttempts:int = 300;
			var attempts:int =0;


			//while we have not reached our destination
			while(!currentNode.equal(destinationNode)  && attempts<maxAttempts)
			{
				attempts++;
				var nextNode:Node =  blankNode.clone();
				var possibleNodes:Array =getPossibleNodes( currentNode,currentPath, gameMap);
				var length:int = possibleNodes.length;
				
				//examine the adjacent nodes and determine which one gets us closer to the destination
				for (var i:int=0;i<length;i++)
				{	
					
					var nodeCentre:cPoint = possibleNodes[i].getCentrePoint();
					if(nodeCentre.x==centrePoint.x || nodeCentre.y == centrePoint.y)
						gCost = 10;
					else
						gCost = 14;
					hCost = (Math.abs(nodeCentre.x - centrePoint.x)+  Math.abs(nodeCentre.y -centrePoint.y)) * 10;
					//test to see which node in the adjacent nodes are closest to the destination
					if( ttlCost ==-1 || (( gCost+hCost)<ttlCost))
					{
						nextNode = possibleNodes[i];
						ttlCost  = gCost+hCost;
					}
					visited.push(nextNode);
				}
				
				//if did not find a node that gets us closer then quit searching
				if( nextNode.equal(blankNode))
				{
					return currentPath;
				}
				
				//reset totals
				ttlCost = -1;
				
				//advance to new node in path
				currentPath.push(nextNode);
				currentNode.copy(nextNode);
			}
			
			return currentPath;
		}
	
	
		//get all adjacent nodes that have not been visited
		//called by getPathNodes
		public function getPossibleNodes(startNode:Node, testedNodes:Array, gameMap:Map):Array
		{

		
			//get the indexes of the starting node so we can test all adjacent nodes
			var nodeIndex:cPoint = startNode.getIndexes();
			var x:int = nodeIndex.x;
			var y:int = nodeIndex.y;
			
			
			//init the array that is holding the nodes
			var adjacentNodes:Array = new Array();
			
			//all nodes that are adjacent to the starting node
			var topNode:Node = gameMap.getNode(x,y+1);
			var bottomNode:Node = gameMap.getNode(x,y-1);
			var leftNode:Node = gameMap.getNode(x-1,y);
			var rightNode:Node = gameMap.getNode(x+1,y);
			var topLeftNode:Node = gameMap.getNode(x-1,y+1);
			var topRightNode:Node = gameMap.getNode(x+1,y+1);
			var bottomLeftNode:Node = gameMap.getNode(x-1,y-1);
			var bottomRightNode:Node = gameMap.getNode(x+1,y-1);
			
			//test each node to see if we have already tried it
			if(nodeAvailable(topNode,testedNodes)){  adjacentNodes.push(topNode);	}
			if(nodeAvailable(bottomNode,testedNodes)){  adjacentNodes.push(bottomNode);}
			if(nodeAvailable(leftNode,testedNodes)){  adjacentNodes.push(leftNode);}
			if(nodeAvailable(rightNode,testedNodes)){  adjacentNodes.push(rightNode);	}
			if(nodeAvailable(topLeftNode,testedNodes)){  adjacentNodes.push(topLeftNode);	}
			if(nodeAvailable(topRightNode,testedNodes)){  adjacentNodes.push(topRightNode);	}
			if(nodeAvailable(bottomLeftNode,testedNodes)){  adjacentNodes.push(bottomLeftNode);	}
			if(nodeAvailable(bottomRightNode,testedNodes)){  adjacentNodes.push(bottomRightNode);	}
			
			
			//return the resulting list
			return adjacentNodes;
		
		}
		
		//called by getPossibleNodes & getFleeNodes
		//verifies if node could be used as a path node
		private function nodeAvailable(node:Node, nodeList:Array):Boolean
		{
			if(node==null)
			{
				return false;
			}
			if(node.state!=NodeState.OPEN)
			{
				return false;
			}
			return !nodeInList(node,nodeList);
		
		}
		
		//search through a list an verify if a node is in the existing list
		//called by nodeAvailable 
		private function nodeInList(node:Node, nodeList:Array):Boolean
		{
			if(node==null)
			{
				return false;
			}
			if(nodeList==null)
			{
				return false;
			}
			var length:int = nodeList.length;
			for(var i:int;i<length;i++)
			{
				//if the node is equal then return true
				if(node.equal(nodeList[i]))
				{
					return true;
				}
			}
			
			//node wasn't found return false
			return false;		
		}

		
		//this function is called by setNPCPath
		//function determines if the doorway of the current room is 
		//blocked by a crew member 
		//the crew members radius is determined by the weapon they are carrying
		private function IsCrewWithinArea(area:Rect,people:Array):Boolean
		{
			var crewCount:int = people.length;
			for(var i:int=0;i<crewCount;i++)
			{
				var robber:Person = people[i];
				//check to ensure that the robber is active
				if(robber !=null && robber.isActive)
				{												
					//if the door entry is covered by the robber 
					//then return true because person cannot escape without
					
					if(Rect.rectOverlap(area,robber.getIntimidationArea()))
					{
						return true;
					}
				}
			}
			//crew is not standing by exit
			return false;
		}
		
		//this function is called by setNPCPath
		//function determines if the doorway of the current room is 
		//blocked by a crew member 
		//the crew members radius is determined by the weapon they are carrying
		private function IsCrewSafeDistance(area:Rect,people:Array):Person
		{
			var personDistance:Number = area.height * area.width;
			var crewCount:int = people.length;
			for(var i:int=0;i<crewCount;i++)
			{
				var robber:Person = people[i];
				var minDistance:Number = robber.getWeaponRadius() * robber.getWeaponRadius() +personDistance;
				//check to ensure that the robber is active
				if(robber !=null && robber.isActive)
				{												
					//if the door entry is covered by the robber 
					//then return true because person cannot escape without
					//encountering a robber
					var xDist:Number = ( area.centrePoint.x - robber.position.x) * ( area.centrePoint.x - robber.position.x);
					var yDist:Number = ( area.centrePoint.y - robber.position.y) * ( area.centrePoint.y - robber.position.y);
					var currDistance:Number = xDist + yDist; 

					if(currDistance<minDistance)
					{
						return robber;
					}
				}
			}
			//crew is not standing by exit
			return null;
		}		
		
		//this function is called by setNPCPath
		//function determines if the path to the destination 
		//is blocked by a crew member . We do this by checking if 
		//crew member is contained within a rectangle between the exit Point 
		//and the person
		private function IsPathToExitBlocked(exit:cPoint, person:Person, crew:Crew):Boolean
		{
			var minX:int = Math.min(person.position.x, exit.x);
			var minY:int = Math.min(person.position.y, exit.y); 
		
			//a rectangle representing a possible path
			var path:Rect =  new Rect(minX,minY,
								Math.abs(person.position.x - exit.x),
								Math.abs(person.position.y - exit.y));
			return IsCrewWithinArea(path,crew.members);
		}

		
		//Called by FindSafePlace
		///gets nodes radius  steps away from current node 
		//in the direction of the node and tests if there is an obstacle there
		//returns the nodes that don't contain obstacles
		private function getFleeNodes( startNode:Node,direction:cPoint, gameMap:Map, radius:int):Array
		{
			var currNode:Node   = startNode.clone();
			var testNodes:Array = new Array();
			direction.normalize();
			direction.multiplyScalar(radius); //ensure that we cover the radiusat every step
			currNode.indexX +=direction.x  //set our current node to a position in the direction we want to flee
			currNode.indexY += direction.y;
			var minX:int = (currNode.indexX-radius)<0?0:currNode.indexX-radius;
			var maxX:int = (currNode.indexX+radius)>gameMap.getMapWidth()?gameMap.getMapWidth():currNode.indexX+radius;
			var minY:int = (currNode.indexY-radius)<0?0:currNode.indexY-radius;
			var maxY:int = (currNode.indexY+radius)>gameMap.getMapHeight()?gameMap.getMapHeight():currNode.indexY+radius;
			for(var testX:int= minX;testX<maxX;testX++)
			{
				for(var testY:int=minY;testY<maxY;testY++)
				{	
					//test nodes all around the current node
					if(minX ==testX 
						|| minY ==testY
						|| maxX == testX
						|| maxY == testY)
					{
						if(nodeAvailable(gameMap.getNode(testX,testY),null))
						{
							testNodes.push(gameMap.getNode(testX,testY));
						}
					}
				}			
			}
			return testNodes;
		}
		


		//called by setNPCPath
		//function finds a point that is not within the vicinity of the crew member
		//or returns current position because there is no safe place to move
		private function FindSafePlace(person:Person, robber:Person ,gameLevel:GameLevel):cPoint
		{
			//check all adjacent Nodes
			//if any of them are safe  - move to that node
			var currNode:Node  = gameLevel.gameMap.getNodeByPoint(person.position);
				
			//examine the crew nodes and determine which one gets us farther awy from the crew member to the destination
			var fleeDirection:cPoint = cPoint.clone(person.position);
			fleeDirection.subtract(robber.position);
			
			//gets all nodes that we could move to
			var adjNodes:Array = getFleeNodes(currNode, fleeDirection, gameLevel.gameMap,4);

			//holds a  list of nodes that are safe to move to
			var safeNodes:Array = new Array();
			
			//scroll through the nodesand figure out which ones are not occupiedcd bankgame
			var length:int =adjNodes.length;
			for(var i:int;i<length;i++)
			{
				var safeNode:Node = adjNodes[i];
				var safeRect:Rect = person.getSafeRect();
				safeRect.x = safeNode.getCentrePoint().x;
				safeRect.y = safeNode.getCentrePoint().y;
				if(!IsCrewWithinArea(safeNode.getRect(),gameLevel.crew.members)
					&& !IsCrewWithinArea(safeNode.getRect(),gameLevel.bank.people))
				{
					safeNodes.push( safeNode.getCentrePoint());
				}
			}
			
			//we have a list of safe nodes so randomly pick one
			if(safeNodes.length>0)
			{
				var randomNode:int =( Math.random()*100 ) % safeNodes.length;
				return safeNodes[randomNode];
			}
			
			return person.position;
		}
		
		
		
	}



}