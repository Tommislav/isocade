package se.isotop.cliffpusher;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Image;
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
		
		_canJump = (collideTypes("solid", x, y+1) != null && _jumpCnt < 5);
		
		var deg = _keyInput.getDegrees();
		if (deg != -1) {
			var spd = 2.0;
			var rad = deg / 180 * Math.PI;
			mX = Math.cos(rad) * spd;
			//mY = Math.sin(rad) * spd;
		}
			
		if (_keyInput.getKeyIsDown(ICadeKeyCode.BUTTON_A)) {
			_jumpCnt++;
			if (_canJump) {
				vY -= 10;
			}
		} else {
			_jumpCnt = 0;
			vY += 1; // gravity
		}
		
		
		vY = Math.max(-8, Math.min(8, vY));
		
		
		moveBy(vX + mX, vY + mY, "solid");
		super.update();
	}
}