package;


import com.haxepunk.Engine;
import com.haxepunk.HXP;
import flash.display.Sprite;
import se.isotop.cliffpusher.GameScene;


class Main extends Engine {
	
	
	public function new () {
		super ();
	}
	
	override public function init() 
	{
		#if debug
			HXP.console.enable();
		#end
		
		HXP.scene = new GameScene();	
	}
}