package se.isotop.cliffpusher;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import flash.events.KeyboardEvent;
import flash.Lib;
import flash.ui.Keyboard;
import se.isotop.gamesocket.GamePacket;
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
	private var _allPlayerIds:Array<Int>;

	private var _gameSocket:GameSocket;
	private var _dataToProcess:Array<GamePacket>;
	private var _connected:Bool;
	
	public function new() 
	{
		super(0, 0, null, null);
		
		// debug, swap players
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, onDebug);
		_allPlayerIds = new Array<Int>();
		
		trace("connecting...");
		_gameSocket = new GameSocket();
		_gameSocket.addEventListener(GameSocketEvent.GS_CONNECTION_HANDSHAKE, onSocketConnected);
		_gameSocket.connect("127.0.0.1", 8888);
	}
	
	private function onSocketConnected(e:GameSocketEvent):Void 
	{
		_gameSocket.removeEventListener(GameSocketEvent.GS_CONNECTION_HANDSHAKE, onSocketConnected);
		_playerId = e.packet.id;
		_allPlayerIds.push(_playerId);
		
		var input = new ICadeKeyboard();
		input.setKeyboardMode(true);
		scene.add(new Player(_playerId, HXP.halfWidth, HXP.halfHeight, input, 0xffff0000));
		
		trace("Connected with id: " + _playerId);
		_gameSocket.addEventListener(GameSocketEvent.GS_DATA, onSocketData);
		
		_connected = true;
	}
	
	private function onSocketData(e:GameSocketEvent):Void 
	{
		var exists:Bool = false;
		for (i in 0..._allPlayerIds.length) {
			if (_allPlayerIds[i] == e.packet.id) {
				exists = true;
				continue;
			}
		}
		if (!exists) {
			trace("WE HAVE A NEW PLAYER with id " + e.packet.id);
			var input:ICadeKeyboard = new ICadeKeyboard();
			input.disable();
			input.setKeyboardMode(true);
			var p:Player = new Player(e.packet.id, Math.random() * 768, Math.random() * 1024, input, 0xff00ff);
			scene.add(p);
		}
		
		trace("socket data " + e.raw);
		_dataToProcess.push(e.packet);
		
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
		
		var myInfo:GamePacket = new GamePacket();
		_players = new Array<Player>();
		this.scene.getClass(Player, _players);
		
		for (pl in _players) {
			if (pl.id == _playerId) { /* this is me */
				myInfo.id = _playerId;
				myInfo.values = [Std.string(pl.x), Std.string(pl.y)];
				continue;
			}
			
			var id = pl.id;
			for (i in (_dataToProcess.length-1)...0) {
				if (_dataToProcess[i].id == id) {
					pl.x = Std.parseFloat(_dataToProcess[i].values[0]);
					pl.y = Std.parseFloat(_dataToProcess[i].values[1]);
				}
			}
		}
		
		_dataToProcess = new Array<GamePacket>();
		
		if (_connected)
			_gameSocket.send(myInfo.serialize());
	}
}