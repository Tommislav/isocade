package se.isotop.cliffpusher;

import se.isotop.cliffpusher.model.Socket;
import se.isotop.cliffpusher.model.PlayerModel;
import com.haxepunk.Entity;
import flash.geom.Point;
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

    private var _socket:Socket;
	private var _gameSocket:GameSocket;
	private var _playerUpdates:Map<Int, GamePacket>;
    private var _playerScores:Map<Int, GamePacket>;
	private var _playerSpawnPoint:Point;
	
	public function new() 
	{
		super(0, 0, null, null);
		this.name = NAME;
		_playerUpdates = new Map<Int, GamePacket>(); // store the last recieved update for each player id
        _playerScores = new Map<Int, GamePacket>();
		
        _socket = Socket.instance;
        _gameSocket = _socket.gameSocket;
		_playerId = _socket.getMyServerId();
        _gameSocket.addEventListener(GameSocketEvent.GS_DATA, onSocketData);
	}
	
	override public function added():Void 
	{
		super.added();
		
        var ld:Level = cast(scene.getInstance(Level.NAME), Level);
        var enemies:Array<Point> = ld.enemyPositionList;
        for (e in enemies) {
            newFakePlayer(e.x, e.y);
        }
        var pickups:Array<Point> = ld.pickupSpawnPointList;
        for (p in pickups) {
            newPickup(p.x, p.y);
        }
		
        _playerSpawnPoint = ld.playerSpawnPoint;
		newPlayer(_socket.getMyServerId(), true);
    }
	
	override public function removed():Void 
	{
		super.removed();
		_gameSocket.removeEventListener(GameSocketEvent.GS_DATA, onSocketData);
	}

    private function newPlayer(id:Int, isItMe:Bool):Void {
        _playerUpdates.set(id, null);
        var playerModel = PlayerModel.instance;
        var input = new ICadeKeyboard();

        #if (cpp)
			input.setKeyboardMode(true);
		#end

        if (isItMe) {
            playerModel.addMyself(id);
        } else {
            playerModel.addPlayer(id);
            input.disable();
        }

        var xPos = _playerSpawnPoint.x + (id * 32);
        var yPos = _playerSpawnPoint.y;

        var p:Player = new Player(id, xPos, yPos, input, isItMe);
        scene.add(p);
    }

    private function newFakePlayer(x, y) {
        var fakeId = 4;
        _playerUpdates.set(fakeId, null);

        var input = new ICadeKeyboard();
        input.disable();

        var p:FakePlayer = new FakePlayer(fakeId, x, y, input, false);
        scene.add(p);
    }

    private function newPickup(x, y) {
        var p:Pickup = new Pickup();
        p.x = x;
        p.y = y;
        scene.add(p);
    }
	
	private function onSocketData(e:GameSocketEvent):Void 
	{
		var type:Int = e.packet.type;
		switch (type) {
			case SOCKET_TYPE_PLAYER_INFO:
				handlePlayerPacket(e.packet);
			case SOCKET_TYPE_PLAYER_SCORE:
				handleScorePacket(e.packet);
		}
	}

    private function handlePlayerPacket(packet:GamePacket):Void {
        var id = packet.id;

        if (!_playerUpdates.exists(id)) {
            trace("we have a new player with id " + id);
            newPlayer(id, false);
        }

        _playerUpdates.set(id, packet);
    }

    private function handleScorePacket(packet:GamePacket):Void {
        var id = packet.id;

        _playerScores.set(id, packet);
    }

	override public function update():Void 
	{
		super.update();
        var players = new Array<Player>();
        this.scene.getClass(Player, players);

		
        for (pl in players) {
			
            var id = pl.id;
            if (id == _playerId) { /* this is me */
                sendMyPlayerInfo(pl);
            } else {
                updateOtherPlayer(pl);
            }
        }
	}

    private function sendMyPlayerInfo(player:Player):Void {
        var packets = new Array<GamePacket>();
        var myInfo:GamePacket = new GamePacket();

        myInfo.id = _playerId;
        myInfo.type = SOCKET_TYPE_PLAYER_INFO;
        myInfo.values = new Array<String>();

        myInfo.values.push(Std.string(Math.round(player.x)));
        myInfo.values.push(Std.string(Math.round(player.y)));
        myInfo.values.push(Std.string(player.keyInput.serialize()));

        packets.push(myInfo);

        var myScore:GamePacket = new GamePacket();

        myScore.id = _playerId;
        myScore.type = SOCKET_TYPE_PLAYER_SCORE;
        myScore.values = new Array<String>();

        var gp:GamePacket = _playerScores.get(_playerId);
        var currentServerSideScore = gp != null ? Std.parseInt(gp.values[0]) : 0;

        if (currentServerSideScore != player.score) {
            myScore.values.push(Std.string(player.score));
            packets.push(myScore);
        }

        sendPackets(packets);
    }

    private function sendPackets(packets:Array<GamePacket>):Void {
		for(gp in packets) {
			_gameSocket.send(gp.serialize());
		}
    }

    private function updateOtherPlayer(player:Player):Void {
        var gp:GamePacket = _playerUpdates.get(player.id);
        if (gp != null) {
            player.x = Std.parseFloat(gp.values[0]);
            player.y = Std.parseFloat(gp.values[1]);

            var parsedInput:Int = Std.parseInt(gp.values[2]);
            player.keyInput.deserialize(parsedInput);
        }

        gp = _playerScores.get(player.id);
        if (gp != null) {
            player.score = Std.parseInt(gp.values[0]);
        }
    }

}