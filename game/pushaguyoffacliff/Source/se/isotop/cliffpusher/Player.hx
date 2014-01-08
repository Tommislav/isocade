package se.isotop.cliffpusher;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.events.KeyboardEvent;
import flash.Lib;
import flash.ui.Keyboard;
import se.salomonsson.icade.ICadeKeyCode;
import se.salomonsson.icade.IReadInput;
import se.salomonsson.icade.ISerializeableReadInput;

/**
 * ...
 * @author Tommislav
 */
class Player extends Entity
{
	private static inline var SHIELD_X_R = 34;
	private static inline var SHIELD_X_L = -6;
	
	private static inline var SHOOT_BUTTON = ICadeKeyCode.BUTTON_A;
	private static inline var JUMP_BUTTON = ICadeKeyCode.BUTTON_B;
	private static inline var SHIELD_BUTTON = ICadeKeyCode.BUTTON_C;
	
	private var _isItMe:Bool;
	
	private var _dir:Int = 1;
	private var _jumpStr:Float = 12;
	private var _maxFall:Float = 16;
	private var _gravity:Float = 1;
	private var _jumping:Bool;
	private var _onGround:Bool;
	
	private var _playerColor:Int;
	private var _gfx:Graphiclist;
	private var _gfxFactory:GraphicsFactory;
	private var _canJump:Bool;
	private var _jumpCnt:Int;
	private var _freezeInteractionCnt:Int = 0;
	
	private var _bulletFactory:BulletFactory;
	private var _currentBulletType:String = "bullet";
	private var _shootDelay:Int;
	private var _shieldDelay:Int;
	private var _screenShakeCounter:Int;
	private var _screenShakeStr:Int = 2;
	
	private var _closedEyesCounter:Int;
	
	public var id:Int = -1;
	public var keyInput:ISerializeableReadInput;
	public var vX:Float = 0.0;
	public var vY:Float = 0.0;
	
	private var _pushForceX:Float = 0.0;
	
	private var _eyes:Image;
	private var _eyes2:Image;
	private var _shield:Image;
	private var _ld:Level;
	
	private var _startX:Float;
	private var _startY:Float;

	public function new(id:Int, x:Float, y:Float, keyInput:ISerializeableReadInput, isItMe:Bool) 
	{
		super(x, y);
		this.id = id;
		this.keyInput = keyInput;
		_isItMe = isItMe;
		_startX = x;
		_startY = y;
		
		_gfxFactory = new GraphicsFactory();
		_gfx = new Graphiclist();
		
		var body:Image = new Image(_gfxFactory.getBody(id));
		
		_eyes = new Image(_gfxFactory.getEyes(), null, "eyes");
		_eyes2 = new Image(_gfxFactory.getClosedEyes(), null, "eyesClosed");
		_eyes2.visible = false;
		_shield = new Image(_gfxFactory.getShield(id));
		_shield.relative = true;
		_shield.x = SHIELD_X_R;
		
		_gfx.add(body);
		_gfx.add(new Image(_gfxFactory.getShade()));
		_gfx.add(_eyes);
		_gfx.add(_eyes2);
		_gfx.add(_shield);
		graphic = _gfx;
		
		
		setHitbox(32, 64);
		type = "player";
	}
	
	
	override public function update():Void 
	{
		if (_ld == null) {
			_ld = cast(scene.getInstance(Level.NAME), Level);
		}
		
		if (_bulletFactory == null) {
			_bulletFactory = cast(scene.getInstance(BulletFactory.NAME) , BulletFactory);
		}
		
		if (this.y > _ld.levelHeightPx + 518) {
			this.x = _startX;
			this.y = _startY;
		}
		
		var mX = 0.0;
		var mY = 0.0;
		
		if (--_closedEyesCounter == 0) {
			_eyes.visible = true;
			_eyes2.visible = false;
		}
		
		_freezeInteractionCnt--;
		var freezeInteraction = (_freezeInteractionCnt > 0);
		
		_onGround = collide("solid", x, y + 1) != null;
		
		
		if (_onGround && _jumping)
			_jumping = false;
		
		var deg = this.keyInput.getDegrees();
		if (deg != -1) {
			var spd = 4.0;
			var rad = deg / 180 * Math.PI;
			mX = Math.cos(rad) * spd;
			
			if (mX < 0) {
				_eyes.flipped = _eyes2.flipped = true;
				_shield.x = SHIELD_X_L;
				_dir = -1;
			}
			else if (mX > 0) {
				_eyes.flipped = _eyes2.flipped = false;
				_shield.x = SHIELD_X_R;
				_dir = 1;
			}
		}
		
		
		if (_jumping && collide("solid", x, y - 1) != null) { // hitting head
			//vY = 0;
			_jumpCnt = 99;
		}
		
		// TODO: Add pickups - different weapons!!
		
		// Jump (Button A)
		if (this.keyInput.getKeyIsDown(JUMP_BUTTON) && !freezeInteraction) {
			if (_onGround) {
				_onGround = false;
				_jumping = true;
			}
			
			if (_jumping && ++_jumpCnt < 15) {
				vY = -_jumpStr;
			} 
		}
		
		if (_onGround) {
			vY = 0;
			_jumpCnt = 0;
		} else {
			vY += _gravity;
		}
		
		// Shoot (Button B)
		if (--_shootDelay <= 0) {
			if (this.keyInput.getKeyIsDown(SHOOT_BUTTON)) {
				_shootDelay = _bulletFactory.shoot(this.id, _currentBulletType, centerX + (20 * _dir), centerY - 6, _dir);
				_shieldDelay = 26;
			}
		}
		
		// Shield (Button C)
		if (this.keyInput.getKeyIsDown(SHIELD_BUTTON) && --_shieldDelay <= 0) { // shield
			_shield.visible = true;
		} else {
			_shield.visible = false;
		}
		
		
		if (checkForBulletCollision(x+vX+mX, y+vY+mY)) {
			mX = mY = 0;
		}
		
		
		
		// Add push force to movement x
		mX += _pushForceX;
		_pushForceX *= 0.9;
		if (_pushForceX < 0.01 && _pushForceX > -0.01) { _pushForceX = 0; }
		
		
		vY = Math.min(_maxFall, vY);
		
		
		
		var freeze = _freezeInteractionCnt > 0;
		moveBy(vX + mX, vY + mY, "solid");
		
		
		if (_isItMe) 
			moveCamera();
		
		super.update();
	}
	
	
	function moveCamera() 
	{
		var cX = this.x - HXP.halfWidth;
		var cY = this.y - HXP.halfHeight;
		cX = Math.max(-64, Math.min(_ld.levelWidthPx - 768 + 64, cX));
		cY = Math.max( -70, Math.min(_ld.levelHeightPx - 1024 + 128, cY));
		
		if (--_screenShakeCounter >= 0) {
			cX += Math.random() * _screenShakeStr * 2 - _screenShakeStr;
			cY += Math.random() * _screenShakeStr * 2 - _screenShakeStr;
		}
		
		HXP.setCamera(cX, cY);
	}
	
	function checkForBulletCollision(x, y) 
	{
		var coll = collide("bullet", x, y);
		if (coll != null) {
			var bullet:IBullet = cast(coll, IBullet);
			if (bullet.getPlayerId() == this.id) return false; // I'm not taking damage from my own pushes
			
			if (_shield.visible && _dir != bullet.getDir()) {
				bullet.destroy(true);
				return false;
			}
			
			this.vY = -6 * bullet.getDamage();
			this._pushForceX = 6 * bullet.getDir() * bullet.getDamage();
			_eyes.visible = false;
			_eyes2.visible = true;
			_closedEyesCounter = 60;
			
			if (_screenShakeCounter < -8) {
				_screenShakeCounter = 5;
				_screenShakeStr = 12;
			}
			
			
			bullet.destroy(true);
			return true;
		}
		return false;
	}
}