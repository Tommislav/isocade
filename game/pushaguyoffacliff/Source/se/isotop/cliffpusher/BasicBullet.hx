package se.isotop.cliffpusher;
import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.graphics.Emitter;
import com.haxepunk.graphics.Image;
import com.haxepunk.Mask;
import openfl.Assets;

/**
 * ...
 * @author Tommislav
 */
class BasicBullet extends Entity implements IBullet
{
	private var _playerId:Int;
	private var _dir:Int;
	
	private var _speedX:Float;
	private var _speedY:Float;
	private var _minX:Float;
	private var _maxX:Float;
	private var _life:Int;
	
	private var _emitter:Emitter;
	private var _explosionCounter:Int;
	
	public function new(playerId:Int, x:Float=0, y:Float=0, dir:Int, level:Level, graphic:Graphic=null, mask:Mask=null) 
	{
		var width = 32;
		var height = 14;
		
		super(x, y, graphic, mask);
		this.graphic = Image.createRect(width, height, 0xff0000);
		this.setHitbox(width, height);
		
		_playerId = playerId;
		_dir = dir;
		_life = 40;
		_speedX = 10 * dir;
		_speedY = (Math.random() * 2) - 1;
		
		_minX = -32;
		_maxX = level.levelWidthPx;
		
		this.x = x-halfWidth;
		this.y = y-halfHeight;
		
		this.type = "bullet";
	}
	
	override public function update():Void 
	{
		this.x += _speedX;
		this.y += _speedY;
		
		if (x < _minX || x > _maxX || --_life <= 0) {
			scene.remove(this);
		}
		
		if (_emitter != null) {
			_emitter.emitInCircle("one", this.x, this.y, 32);
		}
		
		if (--_life <= 0 && --_explosionCounter <= 0) {
			scene.remove(this);
		}
		
		super.update();
	}
	
	/* INTERFACE se.isotop.cliffpusher.IBullet */
	
	public function getPlayerId():Int 
	{
		return _playerId;
	}
	
	public function destroy(withExplosion:Bool=false):Void 
	{
		_speedX = 0;
		_speedY = 0;
		this.collidable = false;
		
		if (withExplosion) {
			_life = 0;
			_explosionCounter = 5;
			_emitter = new Emitter(Assets.getBitmapData("assets/explosion.png"), 64, 64);
			_emitter.newType("one", [0,1,2,3]);
			this.graphic = _emitter;
			
		} else {
			scene.remove(this);
		}
	}
	
	public function getDamage():Float 
	{
		return 1;
	}
	
	public function getDir():Int 
	{
		return _dir;
	}
	
}