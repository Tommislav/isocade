package se.isotop.cliffpusher;
import com.haxepunk.HXP;
import com.haxepunk.Scene;
import flash.ui.Keyboard;
import se.salomonsson.icade.ICadeKeyboard;

/**
 * ...
 * @author Tommislav
 */
class GameScene extends Scene
{

	public function new() 
	{
		super();
	}
	
	override public function begin() 
	{
		var keyboard = new ICadeKeyboard();
		keyboard.setDebugToggleKey(Keyboard.SPACE);
		
		add(new Player(HXP.halfWidth, HXP.halfHeight, keyboard));
	}
	
}