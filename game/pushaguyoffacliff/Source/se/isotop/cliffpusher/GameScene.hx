package se.isotop.cliffpusher;
import com.haxepunk.HXP;
import com.haxepunk.Scene;
import flash.ui.Keyboard;
import se.salomonsson.icade.ICadeKeyboard;
import se.salomonsson.icade.IReadInput;

/**
 * ...
 * @author Tommislav
 */
class GameScene extends Scene
{
	private var _networkHandler:NetworkGameLogic;
	
	
	public function new() 
	{
		super();
	}
	
	override public function begin() 
	{
		var keyboard = new ICadeKeyboard();
		keyboard.setDebugToggleKey(Keyboard.SPACE);
		
		_networkHandler = new NetworkGameLogic();
		add(_networkHandler);
		
		
		var factory = new GraphicsFactory();
		
		//add(new Level(factory));
		for (i in 0...60) {
			add(new Block(factory, Math.random() * 1024 - 32, Math.random() * 768 - 32));
		}
		
		// Player is added by networkGameLogic on connection
		
		//add(new Player(-1, HXP.halfWidth, HXP.halfHeight, keyboard, 0xffff0000));
		//add(new Player(10, 10, keyboard, factory, 0xff0000ff));
		//add(new Player(100, 60, keyboard, factory, 0xff00ff00));
	}
	
}