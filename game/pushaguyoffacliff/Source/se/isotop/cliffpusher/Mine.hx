package se.isotop.cliffpusher;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Animation;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.graphics.Tilemap;
import com.haxepunk.HXP;
import flash.display.Bitmap;
import openfl.Assets;
import se.isotop.haxepunk.Eventity;

/**
 * ...
 * @author Tommislav
 */
class Mine extends Entity
{

	public var _animation:Spritemap; // ???
	public var _animationTile:Tilemap;
	
	public function new(x:Float, y:Float) 
	{
		super( x, y );
		
		_animation = new Spritemap("assets/mine_sheet.png", 50, 45);
		_animation.add("", [0, 1, 2, 1], 5, true);
		_animation.play();
		
		graphic = _animation;
	}
	
	override public function update():Void 
	{
		_animation.update();
		super.update();
	}
	
}