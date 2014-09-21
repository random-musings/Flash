package
{
	public class Node
	{
		public var point:cPoint;
		public var state:int;
		public var height:int;
		public var width:int;
		public var indexX:int;
		public var indexY:int;
		
		//function constructor
		public function Node(newPoint:cPoint,
					newState:int,
					newHeight:int,
					newWidth:int,
					newIndexX:int,
					newIndexY:int)
		{
			point = new cPoint(0,0,0);
			point.copy(newPoint);
			height =newHeight;
			width= newWidth;
			state = newState;
			indexX= newIndexX;
			indexY = newIndexY;
		}
		
		public function clone():Node
		{
			return new Node( point,
						state,
						height,
						width,
						indexX,
						indexY);
		}
		
		//deep copy of contents of one node to another
		public function copy(newNode:Node):void
		{
			point.copy(newNode.point);
			state = newNode.state;
			height = newNode.height;
			width = newNode.width;
			indexX = newNode.indexX;
			indexY = newNode.indexY;
		}
	
		//is this an open node
		public function isBlocked():Boolean
		{
			return (state == NodeState.OBSTACLE);
		}
		
		//get the footprint of this node
		//ensure that the point is referring
		//to the center point of the node
		public function getRect():Rect
		{
			var halfHeight:int = height/2;
			var halfWidth:int  = width/2;
			return new Rect(point.x - halfWidth,
							point.y - halfHeight,
							width,
							height);
		}
		
		//check if point is within this node
		public function pointInNode(position:cPoint):Boolean
		{
			var rect:Rect  = getRect();
			if(position.x>=rect.x && position.x<=(rect.x+width))
			{
				if(position.y>=rect.y && position.y<= (rect.y+ height))
				{
					return true;
				}
			}
			return false;
		}
		

		//determines if we are referring to the same node
		//check if same x & y and same height & width
		public function equal(node:Node):Boolean
		{
			return (point.equal(node.point)  && height == node.height && width == node.width);
		}
		
		
		
		public function getCentrePoint():cPoint
		{
			var halfHeight:int = height/2;
			var halfWidth:int  = width/2;
			return new cPoint(point.x + halfWidth,point.y + halfHeight,0);
		
		}
		
		public function getIndexes():cPoint
		{
			return new cPoint(indexX,indexY,0);
		}
		
		
		
	}

}