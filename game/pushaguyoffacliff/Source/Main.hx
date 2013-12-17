package;


import com.haxepunk.Engine;
import com.haxepunk.HXP;
import flash.display.Sprite;
import flash.Lib;
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
		setScale(1);
		HXP.scene = new GameScene();	
	}
	
	public function setScale(scale:Float) {
		//_stageScale = scale;
		//stageWidth = Lib.current.stage.stageWidth * scale;
		//stageHeight = Lib.current.stage.stageHeight * scale;
		
		Lib.current.scaleX = Lib.current.scaleY = scale;
	}
}