
package
{

import flash.geom.Point;

 public class settings
 {

		//Main Window Settings
		public static var screenWidth:int = 900;
		public static var screenHeight:int = 650; 
		public static var backgroundColor:int = 0x000000;
		public static var foregroundColor:int = 0xFFFFFF;
		public static var greenColor:int = 0x00AA00;
		public static var yellowColor:int = 0xFFFF00;
		public static var lineThickness:int = 2;
		public static var borderThickness:int = 5;
		public static var titleAreaHeight:int = 60
		public static var mainAreaY:int = settings.titleAreaHeight+ 3* settings.borderThickness;
		
		//border
		public static var borderX:int= 5;
		public static var borderY:int= 65;
		public static var borderRectHeight:int = settings.screenHeight - (settings.borderY + 2* settings.borderThickness); 
		public static var borderRectWidth:int  = settings.screenWidth - ( 2* settings.borderThickness );
		public static var borderRectCornerRadius:int  = 70;		

		//title
		public static var titleX:int = settings.borderThickness;
		public static var titleY:int = 0;
		public static var titleRectHeight:int = settings.titleAreaHeight; 
		public static var titleRectWidth:int  = settings.screenWidth/2 -  settings.borderThickness;
		public static var titleRectCornerRadius:int  = 50;
				
		//Safe Area
		public static var safeX:int =  3 * settings.borderThickness ;
		public static var safeY:int = settings.mainAreaY;
		public static var safeRectHeight:int =  settings.screenHeight  -  settings.mainAreaY - ( 4* settings.borderThickness ); ; 
		public static var safeRectWidth:int = 380;		
		public static var safeRectCornerRadius:int = 50;
		public static var safeTitleMargin:int = 15;
		public static var safeTitleLeftMargin:int = 100;
		public static var safeDamageX:int = 100;
		public static var safeDamagePointsX:int = 170;
		public static var safeDamageY:int = 390;
		public static var safeDamageYSpacing:int = 62;
		public static var safeDamagePointsAlignY:int = 10;

		
		
		//Bank Area
		public static var bankX:int = settings.safeRectWidth + settings.safeX+ settings.borderThickness;
		public static var bankY:int  = settings.mainAreaY ;
		public static var bankRectHeight:int = settings.screenHeight  -  settings.mainAreaY - ( 4* settings.borderThickness ); 
		public static var bankRectWidth:int = settings.screenWidth - ( 3* settings.borderThickness ) - settings.bankX;
		public static var bankRectCornerRadius:int= 50;
		public static var bankMargins:int = 15;
		public static var bankRoomX:int = settings.bankX + 50;
		public static var bankRoomY:int = settings.bankY +settings.bankMargins+30;
		public static var bankRoomWidth:int = settings.bankRectWidth*0.8;
		public static var bankRoomHeight:int = settings.bankRectHeight*0.5;
		public static var exitX:int = settings.bankRoomX + settings.bankRoomWidth/2;
		public static var exitY:int = settings.bankRoomY +  settings.bankRoomHeight;
		
		//menu  click Area
		public static var menuX:int = settings.screenWidth - 70;
		public static var menuY:int = settings.borderThickness * 2;
		
		//menu ListingArea
		public static var menuListingX:int = settings.safeX+ settings.safeRectWidth/10;
		public static var menuListingY:int = settings.safeY+ settings.safeRectHeight/10;
		public static var menuListingWidth:int = 250;
		public static var menuBulletOffset:int = 30;
		

		// Timer Area
		public static var timerX:int = settings.bankX + settings.borderThickness;
		public static var timerY:int = settings.borderThickness * 2 +2;
		public static var timerTextX:int = settings.bankX + 4*settings.borderThickness;
		public static var timerTextY:int = settings.borderThickness * 3 +4;
		public static var timerRectHeight:int = 35; 
		public static var timerRectWidth:int = 80;
		public static var timerRectCornerRadius:int = 12;
		
		//Cash Area
		public static var cashX:int = settings.timerX + settings.timerRectWidth + settings.borderThickness *10;
		public static var cashY:int  =  settings.borderThickness * 3 +4;
		public static var cashRectHeight:int  = 35; 
		public static var cashRectWidth:int  = 150;		
		public static var cashRectCornerRadius:int = 12;
		public static var maxRandomCash:int= 10000;
		public static var minRandomCash:int= 1000;
		public static var crewRansom:int = 1000;
		
		//Font
		public static var fontColor:uint = 0xFFFFFF;
		public static var warnColor:uint = 0xFF0000;
		public static var deselectedFontColor:int  = 0x888888;
		public static var selectedFontColor:int  = 0xFFFFFF;
		public static var titleFontSize:int = 48;
		public static var standardFontSize:int = 26;
		public static var cashFontSize:int = 26;
		public static var menuFontSize:int = 30;
		public static var smallFontSize:int = 12;
		public static var toolFontSize:int = 20;
		
		//Resource Folders
		public static var imageFolder:String ="images";
		public static var fontFolder:String ="fonts" ;
		public static var standardFont:String = "Parisish"; //loaded in  EmbedAssets.as
		public static var titleFont:String = "Park Lane";//loaded in  EmbedAssets.as
		
		//GameLoop Settings
		public static var framesPerSecond:int = 30;
		public static var ticksPerFrame:int = 1000/settings.framesPerSecond;
		
		//Serialization Settings
		public static var comma:String=",";
		public static var newLine:String="\n";
		
		//Room settings
		public static var roomId:String="ROOM";
		public static var roomWidth:int = 90;
		public static var roomHeight:int = 90;
		public static const BLOCKED:cPoint = new cPoint(-1,-1,-1);
		

		//Door drawing vectors used in DoorType.draw()
		public static var doorWidth:int = 35;
		public static var doorRadius:int = 10;
		
		
		//person details
		public static var personWidth:int =20;
		public static var personHeight:int =20;
		public static var speed:Number= 1;
		public static var peopleSize:int = 20;
		public static var ZEROVELOCITY:cPoint = new cPoint(0,0,0);
		public static var MAXPATHLENGTH:int=10;
		public static var penaltyPersonLeftBank:int = 10000; //10 second penalty for every person that leaves the bank
		
		//Tool Details
		public static var toolWidth:int = 60;
		public static var toolHeight:int = 60;
		public static var toolWidthSpacing:int = 10;
		public static var toolUsesWidth:int =  15;
		public static var toolUsesHeight:int =  20;
		public static var maxToolsPerPerson:int = 5;
		public static var toolDisplayTopMargin:Number = settings.bankRoomY + settings.bankRoomHeight+ settings.bankMargins;
		public static var toolDisplayLeftMargin:Number = settings.bankRoomX;
		public static var toolSelectionName:String="SELECTEDTOOL";
		public static var toolImageName:String="IMAGEFORTOOL";
		public static var toolUsesName:String="USESFORTOOL";
		public static var toolCrewID:String="CREWID";
		public static var toolSeparator:String = "_";
		
		//Help Tips
		public static var helpIconX:int = settings.bankX + settings.bankRoomWidth + 50;
		public static var helpIconY:int = settings.bankY+ settings.bankMargins;
		public static var helpIdTag:String="HELPID";
		
		//Message Box
		public static var messageBoxWidth:int = 450;
		public static var messageBoxHeight:int = 130;
		public static var messageBoxX:int = settings.bankX + settings.bankMargins;
		public static var messageBoxY:int = settings.bankY+ settings.bankRoomHeight/2;
		public static var messageBoxCornerRadius:int = 10;
		public static var messageBoxBorder:int = 3;
		public static var messageBoxMaxChoices:int = 5;
		public static var CHOICEIX:String = "CHOICESELECTION";
		public static var messageBoxLineHeight:int= 20;


		//Store details
		public static var maxToolsPerStore:int = 5;
		public static var storeSeparator:String="_";
		public static var storeToolID:String="StoreTool";
		public static var storeCrewID:String="StoreCrewImage";
		public static var storeCrewToolID:String="StoreCrewTool";
		public static var toolSellingUsesName:String="StoreSellingTool";
		public static var toolsForSaleText:String = "Tools For Sale";
		public static var storeSellToolsTitleX:int = settings.safeX + settings.bankMargins;
		public static var storeSellToolsTitleY:int = settings.safeY + settings.bankMargins ;
		public static var storeSellToolsCostX:int = settings.storeSellToolsTitleY 
		public static var storeSellToolsX:int = settings.safeX; 
		public static var storeSellToolsY:int = settings.safeY + settings.bankMargins + settings.toolHeight;
		public static var storeSellToolsDescX:int = settings.safeX + settings.toolWidth;
		public static var maxUses:int =3;
		public static var toolMargin:int = 3;
		
		public static var leaveX:int = settings.bankX;
		public static var leaveY:int = settings.cashY;
		public static var sellX:int = settings.bankRoomX;
		public static var sellY:int = settings.bankY + 150;		
		public static var buyX:int = settings.bankRoomX;
		public static var buyY:int = settings.bankY  + 150;		
		public static var negotiateX:int = settings.sellX;
		public static var negotiateY:int = settings.bankRoomY- settings.bankMargins;		
		public static var sellDescriptionWidth:int = 275;
		public static var storeToolHeight:int = settings.toolHeight+ settings.bankMargins;
		public static var leaveWidth:int = 105;
		public static var leaveHeight:int = 35;
		public static var leaveRoundedRadius:int = 12;
		public static var tradeToolCrewX:int = settings.bankRoomX;
		public static var tradeToolCrewY:int = settings.bankRoomY+ 205;
		public static var tradeToolSpriteY:int = settings.bankRoomY+145;
		public static var tradeToolSpriteX:int = settings.bankRoomX;
		public static var tradeToolPriceX:int =  settings.bankRoomX + settings.toolWidth + settings.bankMargins;
		public static var tradeToolPriceY:int =  settings.tradeToolSpriteY;
		public static var storeTitleX:int = settings.bankX + settings.bankMargins ;
		public static var storeTitleY:int = settings.storeSellToolsTitleY;
		public static var storeHelpWidth:int = 450;
		public static var storeHelpX:int = settings.storeTitleX;
		public static var storeHelpY:int = settings.storeTitleY + 35; 
		
		//Map  Settings
		public static var mapNodeSize:int = 10;
		public static var mapHeight:int = settings.bankRoomHeight + 2*settings.mapNodeSize;
		public static var mapWidth:int = settings.bankRoomWidth + 2*settings.mapNodeSize;
		public static var maxPath:int = 100; //used to ensure that when serarching for a good path we don't spend too much time
		
 }


}
