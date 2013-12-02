package ;
import flash.ui.Keyboard;

/**
 * ...
 * @author Tommislav
 */
class ICadeKeyCode
{
	// --------------------------------
	// Used internally by ICadeKeyCodes //
	private inline static var KEY_J = 74;
	private inline static var KEY_K = 75;
	private inline static var KEY_L = 76;
	
	private inline static var KEY_M = 77;
	private inline static var KEY_COMMA = 188; // ,
	private inline static var KEY_DOT = 190; // .
	// --------------------------------
	
	
	
	public static var UP = Keyboard.W;
	public static var DOWN = Keyboard.S;
	public static var LEFT = Keyboard.A;
	public static var RIGHT = Keyboard.D;
	
	// Top row, left to right
	public inline static var BUTTON_A = KEY_J;
	public inline static var BUTTON_B = KEY_K;
	public inline static var BUTTON_C = KEY_L;
	
	// Bottom row, left to right
	public inline static var BUTTON_1 = KEY_M;
	public inline static var BUTTON_2 = KEY_COMMA;
	public inline static var BUTTON_3 = KEY_DOT;
	
	// The two white buttons, top is enter, lower is back
	public static var BUTTON_START = Keyboard.ENTER;
	public static var BUTTON_BACK = Keyboard.ESCAPE;
	
	
	
	
	public static function getKeyLabel(keyCode:Int):String {
		switch (keyCode){
			case ICadeKeyCode.UP:
				return "Up";
			case ICadeKeyCode.DOWN:
				return "Down";
			case ICadeKeyCode.LEFT:
				return "Left";
			case ICadeKeyCode.RIGHT:
				return "Right";
			
			case ICadeKeyCode.BUTTON_A:
				return "Button A";
			case ICadeKeyCode.BUTTON_B:
				return "Button B";
			case ICadeKeyCode.BUTTON_C:
				return "Button C";
			
			case ICadeKeyCode.BUTTON_1:
				return "Button 1";
			case ICadeKeyCode.BUTTON_2:
				return "Button 2";
			case ICadeKeyCode.BUTTON_3:
				return "Button 3";
			
			case ICadeKeyCode.BUTTON_START:
				return "Start Button";
			case ICadeKeyCode.BUTTON_BACK:
				return "Back Button";
	}
	return "Unknown key (" + keyCode + ")";
	}
	
	public function new() 
	{
		
	}
	
}