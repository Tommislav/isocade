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
	private var _colors:Array<Int>;
	
	private var _playerId:Int = -1;
	private var _players:Array<Player>;
	private var _allPlayerIds:Array<Int>;

	private var _gameSocket:GameSocket;
	private var _dataToProcess:Array<GamePacket>;
	private var _connected:Bool;
	
	public function new() 
	{
		super(0, 0, null, null);
		
		_colors = [
			0xff0000,
			0x00ff00,
			0x0000ff
		];
		
		
		// debug, swap players
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, onDebug);
		_allPlayerIds = new Array<Int>();
		_dataToProcess = new Array<GamePacket>();
		
		trace("connecting...");
		_gameSocket = new GameSocket();
		_gameSocket.addEventListener(GameSocketEvent.GS_CONNECTION_HANDSHAKE, onSocketConnected);
		_gameSocket.connect("127.0.0.1", 8888);
	}
	
	private function onSocketConnected(e:GameSocketEvent):Void 
	{
		_gameSocket.removeEventListener(GameSocketEvent.GS_CONNECTION_HANDSHAKE, onSocketConnected);
		_playerId = e.packet.id;
		
		newPlayer(_playerId, true);
		
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
			_allPlayerIds.push(e.packet.id);
			trace("WE HAVE A NEW PLAYER with id " + e.packet.id);
			newPlayer(e.packet.id, false);
		}
		
		_dataToProcess.push(e.packet);
		
	}
	
	private function newPlayer(id:Int, isItMe:Bool):Player {
		_allPlayerIds.push(id);
		
		var input = new ICadeKeyboard();
		input.setKeyboardMode(true);
		if (!isItMe)
			input.disable();
		
		var xPos = (2 + id) * 32;
		var yPos = 25 * 32;
		
		var p:Player = new Player(id, xPos, yPos, input, _colors[id]);
		scene.add(p);
		return p;
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
		
		trace("numPl: " + _players.length + ", dataLen: " + _dataToProcess.length);
		
		for (pl in _players) {
			if (pl.id == _playerId) { /* this is me */
				myInfo.id = _playerId;
				myInfo.values = new Array<String>();
				myInfo.values.push(Std.string(Math.round(pl.x)));
				myInfo.values.push(Std.string(Math.round(pl.y)));
				continue;
			}
			
			var id = pl.id;
			for (i in 0..._dataToProcess.length) {
				if (_dataToProcess[i].id == id) {
					pl.x = Std.parseFloat(_dataToProcess[i].values[0]);
					pl.y = Std.parseFloat(_dataToProcess[i].values[1]);
					trace("update other with id " + id + ", to " + _dataToProcess[i].values[0] + "/" +_dataToProcess[i].values[1]);
				}
			}
		}
		
		_dataToProcess = new Array<GamePacket>();
		
		if (_connected)
			_gameSocket.send(myInfo.serialize());
	}
}