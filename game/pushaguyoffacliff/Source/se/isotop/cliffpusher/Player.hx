package se.isotop.cliffpusher;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import se.salomonsson.icade.ICadeKeyCode;
import se.salomonsson.icade.IReadInput;

/**
 * ...
 * @author Tommislav
 */
class Player extends Entity
{
	private var _keyInput:IReadInput;

	public function new(x:Float, y:Float, keyInput:IReadInput) 
	{
		super(x, y);
		_keyInput = keyInput;
		
		graphic = Image.createRect(32, 32, 0xff0000);
		setHitbox(32, 32);
		type = "player";
	}
	
	override public function update():Void 
	{
		var deg = _keyInput.getDegrees();
		if (deg != -1) {
			var spd = 2.0;
			var rad = deg / 180 * Math.PI;
			var vX = Math.cos(rad) * spd;
			var vY = Math.sin(rad) * spd;
			moveBy(vX, vY);
		}
		
		
		super.update();
	}
	
}