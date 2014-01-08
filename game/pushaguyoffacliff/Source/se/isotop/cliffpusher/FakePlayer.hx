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
		var isJumping = Math.random() > 0.99;
		_keyboard.setKeyIsDown(Player.JUMP_BUTTON, isJumping);
		
		var isShooting = Math.random() > 0.85;
		_keyboard.setKeyIsDown(Player.SHOOT_BUTTON, isShooting);
		
		_keyboard.setKeyIsDown(ICadeKeyCode.LEFT, Math.random() < 0.01);
		_keyboard.setKeyIsDown(ICadeKeyCode.RIGHT, Math.random() < 0.01);
		
		super.update();
	}
	
	
}