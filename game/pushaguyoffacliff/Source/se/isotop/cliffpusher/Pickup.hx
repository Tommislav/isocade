package se.isotop.cliffpusher;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Emitter;
import com.haxepunk.graphics.Image;
import se.isotop.cliffpusher.enums.ExtraWeaponType;
import se.isotop.cliffpusher.enums.SoundId;
import se.isotop.cliffpusher.events.ExtraWeaponEvent;
import se.isotop.cliffpusher.events.SoundEvent;
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
	private var _emitter:Emitter;
	private var _gfx:Image;
	private var _emitCount:Int;
	
	public function new() 
	{
		super();
		_gfx = new Image(GraphicsFactory.instance.getPickupRegion());
		this.graphic = _gfx;
		setHitbox(32, 32);
		this.type = NAME;
	}
	
	override public function update():Void 
	{
		super.update();
		
		
		if (_emitCount > 0) {
			_emitCount--;
			_emitter.emitInCircle("one", 16, 16, 64);
			
			if (_emitCount <= 0) {
				this.graphic = _gfx;
				visible = false;
			}
			return;
		}
		
		if (visible) {
			var coll = this.collide(Player.NAME, this.x, this.y);
			if (coll != null) {
				var pl = cast(coll, Player);
				var newType:ExtraWeaponType = ExtraWeaponType.POWER_JUMP; // make random
				var numberOfWpns = 10;
				
				pl.setExtraWeapon(pl.id, newType, numberOfWpns);
				dispatchEvent(new SoundEvent(SoundEvent.PLAY_SOUND, SoundId.SND_PICKUP_GET));
				
				_emitCount = 60;
				_visCount = 1000;
				
				emit();
			}
		} else if (--_visCount <= 0) {
			visible = true;
			graphic = _gfx;
		}
		
	}
	
	function emit() 
	{
		_emitter = new Emitter(GraphicsFactory.instance.getExplosionSheetRegion(), 64, 64);
		_emitter.newType("one", [3]);
		_emitter.setMotion("one", 90, 5, 0.8, 10, 20);
		graphic = _emitter;
	}
}