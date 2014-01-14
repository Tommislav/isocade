package se.isotop.cliffpusher;
import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.graphics.atlas.AtlasData;
import com.haxepunk.graphics.Emitter;
import com.haxepunk.graphics.Image;
import com.haxepunk.Mask;
import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;
import openfl.Assets;

/**
 * ...
 * @author Tommislav
 */
class BasicBullet extends Entity implements IBullet
{
	private var _playerId:Int;
	private var _angle:Float;
	private var _dir:Int;
	
	private var _speedX:Float;
	private var _speedY:Float;
	private var _minX:Float;
	private var _maxX:Float;
	private var _life:Int;
	
	private var _emitter:Emitter;
	private var _explosionCounter:Int;
	
	public function new(playerId:Int, x:Float=0, y:Float=0, angle:Float, level:Level, graphic:Graphic=null, mask:Mask=null) 
	{
		var width = 32;
		var height = 14;
		var halfW:Int = 16;
		var halfH:Int = 7;
		
		super(x, y, graphic, mask);
		var img:Image = Image.createRect(width, height, 0xff0000);
		img.originX = halfW;
		img.originY = halfH;
		//img.centerOO();
		this.graphic = img;
		
		
		_playerId = playerId;
		_life = 30;
		
		angle += Math.random() * 12 - 6;
		_angle = angle * Math.PI / 180;
		img.angle = -angle;
		
		
		var speed = 10;
		
		var sX = Math.cos(_angle);
		var sY = Math.sin(_angle);
		
		this.x = halfW + sX * 20;
		this.y = halfH + sY * 20;
		
		_speedX = sX * speed;
		_speedY = sY * speed;
		
		_dir = (_speedX > 0) ? 1 : -1;
		
		if ((Math.abs(_speedX) > Math.abs(_speedY))) { // horizontal
			setHitbox(width, height, halfW, halfH);
		} else {
			setHitbox(height, width);
		}
		
		
		
		_minX = -32;
		_maxX = level.levelWidthPx;
		
		this.x = x;
		this.y = y;
		
		this.type = "bullet";
	}
	
	override public function update():Void 
	{
		this.x += _speedX;
		this.y += _speedY;
		
		if (x < _minX || x > _maxX) {
			scene.remove(this);
		}
		
		if (_emitter != null) {
			_emitter.emitInCircle("one", 16, 4, 16);
		}
		
		_life--;
		_explosionCounter--;
		if (_life <= 0 && _explosionCounter <= 0) {
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
		
		withExplosion = true;
		
		if (withExplosion) {
			_life = -1;
			_explosionCounter = 8;
			
			_emitter = new Emitter(GraphicsFactory.instance.getExplosionSheetRegion(), 64, 64);
			_emitter.newType("one", [0, 1, 2, 3]);
			_emitter.setMotion("one", 0, 1, 0.2);
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