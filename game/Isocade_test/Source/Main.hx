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
  	private var _isICadeMode:Bool;
	
	public function new () {
		
		super ();
		
		
		
		_tf = new TextField();
		_tf.text = "Press a key\nQ toggles mode";
		_tf.autoSize = TextFieldAutoSize.LEFT;
		_tf.defaultTextFormat = new TextFormat("arial", 24);
		addChild(_tf);
		
		setScale(2);
		
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
      switch(e.keyCode) {
          case ICadeKeyCode.UP:
          	_tf.text = "dn:Up";
          case ICadeKeyCode.DOWN:
          	_tf.text = "dn:Down";
          case ICadeKeyCode.LEFT:
            _tf.text = "dn:Left";
          case ICadeKeyCode.RIGHT:
            _tf.text = "dn:Right";
      	}
	}
	
	private function onKeyUp(e:KeyboardEvent):Void 
	{
		switch(e.keyCode) {
          case ICadeKeyCode.UP:
          	_tf.text = "up:Up";
          case ICadeKeyCode.DOWN:
          	_tf.text = "up:Down";
          case ICadeKeyCode.LEFT:
            _tf.text = "up:Left";
          case ICadeKeyCode.RIGHT:
            _tf.text = "up:Right";
      	}
      
      if (e.keyCode == Keyboard.Z) {
        _isICadeMode = !_isICadeMode;
        if(_isICadeMode) {
          _tf.text = "ICADE MODE";
          _keyListener.useICade();
        } else {
          _tf.text = "WASD MODE";
          _keyListener.useKeyboard();
        }
      }
	}
	
}