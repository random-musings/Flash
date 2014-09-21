//Code Credit: by http://www.emanueleferonato.com/2009/09/22/drawing-arcs-with-as3/
//draws the doors on all rooms in the game
//called by DrawObjects.as
package {
    import flash.display.Sprite;
    public class Arc extends Sprite {
        public static var deg_to_rad:Number=0.0174532925;
        public function Arc() {
            //addChild(my_canvas);
            //my_canvas.graphics.lineStyle(20,0xff0000,1);
            //draw_arc(my_canvas,250,200,150,14,180,1);
        }
		
		//draws the arcs on the room
		//this function is called from DrawObjects.DrawRoom()
        public static function draw(sprite:Sprite,
						center_x:Number,
						center_y:Number,
						radius:Number,
						angle_from:Number,
						angle_to:Number,
						precision:Number):Sprite {
						
			//this functiondraws the rounded door on every room
            var angle_diff:Number=angle_to-angle_from;
            var steps:int=Math.round(angle_diff*precision);
            var angle:Number=angle_from;
            var px:Number=center_x+radius*Math.cos(angle*deg_to_rad);
            var py:Number=center_y+radius*Math.sin(angle*deg_to_rad);
			
			//create a sprite  and navigate through the angles
            sprite.graphics.moveTo(px,py);
            for (var i:int=1; i<=steps; i++) {
                angle=angle_from+angle_diff/steps*i;
                sprite.graphics.lineTo(center_x+radius*Math.cos(angle*deg_to_rad),center_y+radius*Math.sin(angle*deg_to_rad));
            }
			return sprite;
        }
    }
}
