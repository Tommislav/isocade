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
import se.isotop.cliffpusher.enums.BulletType;
import se.isotop.cliffpusher.enums.ExtraWeaponType;
import se.isotop.cliffpusher.enums.SoundId;
import se.isotop.cliffpusher.events.ExtraWeaponEvent;
import se.isotop.cliffpusher.events.ShootBulletEvent;
import se.isotop.cliffpusher.events.SoundEvent;
import se.isotop.cliffpusher.factories.GraphicsFactory;
import se.isotop.haxepunk.Eventity;
import se.salomonsson.icade.ICadeKeyCode;
import se.salomonsson.icade.IReadInput;
import se.salomonsson.icade.ISerializeableReadInput;

/**
 * ...
 * @author Tommislav
 */
class Player extends Eventity
{
	public static inline var NAME = "player";
	
	
	
	private static inline var SHOOT_BUTTON = ICadeKeyCode.BUTTON_1;
	private static inline var SHIELD_BUTTON = ICadeKeyCode.BUTTON_B;
	private static inline var JUMP_BUTTON = ICadeKeyCode.BUTTON_A;
	//private static inline var EXTRA_BUTTON = ICadeKeyCode.BUTTON_1;
	
	private var _bulletCount:Int;
	
	private var _colorId:Int;
	
	private var _isItMe:Bool;
	
	private var _dir:Int = 1;
	private var _defaultJumpStr:Float = 12;
	private var _jumpStr:Float = 12;
	private var _maxFall:Float = 16;
	private var _gravity:Float = 1;
	private var _jumping:Bool;
	private var _onGround:Bool;
	private var _shielding:Bool;
	private var _shooting:Bool;
	
	private var _playerColor:Int;
	private var _gfxFactory:GraphicsFactory;
	private var _canJump:Bool;
	private var _jumpCnt:Int;
	private var _freezeInteractionCnt:Int = 0;
	
	private var _currentBulletType:BulletType;
	private var _extraWeaponType:ExtraWeaponType;
	private var _shootDelay:Int;
	private var _shieldDelay:Int;
	private var _extraWeaponDelay:Int;
	private var _screenShakeCounter:Int;
	private var _screenShakeStr:Int = 2;
	
	private var _closedEyesCounter:Int;
	
	public var id:Int = -1;
	public var keyInput:ISerializeableReadInput;
	public var vX:Float = 0.0;
	public var vY:Float = 0.0;
	
	private var _pushForceX:Float = 0.0;
	
	private var _playerGfx:PlayerGraphics;
	private var _ld:Level;
	
	private var _startX:Float;
	private var _startY:Float;
	
	public var score:Int;
	private var _scoreCnt:Int;
	
	private var _powerupStartTime:Int;
	private var _powerupEndTime:Int;

	public function new(id:Int, color:Int, x:Float, y:Float, keyInput:ISerializeableReadInput, isItMe:Bool) 
	{
		super(x, y);
		this.id = id;
		this.keyInput = keyInput;
		_colorId = color;
		_isItMe = isItMe;
		_startX = x;
		_startY = y;
		
		_extraWeaponType = ExtraWeaponType.NONE;
		_currentBulletType = BulletType.DEFAULT;
		this.visible = true;
		
		_playerGfx = new PlayerGraphics(_colorId);
		graphic = _playerGfx;
		
		this.score = 0;
		
		setHitbox(32, 64);
		type = NAME;
		
	}
	
	
	override public function update():Void 
	{
		if (_ld == null) {
			_ld = cast(scene.getInstance(Level.NAME), Level);
		}
		
		if (this.y > _ld.levelHeightPx + 518) {
			this.score = 0;
			this.x = _startX;
			this.y = _startY;
			if (_isItMe) {
				
				dispatchEvent(new SoundEvent(SoundEvent.PLAY_SOUND, SoundId.SND_DIE));
				if (_extraWeaponType != ExtraWeaponType.NONE) {
					dispatchEvent(new ExtraWeaponEvent(ExtraWeaponEvent.CHANGE, this, ExtraWeaponType.NONE, 0, -1));
					_extraWeaponType = ExtraWeaponType.NONE;
				}
				
				
			}
			
		}
		
		var mX = 0.0;
		var mY = 0.0;
		
		if (--_closedEyesCounter == 0) {
			_playerGfx.setEyesAreOpen(true);
		}
		
		_freezeInteractionCnt--;
		var freezeInteraction = (_freezeInteractionCnt > 0);
		
		_onGround = collide("solid", x, y + 1) != null;
		
		
		if (_onGround && _jumping) {
			_jumping = false;
		}
		
		var deg = this.keyInput.getDegrees();
		if (deg != -1) {
			var spd = 4.0;
			var rad = deg / 180 * Math.PI;
			mX = Math.cos(rad) * spd;
			
			if (mX < -0.2) {
				_dir = -1;
			}
			else if (mX > 0.2) {
				_dir = 1;
			}
			
			_playerGfx.setDir(_dir);
		}
		
		
		if (_jumping && collide("solid", x, y - 1) != null) { // hitting head
			//vY = 0;
			_jumpCnt = 99;
		}
		
		
		if (this.y < _ld.scoreAboveYPx) {
			checkForAdditionalScore();
		}
		
		// Jump (Button A)
		if (this.keyInput.getKeyIsDown(JUMP_BUTTON) && !freezeInteraction) {
			if (_onGround) {
				_onGround = false;
				_jumping = true;
				dispatchEvent(new SoundEvent(SoundEvent.PLAY_SOUND, (_isItMe ? SoundId.SND_JUMP_ME : SoundId.SND_JUMP_THEM)));
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
		if (this.keyInput.getKeyIsDown(SHOOT_BUTTON)) {
			
			_bulletCount--;
			
			if (--_shootDelay <= 0) {
			
				if (_bulletCount > 0) {
					var bulletAngle = _dir > 0 ? 0 : 180;
					
					if (keyInput.getKeyIsDown(ICadeKeyCode.UP))
						bulletAngle = 270; // up
					
					dispatchEvent(new ShootBulletEvent(ShootBulletEvent.SHOOT_BULLET, this.id, _currentBulletType, centerX, centerY, bulletAngle));
					_shootDelay = 4;
					_shieldDelay = 18;
					_shooting = true;
				}
			}
		}
		
		if (!this.keyInput.getKeyIsDown(SHOOT_BUTTON)) { 
			_shooting = false;
			_bulletCount = 55; 
		}
		
		// Shield (Button C)
		if (this.keyInput.getKeyIsDown(SHIELD_BUTTON) && --_shieldDelay <= 0) { // shield
			_shielding = true;
		} else {
			_shielding = false;
		}
		
		updateExtraWeaponStatus();
		
		var isInvincible:Bool = _extraWeaponType == ExtraWeaponType.INVINCIBLE;
		
		if (isInvincible) {
			this.visible = !this.visible;
		}
		
		if (!isInvincible) {
			if (checkForBulletCollision(x+vX+mX, y+vY+mY)) {
				mX = mY = 0;
			}
		}
		
		
		
		
		// Add push force to movement x
		mX += _pushForceX;
		_pushForceX *= 0.9;
		if (_pushForceX < 0.01 && _pushForceX > -0.01) { _pushForceX = 0; }
		
		
		vY = Math.min(_maxFall, vY);
		vX *= 0.9;
		if (vX < 0.1 && (mX != 0)) vX = 0;
		
		
		
		var freeze = _freezeInteractionCnt > 0;
		moveBy(vX + mX, vY + mY, "solid");
		
		
		if (_isItMe) 
			moveCamera();
		
		
		// update graphics
		_playerGfx.setIsJumping(_jumping);
		_playerGfx.setShowShied(_shielding);
		_playerGfx.setIsShooting(_shooting);
		_playerGfx.setShowShied(_shielding);
		
		super.update();
	}
	
	/* INTERFACE se.isotop.cliffpusher.ISetExtraWeaponType */
	
	public function setExtraWeapon(playerId:Int, type:ExtraWeaponType, num:Int) 
	{
		if (_isItMe) {
			trace("Set extra weapon on player with id: " + playerId + ", my id is: " + this.id );
			if (playerId == this.id) {
				dispatchEvent(new ExtraWeaponEvent( ExtraWeaponEvent.CHANGE, this, type, 0, num));
				_extraWeaponType = type;
				
				// Back to defaults first!
				_jumpStr = _defaultJumpStr;
				_currentBulletType = BulletType.DEFAULT;
				
				if (type != ExtraWeaponType.NONE) {
					_powerupStartTime = Lib.getTimer();
					_powerupEndTime = _powerupStartTime + (num * 1000);
				}
				
				switch (_extraWeaponType) {
					case ExtraWeaponType.POWER_JUMP:
						_jumpStr = _defaultJumpStr + 6;
					case ExtraWeaponType.LONGER_SHOTS:
						_currentBulletType = BulletType.LONGER_SHOT;
					
					default:
						// do nothing
				}
			}
		}
	}
	
	function updateExtraWeaponStatus() {
		if (_extraWeaponType != ExtraWeaponType.NONE) {
			var now = Lib.getTimer();
			var time:Int = Math.round((_powerupEndTime - (now)) / 1000);
			dispatchEvent(new ExtraWeaponEvent(ExtraWeaponEvent.NUM_CHANGE, this, _extraWeaponType, 0, time));
			
			
			if (now >= _powerupEndTime) {
				setExtraWeapon(this.id, ExtraWeaponType.NONE, -1);
			}
		}
	}
	
	function checkForAdditionalScore() 
	{
		if (++_scoreCnt % 30 == 0) {
			this.score++;
			
			// Only top-most player gets score
			var players = new Array<Player>();
			this.scene.getClass(Player, players);
			var topPlayerId:Int = -1;
			var topY:Float = 999999;
			for (pl in players) {
				if (pl.y < topY) {
					topY = pl.y;
					topPlayerId = pl.id;
				}
			}
			
			if (topPlayerId == this.id) {
				this.score++;
			}
		}	
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
			
			if (_shielding && _dir != bullet.getDir()) {
				bullet.destroy(false);
				var pushBack = (2 * bullet.getDamage() * bullet.getDir());
				//this.x += pushBack;
				this.vX = pushBack;
				dispatchEvent(new SoundEvent(SoundEvent.PLAY_SOUND, SoundId.SND_HIT_SHIELD));
				return false;
			}
			
			this.vY = -6 * bullet.getDamage();
			this._pushForceX = 8 * bullet.getDir() * bullet.getDamage();
			_playerGfx.setEyesAreOpen(false);
			_closedEyesCounter = 60;
			dispatchEvent(new SoundEvent(SoundEvent.PLAY_SOUND, SoundId.SND_EXPLOSION));
			
			if (_screenShakeCounter < -8) {
				_screenShakeCounter = 5;
				_screenShakeStr = 18;
			}
			
			
			bullet.destroy(true);
			return true;
		}
		return false;
	}
}