package se.isotop.cliffpusher;
import com.haxepunk.HXP;
import com.haxepunk.Scene;
import flash.display.BitmapData;
import flash.ui.Keyboard;
import openfl.Assets;
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
		keyboard.setKeyboardMode(true);
		keyboard.setDebugToggleKey(Keyboard.SPACE);
		
		_networkHandler = new NetworkGameLogic();
		add(_networkHandler);
		
		
		var factory = new GraphicsFactory();
		
		//add(new Level(factory));
		var level:BitmapData = Assets.getBitmapData("assets/level0.png");
		for (y in 0...level.height) {
			for (x in 0...level.width) {
				if (level.getPixel(x, y) == 0) {
					add(new Block(factory, x*32, y*32));
				}
			}
		}
		
		// Player is added by networkGameLogic on connection
		
		//add(new Player(-1, HXP.halfWidth, HXP.halfHeight, keyboard, 0xffff0000));
		//add(new Player(10, 10, keyboard, factory, 0xff0000ff));
		//add(new Player(100, 60, keyboard, factory, 0xff00ff00));
	}
	
}