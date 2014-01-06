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
	
	public var id:Int = -1;
	public var keyInput:ISerializeableReadInput;
	public var vX:Float = 0.0;
	public var vY:Float = 0.0;
	
	private var _pushForceX:Float = 0.0;
	
	private var _eyes:Image;
	private var _eyes2:Image;
	private var _shield:Image;
	private var _ld:Level;

	public function new(id:Int, x:Float, y:Float, keyInput:ISerializeableReadInput, isItMe:Bool) 
	{
		super(x, y);
		this.id = id;
		this.keyInput = keyInput;
		_isItMe = isItMe;
		
		_gfxFactory = new GraphicsFactory();
		_gfx = new Graphiclist();
		
		var body:Image = new Image(_gfxFactory.getBody(id));
		
		_eyes = new Image(_gfxFactory.getEyes(), null, "eyes");
		_eyes2 = new Image(_gfxFactory.getClosedEyes(), null, "eyesClosed");
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
		
		if (this.y > _ld.levelHeightPx + 518)
			this.y = -256;
		
		var mX = 0.0;
		var mY = 0.0;
		
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
		
		
		// Jump (Button A)
		if (this.keyInput.getKeyIsDown(ICadeKeyCode.BUTTON_A) && !freezeInteraction) {
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
		if (!freezeInteraction) {
			if (this.keyInput.getKeyIsDown(ICadeKeyCode.BUTTON_B)) {
				_freezeInteractionCnt = 60;
				
				var spawnType = "push";
				var xPos = this.x + 34 * _dir;
				var yPos = this.y + 10;
				
				var logic:NetworkGameLogic = cast (scene.getInstance("GameLogic"), NetworkGameLogic);
				logic.spawnPushEntity(xPos, yPos, _dir, this.id);
			}
		}
		
		// Shield (Button C)
		if (this.keyInput.getKeyIsDown(ICadeKeyCode.BUTTON_C) && !freezeInteraction && _onGround) { // shield
			_shield.visible = true;
		} else {
			_shield.visible = false;
		}
		
		if (!_shield.visible) {
			if (checkForPushCollision(x+vX+mX, y+vY+mY)) {
				mX = mY = 0;
			}
		}
		
		
		// Add push force to movement x
		mX += _pushForceX;
		_pushForceX *= 0.9;
		if (_pushForceX < 0.01 && _pushForceX > -0.01) { _pushForceX = 0; }
		
		
		vY = Math.min(_maxFall, vY);
		
		
		
		var freeze = _freezeInteractionCnt > 0;
		_eyes.visible = !freeze;
		_eyes2.visible = freeze;
		
		
		moveBy(vX + mX, vY + mY, "solid");
		
		checkForPlayerCollision();
		
		if (_isItMe) 
			moveCamera();
		
		super.update();
	}
	
	
	function moveCamera() 
	{
		var cX = this.x - HXP.halfWidth;
		var cY = this.y - HXP.halfHeight;
		cX = Math.max(-64, Math.min(_ld.levelWidthPx - 768 + 64, cX));
		cY = Math.max(-70, Math.min(_ld.levelHeightPx - 1024 + 128, cY));
		HXP.setCamera(cX, cY);
	}
	
	function checkForPushCollision(x, y) 
	{
		var coll = collide("Push", x, y);
		if (coll != null) {
			var push:Push = cast(coll, Push);
			if (push.playerId == this.id) return false; // I'm not taking damage from my own pushes
			
			this.vY = -10;
			this._pushForceX = 10 * push.dir;
			return true;
		}
		return false;
	}
	
	
	
	function checkForPlayerCollision() 
	{
		var otherPlayer:Entity = collide("player", this.x, this.y);
		if (otherPlayer != null) {
			var collPl:Player = cast(otherPlayer, Player);
			if (this.y > collPl.y) { // He is above us and moving downward - he jumped on us!
				_freezeInteractionCnt = 120;
			}
			else if (this.y < collPl.y) { // We are above and moving downward - we jumped on him!
				this.vY = -18;
			}
		}
	}
}