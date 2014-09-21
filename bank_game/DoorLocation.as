
package
{

	//thsi function hold the location of the door
	//it is used by the Room class to indicate where the entry/exit canbe found
	//the DrawObjects.Draw room uses this to figure out where to draw the door and its arc
	public class DoorLocation
	{
		//this is my version of an enumeration
		public static const NONE:int=0;
		public static const TOP_LEFT:int=1;
		public static const TOP_RIGHT:int =2;
		public static const LEFT_TOP:int =3;
		public static const LEFT_BOTTOM:int =4;
		public static const RIGHT_TOP:int =5;
		public static const RIGHT_BOTTOM:int =6;
		public static const BOTTOM_RIGHT:int =7;
		public static const BOTTOM_LEFT:int =8;
		public static const BOTTOM_CENTER:int =9;
		public static const TOP_CENTER:int =10;
		public static const LEFT_CENTER:int =11;
		public static const RIGHT_CENTER:int =12;
	}
	
}