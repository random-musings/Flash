package{

	//Utiltiy class for holding points
	public class cPoint
	{
	
	 private static const TOLERANCE:Number=0.001; //used for determining if a point is equal this is the tolerance we allow
	 public var x:Number;	//the x coord
	 public var y:Number;	//the y coord
	 public var z:Number;		//the z coord (if we are in 3d space 

	 
	 //the constructor
	 public function cPoint(newX:Number = 0, newY:Number = 0, newZ:Number =0 )
	 {
		//assign new values
	     x = newX;
	     y = newY;
	     z = newZ;
	 }
	
	//teh clone function
	public static function clone(clonePoint:cPoint):cPoint
	{
		//will make a copy of a point 
		if(clonePoint==null 
			|| isNaN(clonePoint.x) 
			|| isNaN(clonePoint.y) 
			|| isNaN(clonePoint.z) 
		)
		{
			//returns zero if point is invalid
			return new cPoint(0,0,0);
		}
		//returns a memory separate point
		return new cPoint(clonePoint.x,clonePoint.y,clonePoint.z);
	}
	 
	 //copies the values of a point into the current poin
	 public function  copy ( copyPoint:cPoint):void
	 {
		//ensure we are not working with null
		 if(copyPoint!=null)
		 {
			//copy the variables
		     x = copyPoint.x;
		     y = copyPoint.y;
		     z = copyPoint.z;
		 }
	 }
	 
	 
	 //determine if a point is equla
	 public function equal( point:cPoint):Boolean
	 {
		//ensure that the point is not null
		 if(point!=null)
		 {
			 if(Math.abs(x - point.x)<TOLERANCE )
			 {
				if(Math.abs(y - point.y)<TOLERANCE )
				{
					if(Math.abs(z - point.z)<TOLERANCE)
					{
						//all values are within our tolerance so return true
					return true;
					}
				}
			}
		 }
		 //one or more of the values are not the same return false
	     return false;
	 }
	 
	 
	 //create a unit vector of the point
	  public  function normalize():void
	  {
			//find the magnitude
	      var mag:Number = magnitude();
		  
		  //if the vector is not zero
	      if(mag>0)
	      {
			//change it into a unit vector
	         x = x/mag;
	         y = y/mag;
	         z = z/mag;
	      }      
	  }
	  
	  //find the magnitude of the vector
	  public function magnitude():Number
	  {
		//called from normalize 
	     return Math.sqrt( x*x + y*y + z*z);
	  }
	  
	  
	  //adds one vector to another
	  public function add( newPoint:cPoint):cPoint
	  {
	  //ensure we don't work with the add
		  if(newPoint==null)
			  return this;
			  // add the new numbers in
	      x = newPoint.x + x;
	      y = newPoint.y + y;
	      z = newPoint.z + z;
	      return this;
	  }

	  //subtract one vector from another
	  public function subtract(newPoint:cPoint ):cPoint 
	  {
		//ensure we don't with null objects
		 if(newPoint==null)
			 return this;
			//subtract the values
	     x = x - newPoint.x;
	     y = y - newPoint.y;
	     z = z - newPoint.z;
	     return this;
	  }
	   
	   
	   //multiple a number to all points
	  public function multiplyScalar(scalar:Number):cPoint 
	  {
		//multiple the scalar
	     x = scalar * x;
	     y = scalar * y;
	     z = scalar * z;
	     return this;
	  }

	  
	  //converts a point to a string 
	  public function serialize():String
	  {
		//will cut the string to 2 decimal places
		var decimalPt:int=2;
		var decimal:Number = Math.pow(10,decimalPt);	
		return Math.round(x*decimal)/decimal+settings.comma+Math.round(y*decimal)/decimal+settings.comma+Math.round(z*decimal)/decimal;  
	  }

	  //initializes the point from a string
	  public static function  deserialize( src:String):cPoint
	  {
		//currently not initialize - resererved for future use
		/* Vector variables  = Split.parseStringList(src);
		//calls the Split.as to separate the values into an array
			//
			if(variables.size()<3)
				return new Point();
			return new cPoint((float)Double.parseDouble((String)variables.elementAt(0)),
					(float)	Double.parseDouble((String)variables.elementAt(1)),
					(float)	Double.parseDouble((String)variables.elementAt(2)));
					*/
			return new cPoint();		
	  }

	
	}
	
}
