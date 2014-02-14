package se.isotop.cliffpusher.bullets;
import com.haxepunk.Graphic;
import com.haxepunk.Mask;
import se.isotop.cliffpusher.Level;

/**
 * ...
 * @author Tommislav
 */
class LongLivedBullet extends BasicBullet
{

	public function new(playerId:Int, x:Float=0, y:Float=0, angle:Float, level:Level, graphic:Graphic=null, mask:Mask=null) 
	{
		super(playerId, x, y, angle, level, graphic, mask);
		setBulletLife(50);
	}
	
	override public function getBulletColor():Int {
		return 0xc00000;
	}
}