package se.isotop.cliffpusher;

import se.salomonsson.icade.ICadeKeyboard;
import se.salomonsson.icade.ICadeKeyCode;
import se.salomonsson.icade.ISerializeableReadInput;

/**
 * ...
 * @author Tommislav
 */
class FakePlayer extends Player
{
	private var _keyboard:ICadeKeyboard;

	public function new(id:Int, x:Float, y:Float, keyInput:ISerializeableReadInput, isItMe:Bool) 
	{
		super(id, x, y, keyInput, isItMe);
		_keyboard = cast(keyInput, ICadeKeyboard);
	}
	
	
	override public function update():Void 
	{
		var isShooting = Math.random() > 0.99;
		var isJumping = Math.random() > 0.99;
		_keyboard.setKeyIsDown(ICadeKeyCode.BUTTON_A, isJumping);
		_keyboard.setKeyIsDown(ICadeKeyCode.BUTTON_B, isShooting);
		
		_keyboard.setKeyIsDown(ICadeKeyCode.LEFT, Math.random() < 0.01);
		_keyboard.setKeyIsDown(ICadeKeyCode.RIGHT, Math.random() < 0.01);
		
		super.update();
	}
	
	
}