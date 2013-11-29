package;


import flash.display.Sprite;
import flash.events.KeyboardEvent;
import flash.ui.Keyboard;
import flash.Lib;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;


class Main extends Sprite {
	
	private var _tf:TextField;
	private var _stageScale:Float;
	private var _keyListener:ICadeKeyboard;
	
	public function new () {
		
		super ();
		
		
		
		_tf = new TextField();
		_tf.text = "Press a key\nF1 toggles mode\n" + Keyboard.W + ", " + Keyboard.A + ", " + Keyboard.S + ", " + Keyboard.D;
		_tf.autoSize = TextFieldAutoSize.LEFT;
		_tf.defaultTextFormat = new TextFormat("arial", 24);
		addChild(_tf);
		
		setScale(1);
		
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
	
	
	private function onKeyDown(e:KeyboardEvent):Void 
	{
      _tf.text = "dn:" + ICadeKeyCode.getKeyLabel(e.keyCode);
	}
	
	private function onKeyUp(e:KeyboardEvent):Void 
	{
      _tf.text = "up:" + ICadeKeyCode.getKeyLabel(e.keyCode);
      
      if (e.keyCode == Keyboard.F1) {
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
  
  
  
  }