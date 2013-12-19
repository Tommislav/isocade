package se.isotop.cliffpusher;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.Lib;
import se.salomonsson.icade.ICadeKeyCode;
import se.salomonsson.icade.IReadInput;

/**
 * ...
 * @author Tommislav
 */
class Player extends Entity
{
	private var _jumpStr:Float = 12;
	private var _maxFall:Float = 6;
	private var _gravity:Float = 1;
	private var _jumping:Bool;
	private var _onGround:Bool;
	
	private var _keyInput:IReadInput;
	private var _playerColor:Int;
	private var _gfx:Graphiclist;
	private var _gfxFactory:GraphicsFactory;
	private var _canJump:Bool;
	private var _jumpCnt:Int;
	
	public var vX:Float = 0.0;
	public var vY:Float = 0.0;
	

	public function new(x:Float, y:Float, keyInput:IReadInput, gfx:GraphicsFactory, color:Int) 
	{
		super(x, y);
		_keyInput = keyInput;
		_gfxFactory = gfx;
		
		_gfx = new Graphiclist();
		
		_gfx.add(Image.createRect(32, 64, color));
		_gfx.add(new Image(_gfxFactory.getShade()));
		_gfx.add(new Image(_gfxFactory.getEyes()));
		graphic = _gfx;
		
		
		setHitbox(32, 64);
		type = "player";
	}
	
	
	override public function update():Void 
	{
		var mX = 0.0;
		var mY = 0.0;
		
		_onGround = collide("solid", x, y + 1) != null;
		
		
		
		if (_onGround && _jumping)
			_jumping = false;
		
		var deg = _keyInput.getDegrees();
		if (deg != -1) {
			var spd = 4.0;
			var rad = deg / 180 * Math.PI;
			mX = Math.cos(rad) * spd;
			//mY = Math.sin(rad) * spd;
		}
		
		if (_jumping && collide("solid", x, y - 1) != null) { // hitting head
			//vY = 0;
			_jumpCnt = 99;
		}
		
		if (_keyInput.getKeyIsDown(ICadeKeyCode.BUTTON_A)) {
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
		
		
		
		
		
		//vY = Math.max(_maxFall, vY);
		
		moveBy(vX + mX, vY + mY, "solid");
		HXP.setCamera(this.x, this.y);
		super.update();
	}
}