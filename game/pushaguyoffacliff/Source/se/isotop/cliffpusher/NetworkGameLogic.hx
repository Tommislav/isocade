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
	
	private static inline var TYPE_SPAWN_PUSH:Int = 20;
	
	
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
		//_gameSocket.connect("127.0.0.1", 8888);
		_gameSocket.connect("192.168.12.137", 8888);
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
		var type = e.packet.type;
		if (e.packet.type == TYPE_SPAWN_PUSH) {
			spawnNetworkPush(e.packet);
			return;
		}
		
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
	
	private function spawnNetworkPush(gp:GamePacket) {
		var x:Float = Std.parseFloat(gp.values[0]);
		var y:Float = Std.parseFloat(gp.values[1]);
		var dir:Int = Std.parseInt(gp.values[2]);
		var playerId = gp.id;
		
		if (playerId != _playerId) {
			spawnPushEntity(x, y, dir, playerId, false); // already spawned... this could be refactored =)
		}
	}
	
	public function spawnPushEntity( x:Float, y:Float, dir:Int, playerId:Int, send:Bool=true ) {
		var push:Push = new Push(x, y, dir, playerId);
		scene.add(push);
		/*
		if (send) {
			// push notification to other connected players that I just spawned
			var gp:GamePacket = new GamePacket();
			gp.id = playerId;
			gp.type = TYPE_SPAWN_PUSH;
			gp.values = new Array();
			gp.values.push(Std.string(x));
			gp.values.push(Std.string(y));
			gp.values.push(Std.string(dir));
			_gameSocket.send(gp.serialize());
		}
		*/
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