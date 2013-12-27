package se.isotop.cliffpusher;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import flash.events.KeyboardEvent;
import flash.Lib;
import flash.ui.Keyboard;
import se.isotop.gamesocket.GameSocket;
import se.isotop.gamesocket.GameSocketEvent;
import se.salomonsson.icade.ICadeKeyboard;

/**
 * ...
 * @author Tommislav
 */
class NetworkGameLogic extends Entity
{
	private var _playerId:Int = -1;
	private var _players:Array<Player>;
	private var _playerListDirty:Bool;

	private var _gameSocket:GameSocket;
	
	public function new() 
	{
		super(0, 0, null, null);
		_playerListDirty = true;
		
		// debug, swap players
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, onDebug);
		
		
		trace("connecting...");
		_gameSocket = new GameSocket();
		_gameSocket.addEventListener(GameSocketEvent.GS_CONNECTION_HANDSHAKE, onSocketConnected);
		_gameSocket.connect("127.0.0.1", 8888);
	}
	
	private function onSocketConnected(e:GameSocketEvent):Void 
	{
		_gameSocket.removeEventListener(GameSocketEvent.GS_CONNECTION_HANDSHAKE, onSocketConnected);
		_playerId = e.packet.id;
		
		scene.add(new Player(_playerId, Math.random() * 768, Math.random() * 1024, new ICadeKeyboard(), 0xffff0000));
		
		HXP.console.log(["Connected with id: " + _playerId]);
		
		_gameSocket.addEventListener(GameSocketEvent.GS_DATA, onSocketData);
	}
	
	private function onSocketData(e:GameSocketEvent):Void 
	{
		
		
		
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
			if (pl.id == -1) { pl.id = _playerId; /* this is me! */ }
			if (pl.id == _playerId) {
				
				
			}
		}
		
	}
}