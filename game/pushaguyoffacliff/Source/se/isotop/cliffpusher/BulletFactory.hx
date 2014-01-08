package se.isotop.cliffpusher;

import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.graphics.Image;
import com.haxepunk.Mask;

/**
 * ...
 * @author Tommislav
 */
class BulletFactory extends Entity
{
	public static inline var NAME:String = "BulletFactory";
	
	private var _level:Level;
	
	public function new(x:Float=0, y:Float=0, graphic:Graphic=null, mask:Mask=null) 
	{
		super(x, y, graphic, mask);
		this.name = NAME;
	}
	
	// Will spawn a bullet and return your freeze-time in frames
	public function shoot(playerId:Int, bulletType:String, x:Float, y:Float, dir:Int):Int {
		
		if (_level == null) {
			_level = cast(scene.getInstance(Level.NAME), Level);
		}
		
		var bullet:Entity = new BasicBullet(playerId, x, y, dir, _level );
		scene.add(bullet);
		
		return 4;
	}
	
}