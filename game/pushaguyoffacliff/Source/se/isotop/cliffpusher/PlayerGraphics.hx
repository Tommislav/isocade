package se.isotop.cliffpusher;
import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Image;
import se.isotop.cliffpusher.factories.GraphicsFactory;

/**
 * ...
 * @author Tommislav
 */
class PlayerGraphics extends Graphiclist
{
	var _gfxFactory:GraphicsFactory;
	private var _playerId:Int;
	private var _body:Image;
	private var _eyes:Image;
	private var _eyes2:Image;
	var _shield:Image;
	var _shade:Image;
	
	private static inline var SHIELD_X_R = 64;
	private static inline var SHIELD_X_L = -6;
	
	private static inline var EYES_X_R = 20;
	private static inline var EYES_X_L = 0;
	
	

	public function new(playerId:Int) 
	{
		super();
		
		_playerId = playerId;
		_gfxFactory = new GraphicsFactory();
		_body = new Image(_gfxFactory.getBody(_playerId), null, "body");
		
		_eyes = new Image(_gfxFactory.getEyes(), null, "eyes");
		_eyes2 = new Image(_gfxFactory.getClosedEyes(), null, "eyesClosed");
		_eyes2.visible = false;
		_shield = new Image(_gfxFactory.getShield(_playerId));
		_shield.relative = true;
		_shield.x = SHIELD_X_R;
		_shade = new Image(_gfxFactory.getShade());
		
		this.add(_body);
		//this.add(_shade);
		this.add(_eyes);
		this.add(_eyes2);
		this.add(_shield);
        setEyesAreOpen(true);
        setShowShied(false);
        setIsShooting(false);
        setIsWalking(false);
        setIsJumping(false);
		setDir(1);
	}
	
	public function setEyesAreOpen(open:Bool) {
		_eyes.visible = open;
		_eyes2.visible = !open;
	}
	
	public function setDir(dir:Int) {
		if (dir < 0) {
			_eyes.flipped = _eyes2.flipped = true;
			_eyes.x = _eyes2.x = EYES_X_L;
			
			_shield.x = SHIELD_X_L;
			_body.flipped = true;
		} else {
			_eyes.flipped = _eyes2.flipped = false;
			_eyes.x = _eyes2.x = EYES_X_R;
			_shield.x = SHIELD_X_R;
			_body.flipped = false;
		}
	}
	
	public function setShowShied(val:Bool) {
		_shield.visible = val;
	}
	
	public function setIsJumping(val:Bool) {
		
	}
	
	public function setIsShooting(val:Bool) {
		
	}
	
	public function setIsWalking(val:Bool) {
		
	}
	
}