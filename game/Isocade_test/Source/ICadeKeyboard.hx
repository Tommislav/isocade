package ;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.KeyboardEvent;
import flash.Lib;
import flash.ui.Keyboard;

/**
 * ...
 * @author Tommislav
 */
class ICadeKeyboard
{
	private var _eventDispatcher:EventDispatcher;
	private var _enabled:Bool;
	private var _useICade:Bool;
	
	private var _iCadeButton_down:haxe.ds.IntMap<Int>;
	private var _iCadeButton_up:haxe.ds.IntMap<Int>;
	
	
	public function new() 
	{
		_eventDispatcher = new EventDispatcher();
		_iCadeButton_down = new haxe.ds.IntMap<Int>();
		_iCadeButton_up = new haxe.ds.IntMap<Int>();
		
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
		useICade();
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
	
	public function useICade() {
		_useICade = true;
	}
	
	public function useKeyboard() {
		_useICade = false;
	}
	
	
	private function onKeyDown(e:KeyboardEvent):Void {
		if (_useICade) {
			if (_iCadeButton_down.exists(e.keyCode)) {
				dispatch(new KeyboardEvent(e.type, e.bubbles, e.cancelable, 0, _iCadeButton_down.get(e.keyCode) ));
			} else if (_iCadeButton_up.exists(e.keyCode)) {
				dispatch(new KeyboardEvent(e.type, e.bubbles, e.cancelable, 0, _iCadeButton_up.get(e.keyCode) ));
			}
		} else {
			dispatch(e.clone());
		}
	}
	
	private function onKeyUp(e:KeyboardEvent):Void {
		if (_useICade) {
			// ignore key up if icade
		} else {
			dispatch(e);
		}
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