package;


import com.haxepunk.Engine;
import com.haxepunk.HXP;
import com.haxepunk.utils.Key;
import flash.display.Sprite;
import flash.Lib;
import flash.ui.Keyboard;
import openfl.display.DI;
import se.isotop.cliffpusher.GameScene;
import se.isotop.cliffpusher.screens.StartScreen;


class Main extends Engine {
	
	
	public function new () {
		super (768, 1024);
	}
	
	override public function init() 
	{
		#if debug
			HXP.console.enable();
			HXP.console.show();
			HXP.console.toggleKey = Keyboard.NUMBER_0;
		#end

		//HXP.scene = new GameScene();

        HXP.scene = new StartScreen();
	}
	
	public function setScale(scale:Float) {
		//_stageScale = scale;
		//stageWidth = Lib.current.stage.stageWidth * scale;
		//stageHeight = Lib.current.stage.stageHeight * scale;
		
		Lib.current.scaleX = Lib.current.scaleY = scale;
	}
}