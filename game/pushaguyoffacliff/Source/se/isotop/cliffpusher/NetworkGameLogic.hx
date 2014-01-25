package se.isotop.cliffpusher;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import flash.events.KeyboardEvent;
import flash.geom.Point;
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
	public static inline var NAME:String = "GameLogic";
	
	public static inline var SOCKET_TYPE_PLAYER_INFO:Int = 20;
	public static inline var SOCKET_TYPE_PLAYER_SCORE:Int = 21;
	
	
	private var _colors:Array<Int>;
	
	private var _playerId:Int = -1;
	private var _players:Array<Player>;

	private var _gameSocket:GameSocket;
	private var _connected:Bool;
	private var _playerUpdates:Map<Int, GamePacket>;
	private var _playerSpawnPoint:Point;
	
	
	public function new() 
	{
		super(0, 0, null, null);
		this.name = NAME;
		_playerUpdates = new Map<Int, GamePacket>(); // store the last recieved update for each player id
		
		trace("connecting...");
		_gameSocket = new GameSocket();
		_gameSocket.addEventListener(GameSocketEvent.GS_CONNECTION_HANDSHAKE, onSocketConnected);
		_gameSocket.connect("127.0.0.1", 8888);
		//_gameSocket.connect("192.168.12.137", 8888);
	}
	
	private function onSocketConnected(e:GameSocketEvent):Void 
	{
		_gameSocket.removeEventListener(GameSocketEvent.GS_CONNECTION_HANDSHAKE, onSocketConnected);
		_playerId = e.packet.id;
		
		
		var ld:Level = cast(scene.getInstance(Level.NAME), Level);
		var enemies:Array<Point> = ld.enemyPositionList;
		for (e in enemies) {
			newFakePlayer(e.x, e.y);
		}
		
		_playerSpawnPoint = ld.playerSpawnPoint;
		
		
		
		newPlayer(_playerId, true);
		
		
		trace("Connected with id: " + _playerId);
		_gameSocket.addEventListener(GameSocketEvent.GS_DATA, onSocketData);
		
		_connected = true;
	}
	
	private function onSocketData(e:GameSocketEvent):Void 
	{
		var id = e.packet.id;
		var type:Int = e.packet.type;
		
		if (!_playerUpdates.exists(id)) {
			trace("we have a new player with id " + id);
			newPlayer(id, false);
		}
		
		switch (type) {
			case SOCKET_TYPE_PLAYER_INFO:
				_playerUpdates.set(id, e.packet);
			case SOCKET_TYPE_PLAYER_SCORE:
				
		}
		
		
	}
	
	private function newPlayer(id:Int, isItMe:Bool):Player {
		_playerUpdates.set(id, null);
		
		var input = new ICadeKeyboard();
		
		#if windows
			input.setKeyboardMode(true);
		#end
		
		if (!isItMe)
			input.disable();
		
		var xPos = _playerSpawnPoint.x + (id * 32);
		var yPos = _playerSpawnPoint.y;
		
		var p:Player = new Player(id, xPos, yPos, input, isItMe);
		scene.add(p);
		return p;
	}
	
	private function newFakePlayer(x, y) {
		var fakeId = 4;
		_playerUpdates.set(fakeId, null);
		
		var input = new ICadeKeyboard();
		input.disable();
		
		var p:FakePlayer = new FakePlayer(fakeId, x, y, input, false);
		scene.add(p);
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
				myInfo.type = SOCKET_TYPE_PLAYER_INFO;
				myInfo.values = new Array<String>();
				myInfo.values.push(Std.string(Math.round(pl.x)));
				myInfo.values.push(Std.string(Math.round(pl.y)));
				myInfo.values.push(Std.string(pl.keyInput.serialize()));
				continue;
			}
			
			var gp = _playerUpdates.get(id);
			if (gp != null) {
				pl.x = Std.parseFloat(gp.values[0]);
				pl.y = Std.parseFloat(gp.values[1]);
				
				var parsedInput:Int = Std.parseInt(gp.values[2]);
				pl.keyInput.deserialize(parsedInput);
			}
		}
		
		if (_connected)
			_gameSocket.send(myInfo.serialize());
	}
}