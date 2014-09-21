package {
	import flash.display.DisplayObject;
	public class EmbedAssets  {
		
       // be sure this is pointing to a ttf font in your hardrive
      [Embed(source='c:\\projects\\flash\\bankgame\\fonts\\Parisish.ttf',  fontFamily="Parisish",fontWeight="Normal",embedAsCFF="false")] 
      public static var bar:String;

      [Embed(source='c:\\projects\\flash\\bankgame\\fonts\\ParkLaneNF.ttf',  fontFamily="Park Lane",fontWeight="Normal",embedAsCFF="false")] 
      public static var park:String;
		
      [Embed(source='c:\\projects\\flash\\bankgame\\images\\gun_marker_left.png')] 
      public static var GunLeft:Class;
	
      [Embed(source='c:\\projects\\flash\\bankgame\\images\\gun_marker_right.png')] 
      public static var GunRight:Class;

      [Embed(source='c:\\projects\\flash\\bankgame\\images\\safe1.png')] 
      public static var Safe1:Class;
	  
      [Embed(source='c:\\projects\\flash\\bankgame\\images\\safe2.png')] 
      public static var Safe2:Class;

      [Embed(source='c:\\projects\\flash\\bankgame\\images\\safe2opened.png')] 
      public static var Safe2Opened:Class;
	  
      [Embed(source='c:\\projects\\flash\\bankgame\\images\\safe3.png')] 
      public static var Safe3:Class;

      [Embed(source='c:\\projects\\flash\\bankgame\\images\\safe3opened.png')] 
      public static var Safe3Opened:Class;
	  
	  [Embed(source='c:\\projects\\flash\\bankgame\\images\\electricaldamage.png')]
	  public static var ElectricDamage:Class;
	  
	  [Embed(source='c:\\projects\\flash\\bankgame\\images\\lockpickdamage.png')]
	  public static var LockPickDamage:Class;
	  
	  [Embed(source='c:\\projects\\flash\\bankgame\\images\\physicaldamage.png')]
	  public static var PhysicalDamage:Class;
	  
	  [Embed(source='c:\\projects\\flash\\bankgame\\images\\sledgehammer.png')]
	  public static var SledgeHammer:Class;
	  
	  [Embed(source='c:\\projects\\flash\\bankgame\\images\\lockpick.png')]
	  public static var LockPickSet:Class;

	  [Embed(source='c:\\projects\\flash\\bankgame\\images\\acid.png')]
	  public static var NitricAcid:Class;

	  [Embed(source='c:\\projects\\flash\\bankgame\\images\\prybar.png')]
	  public static var PryBar:Class;
	  
	  [Embed(source='c:\\projects\\flash\\bankgame\\images\\drill.png')]
	  public static var Drill:Class;

	  [Embed(source='c:\\projects\\flash\\bankgame\\images\\dynamite.png')]
	  public static var Dynamite:Class;

	  [Embed(source='c:\\projects\\flash\\bankgame\\images\\dryice.png')]
	  public static var DryIce:Class;

	  [Embed(source='c:\\projects\\flash\\bankgame\\images\\scope.png')]
	  public static var Scope:Class;

	  [Embed(source='c:\\projects\\flash\\bankgame\\images\\nitrogen.png')]
	  public static var Nitrogen:Class;
	  
	  [Embed(source='c:\\projects\\flash\\bankgame\\images\\liquiddynamite.png')]
	  public static var LiquidDynamite:Class;

	  [Embed(source='c:\\projects\\flash\\bankgame\\images\\electronicsurge.png')]
	  public static var ElectronicSurge:Class;

	  [Embed(source='c:\\projects\\flash\\bankgame\\images\\timer.png')]
	  public static var TimeCracker:Class;	  

	  [Embed(source='c:\\projects\\flash\\bankgame\\images\\torch.png')]
	  public static var Torch:Class;	  	  

	  [Embed(source='c:\\projects\\flash\\bankgame\\images\\pistol.png')]
	  public static var Pistol:Class;	  	
	  
	  [Embed(source='c:\\projects\\flash\\bankgame\\images\\flamethrower.png')]
	  public static var FlameThrower:Class;	  		  

	  public function EmbedAssets() {		}
	  
	  public static function getImage(index:int):DisplayObject
	  {
		switch(index)
		{
			 case GameImages.GUNRIGHT: return  new EmbedAssets.GunRight();
			 case GameImages.GUNLEFT: return  new EmbedAssets.GunLeft();
			 case GameImages.SAFE1: return  new EmbedAssets.Safe1();
			 case GameImages.SAFE2: return  new EmbedAssets.Safe2();
			 case GameImages.SAFE2OPENED: return  new EmbedAssets.Safe2Opened();
			 case GameImages.SAFE3: return  new EmbedAssets.Safe3();
			 case GameImages.SAFE3OPENED: return  new EmbedAssets.Safe3Opened();
			 case GameImages.PHYSICALDAMAGE: return  new EmbedAssets.PhysicalDamage();
			 case GameImages.ELECTRICALDAMAGE: return  new EmbedAssets.ElectricDamage();
			 case GameImages.LOCKPICKDAMAGE: return  new EmbedAssets.LockPickDamage();
			 case GameImages.SLEDGEHAMMER: return  new EmbedAssets.SledgeHammer();
			 case GameImages.LOCKPICKSET: return  new EmbedAssets.LockPickSet();
			 case GameImages.NITRICACID: return new EmbedAssets.NitricAcid();
			 case GameImages.PRYBAR: return new EmbedAssets.PryBar();
			 case GameImages.DRILL:return new EmbedAssets.Drill();
			 case GameImages.DYNAMITE:return new EmbedAssets.Dynamite();
			 case GameImages.DRYICE:return new EmbedAssets.DryIce();
			 case GameImages.SCOPE:return new EmbedAssets.Scope();
			 case GameImages.NITROGEN:return new EmbedAssets.Nitrogen();
			 case GameImages.LIQUIDDYNAMITE: return new EmbedAssets.LiquidDynamite(); 
			 case GameImages.ELECTRONICSURGE: return new EmbedAssets.ElectronicSurge(); 
			 case GameImages.TIMERCRACKER: return new EmbedAssets.TimeCracker(); 
			 case GameImages.TORCH: return new EmbedAssets.Torch(); 
			 case GameImages.PISTOL: return new EmbedAssets.Pistol(); 
			 case GameImages.FLAMETHROWER: return new EmbedAssets.FlameThrower(); 
		}
		return null;
	  }
		
		
	
	}
	
	
	
}