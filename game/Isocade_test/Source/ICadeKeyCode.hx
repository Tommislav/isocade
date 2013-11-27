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
	
	
	
	public inline static var UP = Keyboard.W;
	public inline static var DOWN = Keyboard.S;
	public inline static var LEFT = Keyboard.A;
	public inline static var RIGHT = Keyboard.D;
	
	// Top row, left to right
	public inline static var BUTTON_A = KEY_J;
	public inline static var BUTTON_B = KEY_K;
	public inline static var BUTTON_C = KEY_L;
	
	// Bottom row, left to right
	public inline static var BUTTON_1 = KEY_M;
	public inline static var BUTTON_2 = KEY_COMMA;
	public inline static var BUTTON_3 = KEY_DOT;
	
	// The two white buttons, top is enter, lower is back
	public inline static var BUTTON_START = Keyboard.ENTER;
	public inline static var BUTTON_BACK = Keyboard.ESCAPE;
	
	
	
	
	
	
	
	
	public function new() 
	{
		
	}
	
}