package se.salomonsson.icade;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.KeyboardEvent;
import flash.Lib;
import flash.ui.Keyboard;
import haxe.ds.IntMap.IntMap;

/**
 * Helper class to map the controls from the ICade bluetooth arcade joystick.
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
class ICadeKeyboard
{
	private var _eventDispatcher:EventDispatcher;
	private var _enabled:Bool;
	private var _useKeyboard:Bool;
	
	private var _iCadeButton_down:IntMap<Int>;
	private var _iCadeButton_up:IntMap<Int>;
	private var _buttonsPressed:IntMap<Bool>;
	
	
	public function new() 
	{
		_eventDispatcher = new EventDispatcher();
		_iCadeButton_down = new IntMap<Int>();
		_iCadeButton_up = new IntMap<Int>();
		_buttonsPressed = new IntMap<Bool>();
		
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
		
		enable();
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
	}
	
	public function getKeyboardMode():Bool {
		return _useKeyboard;
	}
	
	/**
	 * Will return angle of joystick currently being pressed - in degrees.
	 * 0 degrees is full right. 90 degrees is down.
	 * Will return -1 if no direction.
	 */
	public function getDegrees() {
		var E = 0, SE = 45, S = 90, SW = 135, W = 180, NW = 225, N = 270, NE = 315;
		
		var bitField = 0;
		
		bitField += _buttonsPressed.get(ICadeKeyCode.RIGHT) ? 1:0;
		bitField += _buttonsPressed.get(ICadeKeyCode.DOWN)	? 2:0;
		bitField += _buttonsPressed.get(ICadeKeyCode.LEFT)	? 4:0;
		bitField += _buttonsPressed.get(ICadeKeyCode.UP)	? 8:0;
		trace(bitField);
		
		var bitMap = [ -1, E, S, SE, W, -1, SW, -1, N, NE, -1, -1, NW];
		return bitMap[bitField];
	}
	
	
	private function onKeyDown(e:KeyboardEvent):Void {
		if (!_useKeyboard) {
			// ignore key down if icade
		} else {
			_buttonsPressed.set(e.keyCode, true);
			dispatch(e);
		}
	}
	
	private function onKeyUp(e:KeyboardEvent):Void {
		if (!_useKeyboard) {
			if (_iCadeButton_down.exists(e.keyCode)) {
				_buttonsPressed.set(e.keyCode, true);
				dispatchKeyboardEvent(KeyboardEvent.KEY_DOWN, _iCadeButton_down.get(e.keyCode));
			} else if (_iCadeButton_up.exists(e.keyCode)) {
				_buttonsPressed.set(e.keyCode, false);
				dispatchKeyboardEvent(KeyboardEvent.KEY_UP, _iCadeButton_up.get(e.keyCode));
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
}