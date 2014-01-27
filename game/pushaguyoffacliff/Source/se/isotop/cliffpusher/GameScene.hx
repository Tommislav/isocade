package se.isotop.cliffpusher;
import com.haxepunk.HXP;
import com.haxepunk.Scene;
import flash.display.BitmapData;
import flash.ui.Keyboard;
import openfl.Assets;
import se.isotop.cliffpusher.factories.GraphicsFactory;
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
		var factory = new GraphicsFactory();
		
		#if (cpp)
			// On windows, use debug mode as default
			keyboard.setKeyboardMode(true);
			keyboard.setDebugToggleKey(Keyboard.SPACE);
		#end
		
		add(new BulletFactory());
		
		var ld:Level = new Level();
		add(ld);
		
		add(new WpnHUD());
		add(new ScoreHUD());
		
		_networkHandler = new NetworkGameLogic();
		add(_networkHandler);
	}
}