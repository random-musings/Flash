package
{
	public class PathDetails
	{
		public var destination:cPoint;
		public var path:Array;
		public var isRunningAway:Boolean;
		public function PathDetails()
		{
			destination = new cPoint (-1,-1,-1);
			path = new Array();
			isRunningAway=false;
		}
	
	
	}


}