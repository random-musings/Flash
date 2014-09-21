package
{
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.Graphics;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.text.TextFormat;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.AntiAliasType;

	public class MainScreen{
	
		public var drawTimerBox:Boolean;
		public var drawCashBox:Boolean;
		
		public function MainScreen()
		{
				drawTimerBox=false;
				drawCashBox=false;

		}
		
		public function drawMainStage(g:Sprite):void
		{
		
			var mainRect:Shape = new Shape();
			DrawObjects.drawColoredRect(mainRect.graphics,
							settings.backgroundColor,
							settings.screenWidth,
							settings.screenHeight,
							0,
							0,
							settings.backgroundColor);
			mainRect.x = 0;
			mainRect.y = 0;
			
			g.addChild(mainRect);
			

			//main border
			var borderRect:Shape = new Shape();
			DrawObjects.drawColoredRect(borderRect.graphics,
							settings.backgroundColor,
							settings.borderRectWidth,
							settings.borderRectHeight,
							settings.borderRectCornerRadius,
							settings.borderThickness,
							settings.foregroundColor);
			borderRect.x = settings.borderX;
			borderRect.y = settings.borderY;
			g.addChild(borderRect);	

			
			//Main Safe Area
			var safeRect:Shape = new Shape();
			DrawObjects.drawColoredRect(safeRect.graphics,
							settings.backgroundColor,
							settings.safeRectWidth,
							settings.safeRectHeight,
							settings.safeRectCornerRadius,
							settings.lineThickness,
							settings.foregroundColor);
			safeRect.x = settings.safeX;
			safeRect.y = settings.safeY;
			g.addChild(safeRect);	
			
			
			//Bank Layout Area
			var bankRect:Shape = new Shape();
			DrawObjects.drawColoredRect(bankRect.graphics,
							settings.backgroundColor,
							settings.bankRectWidth,
							settings.bankRectHeight,
							settings.bankRectCornerRadius,
							settings.lineThickness,
							settings.foregroundColor);
			bankRect.x = settings.bankX;
			bankRect.y = settings.bankY;
			g.addChild(bankRect);	
			
			var titleLabel:TextField = new TextField();
			DrawObjects.configureLabel(titleLabel,
							settings.titleFont,
							"The Big Score",
							settings.foregroundColor,
							settings.titleFontSize);
			g.addChild(titleLabel);
			titleLabel.x = settings.titleX;
			titleLabel.y = settings.titleY;


			
		}
		

		
	}

}