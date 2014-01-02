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

/**
 * ...
 * @author Tommislav
 */
class Player extends Entity
{
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
	private var _freezeInteractionCnt:Int;
	
	public var id:Int = -1;
	public var keyInput:IReadInput;
	public var vX:Float = 0.0;
	public var vY:Float = 0.0;
	
	private var _pushForceX:Float = 0.0;

	public function new(id:Int, x:Float, y:Float, keyInput:IReadInput, color:Int) 
	{
		super(x, y);
		this.id = id;
		this.keyInput = keyInput;
		
		_gfxFactory = new GraphicsFactory();
		_gfx = new Graphiclist();
		
		//_gfx.add(Image.createRect(32, 64, color, 0.5));
		//_gfx.add(new Image(_gfxFactory.getShade()));
		//_gfx.add(new Image(_gfxFactory.getEyes()));
		//graphic = _gfx;
		graphic = Image.createRect(32, 64, color);
		
		
		setHitbox(32, 64);
		type = "player";
	}
	
	
	override public function update():Void 
	{
		if (this.y > 1024)
			this.y = -256;
		
		var mX = 0.0;
		var mY = 0.0;
		
		_onGround = collide("solid", x, y + 1) != null;
		
		
		
		if (_onGround && _jumping)
			_jumping = false;
		
		var deg = this.keyInput.getDegrees();
		if (deg != -1) {
			var spd = 4.0;
			var rad = deg / 180 * Math.PI;
			mX = Math.cos(rad) * spd;
			
			if (mX < 0)
				_dir = -1;
			else if (mX > 0)
				_dir = 1;
		}
		
		
		if (_jumping && collide("solid", x, y - 1) != null) { // hitting head
			//vY = 0;
			_jumpCnt = 99;
		}
		
		if (this.keyInput.getKeyIsDown(ICadeKeyCode.BUTTON_A)) {
			if (_onGround) {
				_onGround = false;
				_jumping = true;
			}
			
			if (_jumping && ++_jumpCnt < 15) {
				vY = -_jumpStr;
			}
		} else {
			// release button while standing on ground
			if (_onGround) {
				vY = 0;
				_jumpCnt = 0;
			}
		}
		
		if (!_onGround)
			vY += _gravity;
		
		
		if (_freezeInteractionCnt <= 0) {
			if (this.keyInput.getKeyIsDown(ICadeKeyCode.BUTTON_B)) { // shooting?
				_freezeInteractionCnt = 60;
				
				var spawnType = "push";
				var xPos = this.x + 34 * _dir;
				var yPos = this.y + 10;
				
				var logic:NetworkGameLogic = cast (scene.getInstance("GameLogic"), NetworkGameLogic);
				logic.spawnPushEntity(xPos, yPos, _dir, this.id);
			}
		} else {
			_freezeInteractionCnt--;
		}
		
		
		if (checkForPushCollision(x+vX+mX, y+vY+mY)) {
			mX = mY = 0;
		}
		
		
		// Add push force to movement x
		mX += _pushForceX;
		_pushForceX *= 0.9;
		//if (_pushForceX < 0.01 && _pushForceX > -0.01) { _pushForceX = 0; }
		
		
		vY = Math.min(_maxFall, vY);
		
		moveBy(vX + mX, vY + mY, "solid");
		HXP.setCamera(this.x - HXP.halfWidth, this.y - HXP.halfHeight);
		super.update();
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
}