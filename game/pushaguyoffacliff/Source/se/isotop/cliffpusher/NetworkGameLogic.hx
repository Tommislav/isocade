package se.isotop.cliffpusher;

import se.isotop.cliffpusher.model.PlayerInfo;
import se.isotop.cliffpusher.screens.StartScreen;
import com.haxepunk.HXP;
import se.isotop.cliffpusher.model.Socket;
import se.isotop.cliffpusher.model.PlayerModel;
import com.haxepunk.Entity;
import flash.geom.Point;
import se.isotop.gamesocket.GamePacket;
import se.isotop.gamesocket.GameSocket;
import se.isotop.gamesocket.GameSocketEvent;
import se.salomonsson.icade.ICadeKeyboard;
import se.isotop.cliffpusher.screens.EndScreen;
/**
 * ...
 * @author Tommislav
 */
class NetworkGameLogic extends Entity
{
	public static inline var NAME:String = "GameLogic";
    public static inline var MAX_SCORE:Int = 100;

	public static inline var SOCKET_TYPE_PLAYER_INFO:Int = 20;
	public static inline var SOCKET_TYPE_PLAYER_SCORE:Int = 21;

	private var _colors:Array<Int>;

    private var _playerModel:PlayerModel;
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
        _playerModel = PlayerModel.instance;

        _gameSocket.addEventListener(GameSocketEvent.GS_DATA, onSocketData);
        _gameSocket.addEventListener(GameSocketEvent.GS_CLOSED, onGameSocketDisconnected);
        _gameSocket.addEventListener(GameSocketEvent.GS_PLAYER_DISCONNECTED, onPlayerDisconnected);
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
        trace('Removed');
        _gameSocket.removeEventListener(GameSocketEvent.GS_DATA, onSocketData);
        _gameSocket.removeEventListener(GameSocketEvent.GS_CLOSED, onGameSocketDisconnected);
        _gameSocket.removeEventListener(GameSocketEvent.GS_PLAYER_DISCONNECTED, onPlayerDisconnected);
	}

    private function newPlayer(id:Int, isItMe:Bool):Void {
        _playerUpdates.set(id, null);
        var playerModel = PlayerModel.instance;
        var input = new ICadeKeyboard();

        #if (windows || mac)
			input.setKeyboardMode(true);
		#end

        if (isItMe) {
            playerModel.addMyself(id);
        } else {
            playerModel.addPlayer(id);
            input.disable();
        }

        var xPos = _playerSpawnPoint.x + ((id * 32) % 4);
        var yPos = _playerSpawnPoint.y;

		var pInfo:PlayerInfo = playerModel.getPlayer(id);
        var p:Player = new Player(id, pInfo.color, xPos, yPos, input, isItMe);
        scene.add(p);
    }

    private function newFakePlayer(x, y) {
        var fakeId = -1;
		var fakeColor = 4;
        _playerUpdates.set(fakeId, null);

        var input = new ICadeKeyboard();
        input.disable();

        var p:FakePlayer = new FakePlayer(fakeId, fakeColor, x, y, input, false);
        scene.add(p);
    }

    private function newPickup(x, y) {
        var p:Pickup = new Pickup();
        p.x = x;
        p.y = y;
        scene.add(p);
    }

    private function onPlayerDisconnected(e:GameSocketEvent):Void
    {
        var id = e.packet.id;

        var players = new Array<Player>();
        this.scene.getClass(Player, players);
        for(pl in players) {
            if (pl.id == id)
                this.scene.remove(pl);
        }

        var gameScore:GameScore = cast(this.scene.typeFirst(GameScore.TYPE), GameScore);
        gameScore.removePlayerScore(id);
    }

    private function onGameSocketDisconnected(e:GameSocketEvent):Void {
        HXP.scene = new StartScreen();
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
        if (objectiveReached())
        {
            var gameScore:GameScore = cast(scene.typeFirst(GameScore.TYPE), GameScore);

            HXP.scene = new EndScreen(gameScore.getSortedPlayerScores());
        }
        var players = new Array<Player>();
        this.scene.getClass(Player, players);

        for (pl in players) {
			
            var id = pl.id;
            if (_playerModel.isItMe(id)) { /* this is me */
                sendMyPlayerInfo(pl);
            } else {
				if (pl.id >= 0) {
					updateOtherPlayer(pl);
				}
            }
        }
	}

    private function objectiveReached() {
        var gameScore:GameScore = cast(scene.typeFirst(GameScore.TYPE), GameScore);
        if (gameScore == null)
            return false;

        return gameScore.getLeaderScore() >= MAX_SCORE;
    }

    private function sendMyPlayerInfo(player:Player):Void {
        var packets = new Array<GamePacket>();
        var myInfo:GamePacket = new GamePacket();

        myInfo.id = _playerModel.getMyself().id;
        myInfo.type = SOCKET_TYPE_PLAYER_INFO;
        myInfo.values = new Array<String>();

        myInfo.values.push(Std.string(Math.round(player.x)));
        myInfo.values.push(Std.string(Math.round(player.y)));
        myInfo.values.push(Std.string(player.keyInput.serialize()));

        packets.push(myInfo);

        var myScore:GamePacket = new GamePacket();

        myScore.id = _playerModel.getMyself().id;
        myScore.type = SOCKET_TYPE_PLAYER_SCORE;
        myScore.values = new Array<String>();

        var gp:GamePacket = _playerScores.get(_playerModel.getMyself().id);
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