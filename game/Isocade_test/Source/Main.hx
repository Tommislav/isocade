package;


import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.KeyboardEvent;
import flash.ui.Keyboard;
import flash.Lib;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import openfl.Assets;
import se.salomonsson.icade.ICadeKeyboard;
import se.salomonsson.icade.ICadeKeyCode;


class Main extends Sprite {
	
	private var _tf:TextField;
	private var _arrow:Sprite;
	private var _stageScale:Float;
	private var _keyListener:ICadeKeyboard;
	
	public function new () {
		
		super ();
		setScale(1);
		
		// create bitmap, add and center in holder for easy rotation
		var bmp = new Bitmap(Assets.getBitmapData("assets/arrow.png"));
		bmp.x = -bmp.width / 2;
		bmp.y = -bmp.height / 2;
		
		_arrow = new Sprite();
		_arrow.x = 200;
		_arrow.y = 200;
		_arrow.addChild(bmp);
		addChild(_arrow);
		
		
		
		
		
		_tf = new TextField();
		_tf.text = "Press a key\nF2 toggles mode";
		_tf.autoSize = TextFieldAutoSize.LEFT;
		_tf.defaultTextFormat = new TextFormat("arial", 24);
		addChild(_tf);
		
		_keyListener = new ICadeKeyboard();
		_keyListener.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		_keyListener.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
	}
	
	
	public function setScale(scale:Float) {
		//_stageScale = scale;
		//stageWidth = Lib.current.stage.stageWidth * scale;
		//stageHeight = Lib.current.stage.stageHeight * scale;
		
		Lib.current.scaleX = Lib.current.scaleY = scale;
	}
	
	
	function rotateArrowToDegrees(degrees:Float) 
	{
		if (degrees < 0) 
			return; // -1 == no rotation
		
		_arrow.rotation = degrees;
	}
	
	private function onKeyDown(e:KeyboardEvent):Void 
	{
		rotateArrowToDegrees(_keyListener.getDegrees());
		
		var mode = _keyListener.getKeyboardMode() ? "(Keyboard mode) " : "(ICade mode) ";
		_tf.text = mode + "button press:" + ICadeKeyCode.getKeyLabel(e.keyCode);
	}
	
	private function onKeyUp(e:KeyboardEvent):Void 
	{
		rotateArrowToDegrees(_keyListener.getDegrees());
		
		var mode = _keyListener.getKeyboardMode() ? "(Keyboard mode) " : "(ICade mode) ";
		_tf.text = mode + "button release:" + ICadeKeyCode.getKeyLabel(e.keyCode);
		
		if (e.keyCode == Keyboard.F2) {
			toggleKeyboardICadeMode();
		}
	}
	
	
	function toggleKeyboardICadeMode() 
	{
		var isKeyboardMode = _keyListener.getKeyboardMode();
		isKeyboardMode = !isKeyboardMode;
		_keyListener.setKeyboardMode(isKeyboardMode);
		if(isKeyboardMode) {
			_tf.text = "WASD MODE";
		} else {
			_tf.text = "ICADE MODE";
		}
	}
}