package se.isotop.cliffpusher;

import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.graphics.Image;
import com.haxepunk.Mask;
import se.isotop.cliffpusher.events.ShootBulletEvent;
import se.isotop.haxepunk.Eventity;

/**
 * ...
 * @author Tommislav
 */
class BulletFactory extends Eventity
{
	public static inline var NAME:String = "BulletFactory";
	
	private var _level:Level;
	
	public function new(x:Float=0, y:Float=0, graphic:Graphic=null, mask:Mask=null) 
	{
		super(x, y, graphic, mask);
		this.name = NAME;
		visible = false;
	}
	
	override public function added():Void 
	{
		super.added();
		addEventListener(ShootBulletEvent.SHOOT_BULLET, onShoot);
	}
	
	override public function removed():Void 
	{
		super.removed();
		removeEventListener(ShootBulletEvent.SHOOT_BULLET, onShoot);
	}
	
	private function onShoot(e:ShootBulletEvent):Void 
	{
		shoot(e.playerId, e.bulletType, e.centerX, e.centerY, e.angle);
	}
	
	
	// Will spawn a bullet and return your freeze-time in frames
	public function shoot(playerId:Int, bulletType:String, x:Float, y:Float, angle:Float):Int {
		
		if (_level == null) {
			_level = cast(scene.getInstance(Level.NAME), Level);
		}
		
		var bullet:BasicBullet = new BasicBullet(playerId, x, y, angle, _level );
		
		if (bulletType == "extra") {
			bullet.setBulletLife(50);
		}
		
		scene.add(bullet);
		
		return 4;
	}
	
}