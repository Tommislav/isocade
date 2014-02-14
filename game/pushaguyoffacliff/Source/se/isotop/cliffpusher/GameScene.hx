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
		var factory = new GraphicsFactory();
		
		add(new SoundPlayer());
		add(new BulletFactory());

		var ld:Level = new Level();
		add(ld);

        add(new GameScore());
        add(new ScoreHUD());
		add(new WpnHUD());

		_networkHandler = new NetworkGameLogic();
		add(_networkHandler);
	}
}