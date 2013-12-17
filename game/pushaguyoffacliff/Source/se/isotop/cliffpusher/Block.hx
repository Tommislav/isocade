package se.isotop.cliffpusher;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;

/**
 * ...
 * @author Tommislav
 */
class Block extends Entity
{

	public function new(gfx:GraphicsFactory, x:Float, y:Float) 
	{
		super(x, y);
		type = "solid";
		this.setHitbox(32, 32, 0, 0);
		this.graphic = new Image(gfx.getGroundTile());
	}
	
}