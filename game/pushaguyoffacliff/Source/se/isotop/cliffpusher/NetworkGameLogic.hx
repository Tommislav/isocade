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

	private var _gameSocket:GameSocket;
	private var _connected:Bool;
	private var _playerUpdates:Map<Int, GamePacket>;
	
	public function new() 
	{
		super(0, 0, null, null);
		_playerUpdates = new Map<Int, GamePacket>(); // store the last recieved update for each player id
		
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
		var id = e.packet.id;
		if (!_playerUpdates.exists(id)) {
			trace("we have a new player with id " + id);
			newPlayer(id, false);
		}
		_playerUpdates.set(id, e.packet);
	}
	
	private function newPlayer(id:Int, isItMe:Bool):Player {
		_playerUpdates.set(id, null);
		
		var input = new ICadeKeyboard();
		input.setKeyboardMode(true);
		if (!isItMe)
			input.disable();
		
		var xPos = (2 + id) * 32;
		var yPos = 25 * 32;
		var colors = [0xff0000, 0x00ff00, 0x0000ff, 0xffff00, 0xff00ff, 0x00ffff];
		
		var p:Player = new Player(id, xPos, yPos, input, colors[id]);
		scene.add(p);
		return p;
	}
	
	
	override public function update():Void 
	{
		super.update();
		
		var myInfo:GamePacket = new GamePacket();
		_players = new Array<Player>();
		this.scene.getClass(Player, _players);
		
		for (pl in _players) {
			var id = pl.id;
			
			if (id == _playerId) { /* this is me */
				myInfo.id = _playerId;
				myInfo.values = new Array<String>();
				myInfo.values.push(Std.string(Math.round(pl.x)));
				myInfo.values.push(Std.string(Math.round(pl.y)));
				continue;
			}
			
			var gp = _playerUpdates.get(id);
			if (gp != null) {
				pl.x = Std.parseFloat(gp.values[0]);
				pl.y = Std.parseFloat(gp.values[1]);
			}
		}
		
		if (_connected)
			_gameSocket.send(myInfo.serialize());
	}
}