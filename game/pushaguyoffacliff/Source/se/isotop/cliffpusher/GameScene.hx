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

	public function new() 
	{
		super();
	}
	
	override public function begin() 
	{
		var keyboard = new ICadeKeyboard();
		keyboard.setDebugToggleKey(Keyboard.SPACE);
		
		var factory = new GraphicsFactory();
		
		//add(new Level(factory));
		for (i in 0...100) {
			add(new Block(factory, Math.random() * 1024 - 32, Math.random() * 768 - 32));
		}
		
		add(new Player(HXP.halfWidth, HXP.halfHeight, keyboard, factory, 0xffff0000));
		add(new Player(10, 10, keyboard, factory, 0xff0000ff));
		add(new Player(100, 60, keyboard, factory, 0xff00ff00));
	}
	
}