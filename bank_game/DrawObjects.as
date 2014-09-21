package
{
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.Graphics;
	import flash.text.TextField;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.text.AntiAliasType;	
	import mx.formatters.CurrencyFormatter;
	
	//this class draws all objects for the game
	public class DrawObjects
	{
	
		// ***********************
		// DRAW ROUNDED RECTS
		// ***********************
		public static function drawColoredRect(target:Graphics, 
												color:int,
												width:int,
												height:int,
												roundedRadius:int,
												lineThickness:int,
												lineColor:int):void 
			{
				//creates a rectangle with a background and rounded corners
				//stores the grphics in the sprite passed in
				target.lineStyle(lineThickness, lineColor);
				target.beginFill(color);
				target.drawRoundRect(0, 0, width, height, roundedRadius, roundedRadius);
			}
	
		// ***********************
		// DRAW ALL LABELS
		// ***********************
		//called by menu.as, 
		//GameSprites.as
		//StoreSprites.as
		public static function configureLabel(label:TextField,
											 fontName:String,			//the font name
											 defaultText:String,		// characters to draw
											 color:int,						//color of the characters
											 size:int):TextField 			//the size of the font
			{
	
				//draw text onto the screen using the requested font
				//set the standard defaults for all labels
				label.autoSize = TextFieldAutoSize.LEFT;
				label.background =false;
				label.border = false;
				label.embedFonts = true;
				label.antiAliasType = AntiAliasType.ADVANCED;
				var format:TextFormat;
				
				//set default formats
				if(label.defaultTextFormat==null)
					format = new TextFormat();
				else
					format = label.defaultTextFormat;
					
				format.font = fontName;
				format.color =color;
				format.size = size;
				format.underline = false;
				label.defaultTextFormat = format;
				label.text=defaultText;
				
				//return the label
				return label;
			}
			
	
		
		
		// ******************************************
		//  DRAW ROOM
		// ******************************************
		public static function drawRoom(g:Sprite,
										room:Room,
										index:int):Sprite
		{
			if(g ==null|| room==null)
			{
				return g;
			}
			//figure out lengths of line segments so
			//so that we leave an opening for the door
			//adjust segments to accommodate door
			//ensure that door does not exceed half of room width/height
			var halfHeight:Number  = room.height/2;
			var halfWidth:Number  = room.width/2;
			var doorWidth:Number = room.doorType*settings.doorWidth;
			var doorHeight:Number = settings.doorWidth>halfHeight?halfHeight:settings.doorWidth;
			var doorPosition:cPoint = new cPoint();
			
			//create a closed box
			var square_commands:Vector.<int> = new Vector.<int>();
			square_commands.push(1,2,1,2,2,
								 1,2,2,1,2,
								 2,1,2);
			
			//create segments for the room
			var square_coords:Vector.<Number> = new Vector.<Number>();
			square_coords.push(  
					0,0, 		  			//0 top corner  			1
					halfWidth,0 , 			//2 top middle				2
					halfWidth,0 , 			//4 move to top middle		1
					room.width,0, 			//6 top right				2
					room.width,halfHeight, 	//8 upper right				2
					room.width,halfHeight, 	//10 move to upper right	1
					room.width, room.height,//12 lower right			2
					halfWidth,room.height, 	//14 bottom right			2
					halfWidth,room.height, 	//16 move bottom right 		1
					0,room.height, 			//18 bottomleft				2
					0,halfHeight,			//20 lower left				2
					0,halfHeight,			//22 movelower left			1
					0,0);					//24 upper left 			2


					//figure out which segment should hold the door and adjust the vertext accordingley
			switch(room.doorLocation)
			{
				case DoorLocation.TOP_LEFT:
					square_coords[0]=doorWidth;
					doorPosition.x = square_coords[0]+ settings.doorRadius/2+2;
					doorPosition.y = square_coords[1] + settings.doorRadius/2+3;
					break;
				case DoorLocation.TOP_CENTER:
					doorPosition.x = square_coords[2];
					doorPosition.y = square_coords[3];
					square_coords[2]= square_coords[2] -doorWidth/2;
					square_coords[4]= square_coords[4] +doorWidth/2;
					break;											
				case DoorLocation.TOP_RIGHT:
					square_coords[2]=square_coords[2]+ (halfWidth-doorWidth);
					square_coords[4]=square_coords[6];
					doorPosition.x = square_coords[2] - doorWidth/2 + 3;
					doorPosition.y = square_coords[3] + doorHeight/2 -2;
					break;
				case DoorLocation.RIGHT_TOP:
					square_coords[9]=square_coords[5];
					square_coords[11]=square_coords[11]- (halfHeight-doorWidth);
					doorPosition.x = square_coords[10]- settings.doorRadius/2 - 2;					
					doorPosition.y = square_coords[11] + settings.doorRadius/2 +3;	
					break;											
				case DoorLocation.RIGHT_CENTER:
					square_coords[9]=square_coords[9]- doorWidth/2;
					square_coords[11]=square_coords[11] + doorWidth/2;
					doorPosition.x = square_coords[10] - settings.doorRadius/2-2;					
					doorPosition.y = square_coords[11] + settings.doorRadius/2 + 3;					
					break;											
				case DoorLocation.RIGHT_BOTTOM:
					square_coords[9]=square_coords[9]+ (halfHeight-doorWidth);
					square_coords[11]=square_coords[13];
					doorPosition.x = square_coords[8] - settings.doorRadius/2 - 2;
					doorPosition.y = square_coords[9] - settings.doorRadius/2 - 3;
					break;											
				case DoorLocation.BOTTOM_RIGHT:
					square_coords[14]=square_coords[12];
					square_coords[16]=square_coords[16] + (halfWidth-doorWidth);
					doorPosition.x = square_coords[16] - settings.doorRadius/2 -2;
					doorPosition.y = square_coords[17] - settings.doorRadius +3;
					break;					
				case DoorLocation.BOTTOM_CENTER:				
					square_coords[14]=square_coords[14]+ doorWidth/2;
					square_coords[16]=square_coords[11]- doorWidth/2;
					doorPosition.x = square_coords[14] + settings.doorRadius/2+2;					
					doorPosition.y = square_coords[15] - settings.doorRadius +3;					
					break;											
				case DoorLocation.BOTTOM_LEFT:
					square_coords[14]=square_coords[14]- halfWidth +doorWidth;
					square_coords[16]=square_coords[18];
					doorPosition.x = square_coords[14] + settings.doorRadius/2+2;					
					doorPosition.y = square_coords[15] - settings.doorRadius+3;					
					break;					
				case DoorLocation.LEFT_BOTTOM:
					square_coords[21]=square_coords[19];
					square_coords[23]=square_coords[23] + (halfHeight - doorWidth);
					doorPosition.x = square_coords[22] + settings.doorRadius -2;	
					doorPosition.y = square_coords[23] - settings.doorRadius/2 -2;			
					break;											
				case DoorLocation.LEFT_CENTER:			
					square_coords[21]=square_coords[21]+ doorWidth/2;
					square_coords[23]=square_coords[23]- doorWidth/2;
					doorPosition.x = square_coords[20] + settings.doorRadius -2;
					doorPosition.y = square_coords[21] + settings.doorRadius- 3;		
					break;											
				case DoorLocation.LEFT_TOP:
					square_coords[25]=square_coords[25] + doorWidth;
					doorPosition.x = square_coords[24]+ settings.doorRadius-2;						
					doorPosition.y = square_coords[25]+ settings.doorRadius/2+2;			
					break;											
			}
		
			//create the room sprite
			var gRoom:Sprite= new Sprite();
			gRoom.graphics.lineStyle(1,settings.foregroundColor,1.0);
			gRoom.graphics.drawPath(square_commands,square_coords);
			
			//if there is a door then draw it in
			if(room.doorType!= DoorType.NONE)
			{
				var door:Sprite = new Sprite();
				door.name = Room.DOORCLASSID+index;
				DrawObjects.drawDoor(door,room.doorType, room.doorLocation);
				door.x = room.x + doorPosition.x;
				door.y = room.y + doorPosition.y;
				g.addChild(door);
			}
			
			//configure hit areaso that the mouse hist accrodingley and not on any children of the sprite
			var hitArea:Sprite = new Sprite();
			hitArea.graphics.beginFill(0x000000);
			hitArea.graphics.drawRect(room.x,room.y,room.width,room.height);
			hitArea.mouseEnabled= false;
			hitArea.visible=false;
			
			//if room is safe then indicate so
			if(room.isSafeHere)
			{
				var safeText:TextField  = new TextField();
				DrawObjects.configureLabel(safeText,
								 settings.standardFont,
								"safe",
								 settings.foregroundColor,
								 settings.standardFontSize);
				safeText.x = room.x+ + room.width/10;
				safeText.y = room.y+ room.height/4;
				safeText.selectable = false;
				safeText.mouseEnabled=false;
				g.addChild(safeText);
			}
			
			//place the room within the bank
			gRoom.x =room.x;
			gRoom.y = room.y;
			g.addChild(gRoom);

			//set the clickable area
			g.hitArea = hitArea;
			g.addChild(hitArea);
			return g;
		}
	
	
		// ******************************************
		//  DRAW DOOR
		// ******************************************
		//called by draw room
		public static function drawDoor(door:Sprite,
										doorType:int,
										dooorLocation:int):void
		{
			//if there is no door then return
			if(door == null)
			{
				return;
			}
			
			//if door is not then return
			if (doorType == DoorType.NONE)
			{
				return;
			}			
			
			//identify the door with teh correct ID
			door.name = Room.DOORCLASSID;
			
			//set the line format for the door
			door.graphics.lineStyle(1,settings.foregroundColor,1.0);
			door = drawDoorArc(door,dooorLocation,DoorType.SINGLE);
			
			//if this is a double door then draw it double wide
			if(doorType == DoorType.DOUBLE)
			{
				//get reverse doorPosition
				door = drawDoorArc(door,dooorLocation,DoorType.DOUBLE);
			}
		}
		
		
		// draw the door arc
		//called by drawDoor
		public static function drawDoorArc(doorSprite:Sprite,
											doorLocation:int,
											doorType:int):Sprite
		{
			var startAngle:Number = 0;
			var endAngle:Number = 0;
			
			//figure out what the correct angles for the arc would be
			//depending on where the door is
			switch(doorLocation)
			{
				case DoorLocation.BOTTOM_RIGHT:
				case DoorLocation.TOP_RIGHT:
				case DoorLocation.TOP_CENTER:
					startAngle =315;
					endAngle = 405;
					break;											
				case DoorLocation.LEFT_TOP:
				case DoorLocation.LEFT_CENTER:
				case DoorLocation.RIGHT_TOP:
				case DoorLocation.RIGHT_CENTER:
					startAngle =225;
					endAngle = 315;
					break;											
				case DoorLocation.LEFT_BOTTOM:
				case DoorLocation.RIGHT_BOTTOM:
					startAngle =45;
					endAngle = 135;
					break;											
				case DoorLocation.TOP_LEFT:
				case DoorLocation.BOTTOM_LEFT:
				case DoorLocation.BOTTOM_CENTER:
					startAngle =135;
					endAngle = 225;
					break;
			}
			
			//if the door is   double then 
			//switch  angles for other side
			if(doorType==DoorType.DOUBLE)
			{
				var tmp:Number = startAngle;
				 startAngle = endAngle;
				 endAngle = tmp;
			}
			
			//draw the arc
			doorSprite = Arc.draw(doorSprite,
						0,//x
						0,//y
						settings.doorRadius,
						startAngle,//angle_from
						endAngle,//angle_to:Number
						1); //precision
			return doorSprite;

		}
		
		// ********************************
		//  Convert Time to countdown clock
		// *********************************
		//called by GameSprites:updateTimerSprite
		public static function convertToCountDown(currText:TextField, timeLeft:int):TextField
		{
			//configure the label the time to string converts the milliseconds to proper minute: seconds format
			return configureLabel(currText,
								settings.standardFont,
									 DrawObjects.timeToString(timeLeft),
									 settings.foregroundColor,
									 settings.standardFontSize);
		}
		
		//converts milliseconds into minute::seconds format ##:##
		//called by convertToCountDown
		public static function timeToString(timeLeft:int):String
		{
			//split out the minutes
			var minutes:int =Math.floor(timeLeft/60000);
			var minuteStr:String = minutes+":";
			
			//split out the seconds
			var seconds:int = (timeLeft % 60000)/1000 ;
			var secondStr:String = seconds<10?"0"+seconds:""+seconds;	
			secondStr = secondStr.substring(0,2);
			
			//pad the string with spaces so it fits neatly within our timer box
			var padString:String ="                                                                 ";
			var timeStr:String = padString+ minuteStr+secondStr;		
			
			return timeStr.substr(timeStr.length-8,8);
		}

		// ********************************
		//  Convert Time to money format
		// *********************************
		//called by GameSprites.as:updateCashSprite
		//called by StoreSprites.as:updateCashSprite
		public static function convertToMoney(currMoney:TextField, money:int):TextField
		{
				//create the label with the money
				//money to string does the dollars/cents conversion
			return	configureLabel(currMoney,
								settings.standardFont,
								moneyToString(money),
								 settings.foregroundColor,
								 settings.standardFontSize);
			
		}	

		
		//converts a number into currency
		//called by DrawObjects:convertToMoney
		public static function moneyToString( money:int):String
		{
				//create a curency formatted to convert the money
				var cf:CurrencyFormatter = new CurrencyFormatter();
				
				//specify the correct separators
				cf.thousandsSeparatorTo=",";
				cf.useThousandsSeparator=true;
				cf.currencySymbol='$';
				cf.decimalSeparatorTo='.';
				var moneyString:String  =  cf.format(money);
				if (money==0)
				{
					//if money is zero then format it ourselves
					moneyString="0.00";
				}
				var padString:String ="                                                                 ";
				moneyString = padString+moneyString;			
				//pad the string up to 15 characters
				return moneyString.substr( moneyString.length-15,15);
		}
		
		// ********************************
		//  Draw People
		// *********************************
		// called by GameStore.as : updatePeopleSprites
		public static function drawPerson(personSprite:Sprite,person:Person):Sprite
		{
			var currText:TextField = new TextField();

			//create a text field and configure it
			currText = configureLabel(currText,
								settings.standardFont,
								 person.name,
								 settings.foregroundColor,
								 settings.peopleSize);
								 
			//create a sprite to hold this 
			personSprite.addChild(currText);
			
			//give it a unique ID 
			personSprite.name = Person.CLASSID+person.name;			
			personSprite.mouseEnabled = false;

			//do not enable mouse events - cause it causes issues when navigating robbers near people
			currText.mouseEnabled = false;
			return personSprite;
		}
		
		//Draw the bank robbers
		//called by gameSprites:update toolsprites
		public static function drawCrew(crewSprite:Sprite,person:Person):Sprite //pass in the sprite and the person to copy
		{
			//ensure that the crew sprite is not null
			if(crewSprite == null)
			{
				crewSprite = new Sprite();
			}
			
			//ensure that the person is not null
			if(person==null)
			{
				return crewSprite;
			}
			
			//create the label of X
			var currText:TextField = new TextField();
			//draw the person
			currText = configureLabel(currText,
								settings.standardFont,
								 "X",
								 settings.foregroundColor,
								 settings.peopleSize);	
								 
			//add it tothe main sprite
			crewSprite.addChild(currText);
			crewSprite.name = Crew.CLASSID+person.name;
			
			return crewSprite;
		}
		
		//draw a little marker (currently the person name) when the person is navigating towards a destination
		//passed in is the parent sprite and the person sprite
		//called by gameSprites:update toolsprites
		public static function drawDestination(destinationSprite:Sprite,person:Person):Sprite
		{
			if(destinationSprite!=null)
			{
				//create the marker
				var currText:TextField = new TextField();
				//draw the person
				currText = configureLabel(currText,
									settings.standardFont,
									 person.name,
									 settings.deselectedFontColor,
									 settings.smallFontSize); //use small font size so it doesn't interfere with the map
				currText.x=1;
				destinationSprite.addChild(currText);
			
				//provide a unique name for this sprite so we can find it an change its location later
				destinationSprite.name = Person.DESTINATION+person.name;
			}
			return destinationSprite;
		}
			
			
			// *****************************
			//  WEAPONS RADIUS
			// *****************************
			//draw the translucent weapons radius around the wepons
		//called by gameSprites:update toolsprites
		public static function drawWeaponsRadius(destinationSprite:Sprite,person:Person):Sprite
		{
			if(destinationSprite!=null)
			{

				//draw a translucent circle indicating where people in the bank will not cross (if given a choice)
				//set the opacity to something low so it doesnot obscure other objects but can be seen on lousy monitors
				destinationSprite.graphics.beginFill(settings.deselectedFontColor,0.1); //draw a transparent circle indicating the weapons radius
				destinationSprite.graphics.drawCircle(person.width/2,person.height/2,person.getWeaponRadius());
				destinationSprite.graphics.endFill();
				//this is not a clickable field ensure it does not affect other mouse functions
				destinationSprite.mouseEnabled=false;
			}	
			return destinationSprite;
		}
			
		// ***************************
		//      TOOLS
		// ***************************
		//draw the person name large next to the tools
		//called by gameSprites:update toolsprites
		//called by GaemStore.updatetoolSprites
		public static function drawCrewToolId(parentSprite:Sprite,person:Person,isSelected:Boolean):Sprite
		{
			if(parentSprite!=null)
			{
				var currText:TextField = new TextField();
				//draw the person
				currText = configureLabel(currText,
									settings.standardFont,
									 person.name,
									 (isSelected?settings.foregroundColor:settings.deselectedFontColor),
									 settings.menuFontSize);
				//add to the parent sprite
				parentSprite.addChild(currText);
			}
			return parentSprite;
		}
		
		//draws the selection rect around each tool that is currently being used by the robber
		//called by gameSprites:update toolsprites
		public static function drawTool(parentSprite:Sprite, usesTextField:TextField, crew:Person, tool:Tool):Sprite
		{
			if(tool == null)
			{	//ensure we don't work with null items
				return parentSprite;
			}

			if(parentSprite!=null )//&& tool.uses!=0
			{								
				//add the tool Image
				parentSprite.addChild(EmbedAssets.getImage(tool.imageIndex));
			}
			if(tool.uses >=1 && usesTextField!=null)
			{	//add the uses in the top corner if this item has limitted applications
				//create the white rect
				DrawObjects.drawColoredRect(parentSprite.graphics,
											settings.foregroundColor,
											settings.toolUsesWidth,
											settings.toolUsesHeight,
											0,
											1,
											settings.foregroundColor);
				//draw the number
				usesTextField = configureLabel(usesTextField,
									settings.standardFont,
									 ""+tool.uses,
									 settings.backgroundColor,
									 settings.toolFontSize);	
			}
			return parentSprite;
		}
		
		//draw the rectangle around a tool
		//		if it is currently in use then the color is white
		//if it is not in use the color is black
		public static function drawToolSelected(parentSprite:Sprite, tool:Tool,isCrewSelected:Boolean):Sprite
		{
			var colorFont:uint =settings.backgroundColor;
			if(parentSprite==null)
			{
				return null;
			}
			if( tool.inUse)
			{
				//get the correct font
				colorFont= (isCrewSelected ?settings.foregroundColor:settings.deselectedFontColor);				
			}
				//create the rectangle
				DrawObjects.drawColoredRect(parentSprite.graphics,settings.backgroundColor,
											settings.toolWidth,
											settings.toolHeight,
											0,
											1,
											colorFont);
			return parentSprite;
		}
		
		
		// ***********************************
		// SAFE DAMAGE 
		// **********************************
		//draw the number of hit points for an item
		//called from GameLeve.as:UpdateSafe
		public static function drawSafeHitPoints(textField:TextField,points:int):TextField
		{
			//create the text field
			textField = configureLabel(textField,
									settings.standardFont,
									 ""+points,
									 settings.foregroundColor,
									 settings.menuFontSize);	
			return textField;
		}
		
		
		
		// ********************
		//  DRAW MESSAGE BOX
		// ********************
		//called grom GameSprites.as: updateMessageBox
		public static function drawMessageBox(parentSprite:Sprite,msg:Message, width:int, height:int):Sprite
		{
			//account fro 100 chars per line
			//+ 1 line for each choice

			if(parentSprite==null)
			{
				return parentSprite;
			}
			
			//draw the message box with a white border around it
			DrawObjects.drawColoredRect(parentSprite.graphics, 
										settings.backgroundColor,
										width,
										height,
										settings.messageBoxCornerRadius,
										settings.messageBoxBorder,
										settings.foregroundColor);
			/* will be used later to make the dialog boxes more fancy
			var titleText:TextField  = new TextField();
			DrawObjects.configureLabel(titleText,
											 settings.standardFont,
											 "$$$",
											 settings.fontColor,
											 settings.menuFontSize);
			titleText.autoSize  = TextFieldAutoSize.CENTER;
			titleText.width = width;
			parentSprite.addChild(titleText);
			*/
			return parentSprite;
		}
		
		
	}
	
	


}