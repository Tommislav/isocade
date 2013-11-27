package;


import flash.display.Sprite;
import flash.events.KeyboardEvent;
import flash.Lib;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;


class Main extends Sprite {
	
	private var _tf:TextField;
	private var _stageScale:Float;
	
	
	public function new () {
		
		super ();
		
		
		
		_tf = new TextField();
		_tf.text = "";
		_tf.autoSize = TextFieldAutoSize.LEFT;
		_tf.defaultTextFormat = new TextFormat("arial", 24);
		addChild(_tf);
		
		setScale(2);
		
		//stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		//stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		
		var k = new ICadeKeyboard();
		k.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		k.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
	}
	
	
	public function setScale(scale:Float) {
		//_stageScale = scale;
		//stageWidth = Lib.current.stage.stageWidth * scale;
		//stageHeight = Lib.current.stage.stageHeight * scale;
		
		Lib.current.scaleX = Lib.current.scaleY = scale;
	}
	
	
	private function onKeyDown(e:KeyboardEvent):Void 
	{
		_tf.text += "KEY DOWN: " + e.keyCode + "\n";
	}
	
	private function onKeyUp(e:KeyboardEvent):Void 
	{
		_tf.text += "Key Up " + e.keyCode + "\n";
	}
	
}