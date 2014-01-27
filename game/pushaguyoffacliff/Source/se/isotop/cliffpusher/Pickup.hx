package se.isotop.cliffpusher;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import se.isotop.cliffpusher.enums.ExtraWeaponType;
import se.isotop.cliffpusher.events.ExtraWeaponEvent;
import se.isotop.cliffpusher.factories.GraphicsFactory;
import se.isotop.haxepunk.Eventity;

/**
 * ...
 * @author Tommislav
 */
class Pickup extends Eventity
{
	public static inline var NAME = "pickup";
	
	private var _visCount:Int;
	
	public function new() 
	{
		super();
		this.graphic = new Image(GraphicsFactory.instance.getPickupRegion());
		this.type = NAME;
	}
	
	override public function update():Void 
	{
		super.update();
		
		if (visible) {
			var coll = this.collide(Player.NAME, this.x, this.y);
			if (coll != null) {
				var pl = cast(coll, Player);
				visible = false;
				_visCount = 1000;
				var newType:ExtraWeaponType = ExtraWeaponType.MINE; // make random
				dispatchEvent(new ExtraWeaponEvent( ExtraWeaponEvent.CHANGE, pl, newType, 0, 3));
				//(cast(pl, Player)).setExtraWeapon(newType, 3);
			}
		} else if (--_visCount <= 0) {
			visible = true;
		}
		
	}
}