package se.salomonsson.icade;
import com.furusystems.openfl.input.xinput.Xbox360Button;
import com.furusystems.openfl.input.xinput.XBox360Controller;
import com.furusystems.openfl.input.xinput.Xbox360ButtonType;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.KeyboardEvent;
import flash.Lib;
import flash.ui.Keyboard;
import haxe.ds.IntMap.IntMap;

/**
 * Helper class to map the controls from the ICade bluetooth arcade joystick.
 * 
 * Dispatches flash.event.KeyboardEvents but re-maps the event.keyCode to match the constants
 * in the class ICadeKeyCode.
 * 
 * To use without a connected ICade, turn on the keyboardMode using setKeyboardMode(true) to
 * get the same keyboard events with a regular keyboard (WASD for arrows, JKLNM, for the 6 buttons,
 * Enter for select and Escape for back).
 * 
 * By default this class will always start in ICade-mode (i.e. keyboardMode=false)
 * 
 * Add KeyboardListeners to an instance of ICadeKeyboard, just as you would on the stage.
 * Then check the keyboardEvent.keyCode against the defined keycodes in the ICadeKeyCode class
 * @author Tommislav
 */
class ICadeKeyboard implements ISerializeableReadInput
{
	private var _eventDispatcher:EventDispatcher;
	private var _enabled:Bool;
	private var _useKeyboard:Bool;
	private var _useController:Bool;
	
	private var _iCadeButton_down:Map<Int,Int>;
	private var _iCadeButton_up:Map<Int,Int>;
	private var _buttonsPressed:Map<Int,Bool>;
	private var _debugToggleKey:Int = -1;
	private var _xboxToIcadeMap:Map<Xbox360ButtonType,Int>;
	
	private var _xboxController:XBox360Controller;
	
	public function new() 
	{
		_eventDispatcher = new EventDispatcher();
		_xboxToIcadeMap = new Map<Xbox360ButtonType,Int>();
		
		
		_iCadeButton_down = new Map<Int,Int>();
		_iCadeButton_up = new Map<Int,Int>();
		_buttonsPressed = new Map<Int,Bool>();
		mapIcadeButton(ICadeKeyCode.UP, 87, 69);
		mapIcadeButton(ICadeKeyCode.DOWN, 88, 90);
		mapIcadeButton(ICadeKeyCode.LEFT, 65, 81);
		mapIcadeButton(ICadeKeyCode.RIGHT, 68, 67);
		mapIcadeButton(ICadeKeyCode.BUTTON_A, 89, 84);
		mapIcadeButton(ICadeKeyCode.BUTTON_B, 85, 70);
		mapIcadeButton(ICadeKeyCode.BUTTON_C, 73, 77);
		mapIcadeButton(ICadeKeyCode.BUTTON_1, 72, 82);
		mapIcadeButton(ICadeKeyCode.BUTTON_2, 74, 78);
		mapIcadeButton(ICadeKeyCode.BUTTON_3, 75, 80);
		mapIcadeButton(ICadeKeyCode.BUTTON_START, 79, 71);
		mapIcadeButton(ICadeKeyCode.BUTTON_BACK, 76, 86);
		
		mapXboxButton(Xbox360ButtonType.DpadLEFT, ICadeKeyCode.LEFT);
		mapXboxButton(Xbox360ButtonType.DpadRIGHT, ICadeKeyCode.RIGHT);
		mapXboxButton(Xbox360ButtonType.DpadUP, ICadeKeyCode.UP);
		mapXboxButton(Xbox360ButtonType.DpadDOWN, ICadeKeyCode.DOWN);
		mapXboxButton(Xbox360ButtonType.B, ICadeKeyCode.BUTTON_A);
		mapXboxButton(Xbox360ButtonType.A, ICadeKeyCode.BUTTON_B);
		mapXboxButton(Xbox360ButtonType.X, ICadeKeyCode.BUTTON_C);
		mapXboxButton(Xbox360ButtonType.Back, ICadeKeyCode.BUTTON_BACK);
		mapXboxButton(Xbox360ButtonType.Start, ICadeKeyCode.BUTTON_START);
		

		//trace("Isconnected" +_xboxController.isConnected());
	
			
		enable();
	}
	
	//xbox methods
	public function onButtonPressed(btn:Xbox360Button):Void
	{
		trace(btn.buttonType);
		_buttonsPressed.set(_xboxToIcadeMap.get(btn.buttonType), true);
			//onKeyDown(new KeyboardEvent(KeyboardEvent.KEY_DOWN, false, false, 0, ICadeKeyCode.RIGHT));
	}
	
	
	public function onButtonReleased(btn:Xbox360Button):Void
	{
			_buttonsPressed.set(_xboxToIcadeMap.get(btn.buttonType), false);
	//onKeyUp(new KeyboardEvent(KeyboardEvent.KEY_UP, false, false, 0, ICadeKeyCode.RIGHT));
	}

	
	public function setDebugToggleKey(toggleKey:Int) {
		_debugToggleKey = toggleKey;
	}
	
	
	private function mapXboxButton(btn:Xbox360ButtonType, iCadeButton:Int)
	{
		_xboxToIcadeMap.set(btn, iCadeButton);
	}
	
	
	
	
	
	private function mapIcadeButton(icadeState:Int, keyboardDownState:Int, keyboardUpState:Int) {
		_iCadeButton_down.set(keyboardDownState, icadeState);
		_iCadeButton_up.set(keyboardUpState, icadeState);
	}
	
	public function enable() {
		_enabled = true;
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp); 
	}
	
	
	public function disable() {
		Lib.current.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		Lib.current.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp); 
	}
	
	public function setKeyboardMode(flag:Bool) {
		_buttonsPressed = new IntMap<Bool>(); // reset pressed state
		_useKeyboard = flag;
		_useController = false;
	}
	
	public function setXboxControllerMode(flag:Bool) {
		_buttonsPressed = new IntMap<Bool>(); // reset pressed state
		_useController = flag;
		_useKeyboard = false;
		_xboxController = new XBox360Controller(0);
		_xboxController.setButtonListeners(onButtonPressed,onButtonReleased);
		
		if (flag) {
			Lib.current.stage.addEventListener(Event.ENTER_FRAME, pollXboxController);
		} else {
			Lib.current.stage.removeEventListener(Event.ENTER_FRAME, pollXboxController);
		}
	}
	
	private function pollXboxController(event) {
		_xboxController.poll();
	}
	
	public function getKeyboardMode():Bool {
		return _useKeyboard;
	}
	
	private function debugToggle() {
		setKeyboardMode(!_useKeyboard);
	}
	
	/**
	 * Will return angle of joystick currently being pressed - in degrees.
	 * 0 degrees is full right. 90 degrees is down.
	 * Will return -1 if no direction.
	 */
	public function getDegrees():Float {
		var E = 0, SE = 45, S = 90, SW = 135, W = 180, NW = 225, N = 270, NE = 315;
		
		var bitField = 0;
		
		bitField += _buttonsPressed.get(ICadeKeyCode.RIGHT) ? 1:0;
		bitField += _buttonsPressed.get(ICadeKeyCode.DOWN)	? 2:0;
		bitField += _buttonsPressed.get(ICadeKeyCode.LEFT)	? 4:0;
		bitField += _buttonsPressed.get(ICadeKeyCode.UP)	? 8:0;
		
		var bitMap = [ -1, E, S, SE, W, -1, SW, -1, N, NE, -1, -1, NW];
		return bitMap[bitField];
	}
	
	public function getKeyIsDown(keyCode:Int):Bool {
		return _buttonsPressed.get(keyCode);
	}
	// not part of regular interface, but can be used to fake NPC interaction
	public function setKeyIsDown(keyCode:Int, isDown:Bool) {
		_buttonsPressed.set(keyCode, isDown);
	}
	
	
	private function onKeyDown(e:KeyboardEvent):Void {
		if (_useController) {
		_buttonsPressed.set(e.keyCode, true);
		dispatch(e);
			trace("and go");
			//trace("key pressssssssssssssssssssssssssssed" +e.keyCode);
			// ... DO STUFF HERE!!!!
			//return;
		}
		
		if (!_useKeyboard) {
			// ignore key down if icade
		} else {
			_buttonsPressed.set(e.keyCode, true);
			dispatch(e);
		}
	}
	
	private function onKeyUp(e:KeyboardEvent):Void {
		
		if (_useController) {
			_buttonsPressed.set(e.keyCode, false);
			dispatch(e);
			// DO STUFF HERE!!!
			//return;
		}
		
		
		if (_debugToggleKey == e.keyCode) {
			debugToggle();
		}
		
		if (!_useKeyboard)
		{
			var mappedKey;
			if (_iCadeButton_down.exists(e.keyCode)) {
				mappedKey = _iCadeButton_down.get(e.keyCode);
				_buttonsPressed.set(mappedKey, true);
				dispatchKeyboardEvent(KeyboardEvent.KEY_DOWN, mappedKey);
			} else if (_iCadeButton_up.exists(e.keyCode)) {
				mappedKey = _iCadeButton_up.get(e.keyCode);
				_buttonsPressed.set(mappedKey, false);
				dispatchKeyboardEvent(KeyboardEvent.KEY_UP, mappedKey);
			} else {
				dispatchKeyboardEvent(KeyboardEvent.KEY_UP, e.keyCode);
		}
		} else {
			_buttonsPressed.set(e.keyCode, false);
			dispatch(e);
		}
	}
	
	private function dispatchKeyboardEvent(eventType:String, keyCode:Int) {
		var event = new KeyboardEvent(eventType, false, false, 0, keyCode );
		dispatch(event);
	}
	
	public function dispatch(e:Event) {
		_eventDispatcher.dispatchEvent(e);
	}
	
	public function addEventListener(type, listener) {
		_eventDispatcher.addEventListener(type, listener);
	}
	
	public function removeEventListener(type, listener) {
		_eventDispatcher.removeEventListener(type, listener);
	}
	
	public function serialize():Int {
		var d:Int = 0;
		d |= getKeyIsDown(ICadeKeyCode.UP) ? 			( 1 << 0 ) : 0;
		d |= getKeyIsDown(ICadeKeyCode.DOWN ) ? 		( 1 << 1 ) : 0;
		d |= getKeyIsDown(ICadeKeyCode.LEFT ) ? 		( 1 << 2 ) : 0;
		d |= getKeyIsDown(ICadeKeyCode.RIGHT ) ? 		( 1 << 3 ) : 0;
		d |= getKeyIsDown(ICadeKeyCode.BUTTON_A) ?		( 1 << 4 ) : 0;
		d |= getKeyIsDown(ICadeKeyCode.BUTTON_B) ?		( 1 << 5 ) : 0;
		d |= getKeyIsDown(ICadeKeyCode.BUTTON_C) ?		( 1 << 6 ) : 0;
		d |= getKeyIsDown(ICadeKeyCode.BUTTON_1) ?		( 1 << 7 ) : 0;
		d |= getKeyIsDown(ICadeKeyCode.BUTTON_2) ?		( 1 << 8 ) : 0;
		d |= getKeyIsDown(ICadeKeyCode.BUTTON_3) ?		( 1 << 9 ) : 0;
		d |= getKeyIsDown(ICadeKeyCode.BUTTON_START) ? 	( 1 << 10 ) : 0;
		d |= getKeyIsDown(ICadeKeyCode.BUTTON_BACK ) ? 	( 1 << 11 ) : 0;
		return d;
	}
	
	public function deserialize(d:Int):Void {
		_buttonsPressed.set(ICadeKeyCode.UP, 			(d & (1 << 0) != 0));
		_buttonsPressed.set(ICadeKeyCode.DOWN, 			(d & (1 << 1) != 0));
		_buttonsPressed.set(ICadeKeyCode.LEFT, 			(d & (1 << 2) != 0));
		_buttonsPressed.set(ICadeKeyCode.RIGHT, 		(d & (1 << 3) != 0));
		_buttonsPressed.set(ICadeKeyCode.BUTTON_A, 		(d & (1 << 4) != 0));
		_buttonsPressed.set(ICadeKeyCode.BUTTON_B, 		(d & (1 << 5) != 0));
		_buttonsPressed.set(ICadeKeyCode.BUTTON_C, 		(d & (1 << 6) != 0));
		_buttonsPressed.set(ICadeKeyCode.BUTTON_1, 		(d & (1 << 7) != 0));
		_buttonsPressed.set(ICadeKeyCode.BUTTON_2, 		(d & (1 << 8) != 0));
		_buttonsPressed.set(ICadeKeyCode.BUTTON_3, 		(d & (1 << 9) != 0));
		_buttonsPressed.set(ICadeKeyCode.BUTTON_START, 	(d & (1 << 10) != 0));
		_buttonsPressed.set(ICadeKeyCode.BUTTON_BACK, 	(d & (1 << 11) != 0));
	}
	
}