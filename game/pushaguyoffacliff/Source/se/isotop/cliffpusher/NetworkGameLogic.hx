package se.isotop.cliffpusher;

import com.haxepunk.Entity;
import flash.events.KeyboardEvent;
import flash.Lib;
import flash.ui.Keyboard;

/**
 * ...
 * @author Tommislav
 */
class NetworkGameLogic extends Entity
{
	private var _playerId:Int;
	private var _players:Array<Player>;
	private var _playerListDirty:Bool;

	public function new(playerId:Int) 
	{
		super(0, 0, null, null);
		_playerId = playerId;
		_playerListDirty = true;
		
		// debug
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, onDebug);
	}
	
	private function onDebug(e:KeyboardEvent):Void 
	{
		if (e.keyCode == Keyboard.NUMBER_1)
			_playerId = 0;
		else if (e.keyCode == Keyboard.NUMBER_2)
			_playerId = 1;
		else if (e.keyCode == Keyboard.NUMBER_3)
			_playerId = 2;
	}
	
	
	override public function update():Void 
	{
		super.update();
		
		if (_playerListDirty) {
			_playerListDirty = false;
			_players = new Array<Player>();
			this.scene.getClass(Player, _players);
		}
		
		for (pl in _players) {
			trace("player--> " + pl.id);
		}
		
	}
}