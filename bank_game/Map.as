package
{
	//this class holds the game Map
	//the game map has been generated prior to the game 
	//to view the maps for all levels check the AllMap.as class
	//I have chosen to pre-generate maps for each level because it takes to musch time to do this on the fly
	//

	public class Map
	{
		
		private var nodes:Array;
		private var nodeWidth:int;
		private var nodeHeight:int;
		private var mapWidth:int;
		private var mapHeight:int;
		
		// the constructor of the map class
		//parameters passed indicate the dimensions of the map
		public function  Map(
							newMapWidth:int, //total map width
							newMapHeight:int, //total map height
							newNodeWidth:int, //width of one node on the map
							newNodeHeight:int) //height of one node on the map
		{
			nodeWidth = newNodeWidth;
			nodeHeight = newNodeHeight;
			mapWidth  = newMapWidth;
			mapHeight = newMapHeight;
			initMap();
		}
		
		//load a new map into the game map to use for obstacle
		public function copyNodes(newMapNodes:Array):void
		{
			//get the starting position of the map
			var currPosition:cPoint = new cPoint(-5,-8,0);
			var nextXPosition:cPoint = new cPoint(nodeWidth,0,0);
			var nextYPosition:cPoint = new cPoint(0,nodeHeight,0);
			var currIndex:int=0;
			var xLength:int=newMapNodes.length;
			for(var x:int=0;x<xLength;x++)
			{
				var yLength:int = newMapNodes[x].length;
				for(var y:int=0;y<yLength;y++)
				{
					nodes[x][y] = new Node( cPoint.clone(currPosition),
											newMapNodes[x][y],
											nodeWidth,
											nodeHeight,
											x,
											y
											);
					currPosition.add(nextYPosition);
				}
				//advance/reset our node position for the next run through
				currPosition.y=0;
				currPosition.add(nextXPosition);
			
			}
		}
		
		
		//this function creates a map of the field
		//the collision function passed in takes a rectangle and checks it against all of the 
		//obstacles on the level.
		//This function is never called during gameplay  because it takes too long to
		//generate a map dynamically
		//it has been left in here so that I can easily generate maps for new levels.
		public function createMap(collisionFunction:Function):void
		{
			//reset the map too all obstacles sothat the previous map does not 
			//give us bad data if it was larger then the new map
			clearMap();
			var width:int  = nodes.length;
			for(var i:int=0;i<width;i++)
			{
				//scroll through all nodes
				var height:int = nodes[i].length;
				for(var j:int=0;j<height;j++)
				{
					var node:Node = nodes[i][j];
					if(node !=null)
					{
						//get the foot print of the node
						var rect:Rect = node.getRect();
						
						//test the node to see if obstacles reside on it
						node.state= collisionFunction(rect);
					}
				}
			}
		}
		
		
		//set all existing nodes to contain an obstacle
		//so that when it is re-initialized unchecked spaces are not free to walk all over.
		public function clearMap():void
		{
			var width:int  = nodes.length;
			for(var i:int=0;i<width;i++)
			{
				var height:int = nodes[i].length;
				for(var j:int=0;j<height;j++)
				{
					if(nodes[i][j]!=null)
					{
						setNodeState(i,j,NodeState.OBSTACLE);
					}
				}
			}
		}
		
		//creates the map and blank nodes
		//called by the constructor
		public function initMap():void
		{
			var xNodes:int = mapWidth/nodeWidth +1;
			var yNodes:int = mapHeight/nodeHeight +1;
			//if the map is not large enough to cover the dimensions - resize it
			if(nodes==null || nodes.length<xNodes)
			{	
				nodes = new Array(xNodes);
			}
			
			//get the starting position of the map
			var currPosition:cPoint = new cPoint(0,0,0);
			var nextXPosition:cPoint = new cPoint(nodeWidth,0,0);
			var nextYPosition:cPoint = new cPoint(0,nodeHeight,0);

			//for each node in the map 
			for(var x:int=0;x<xNodes;x++)
			{
				if(nodes[x]==null)
				{	//if this is first time through create the y dimension
					nodes[x] = new Array( yNodes);
				}
				for(var y:int=0;y<yNodes;y++)
				{	//create a new node at this spot
					//ddefault it to an obstacle
					nodes[x][y] = new Node( cPoint.clone(currPosition),
												NodeState.OBSTACLE,
												nodeWidth,
												nodeHeight,
												x,
												y
												);
												//advance to the next position
					currPosition.add(nextYPosition);
					
				}
				//advance/reset our node position for the next run through
				currPosition.y=0;
				currPosition.add(nextXPosition);
			
			}
		}
		
		
		//remove all nodes from the map
		//incur the wrath of the garbage collection...only call this when the user is quiting
		public function deleteMap():void
		{
			if(nodes==null)
			{
				return;
			}
			var width:int  = nodes.length;
			for(var i:int=0;i<width;i++)
			{
				nodes[i]=[];
			}
			nodes=[];
		}

		
		//set the map node state
		public function setNodeState(x:int, y:int, value:int):void		{
			//ensure that we don't access bad memory
			if(nodes.length<=x || x<0)
			{
				return;
			}
			//ensure that we don't access bad memory
			if(nodes[x].length<y || y<0)
			{
				return;			
			}
			nodes[x][y].state = value;
		}

		//return a node at  a specific index
		public function getNode(x:int, y:int):Node
		{
			if(nodes.length<=x || x<0)
			{
				return null;
			}
			if(nodes[x].length<y || y<0)
			{
				return null;			
			}
			return nodes[x][y];
		}
		
		//find a node based on a point(usually retrived from a mouse click)
		//called by game level to verify that a node is a valid place 
		//to move a character to
		public function getNodeByPoint( point:cPoint):Node
		{
		
			for(var x:int=0;x<nodes.length;x++)
			{
				for(var y:int=0;y<nodes[x].length;y++)
				{
					if(nodes[x][y].pointInNode(point))
					{
						return nodes[x][y];
					}
				}
			}	
			return null;
		}
		
		
		public function printMap():void
		{
			//prints an array of the map
			//this is never called during the game only to create new 
			//new arrays of a map, when arrays are created
			var line:String="";
			for(var x:int=0;x<nodes.length;x++)
			{
				line="";
				for(var y:int=0;y<nodes[x].length;y++)
				{
					if(line!="")
					{
						line+=",";
					}
					line +=""+nodes[x][y].state;
				}
				trace(line);
			}			
		}
		
		
		public function checkNodeIndexes():void
		{
			//this iscalled at the beginning of level mysteriously indexes would not be set
			//but when stepped through all went well
			//in a game - it is a check to ensure that all
			//has been set and corrects anomalies
			//print Node Indexes to ensure that they are all set
			var line:String="";
			for(var x:int=0;x<nodes.length;x++)
			{
				for(var y:int=0;y<nodes[x].length;y++)
				{
					if(nodes[x][y].indexX!=x ||
						nodes[x][y].indexY !=y)
					{
						trace("anomaly at nodes["+x+"]["+y+"] corrected ");
						nodes[x][y].indexX = x;
						nodes[x][y].indexY = y;
					}
					
				}
			}			
		
		
		}
		
		public function getMapHeight():int
		{
				return nodes[0].length;
		}
		
		public function getMapWidth():int
		{
				return nodes.length;
		}

		
	}
}