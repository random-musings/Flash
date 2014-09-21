package
{
	public class Rect
	{
		public var x:int;
		public var y:int;
		public var width:int;
		public var height:int;
		public var centrePoint:cPoint;
		public function Rect(newX:int=0,
							newY:int=0,
							newWidth:int=0,
							newHeight:int=0
							)
		{
			x = newX;
			y = newY;
			width = newWidth;
			height = newHeight;
			centrePoint = new cPoint( x+ width/2, y + height/2,0);
		}
	
		public static  function valueInRange(value:int, min:int,  max:int):Boolean
		{ 
			return (value >= min) && (value <= max); 
		}
		
		public static function rectOverlap(A:Rect, B:Rect):Boolean
		{
			var xOverlap:Boolean = valueInRange(A.x, B.x, B.x + B.width) ||
							valueInRange(B.x, A.x, A.x + A.width);

			var yOverlap:Boolean = valueInRange(A.y, B.y, B.y + B.height) ||
									valueInRange(B.y, A.y, A.y + A.height);

			return xOverlap && yOverlap;
		}
	
		

	}

}