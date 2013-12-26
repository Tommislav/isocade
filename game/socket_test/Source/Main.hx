import flash.display.Sprite;
import flash.display.Bitmap;
import flash.events.KeyboardEvent;
import flash.utils.Timer;
import se.salomonsson.icade.ICadeKeyboard;
import se.salomonsson.icade.ICadeKeyCode;
import se.isotop.gamesocket.GameSocket;
import se.isotop.gamesocket.GameSocketEvent;
import Game;
import Player;
import Util;
class Main extends Sprite
{
    private var _keyListener:ICadeKeyboard;
	private var _pressedKeys:Map<Int,Bool>;
	private var _lastMessageSend:NilsGamePacket;
	
    private var game:Game;
	private var playerId:Int = -1;
	public function new ()
	{
		super();
        var gs = InitSocket();
		gs.connect("127.0.0.1", 8888);
		game = new Game();
		game.addEventListener(GameSocketEvent.GS_SEND, function(e:GameSocketEvent)
		{ 
			gs.send(e.raw);
		});
		this.addChild(game);
		
		// lite evenst tmptmpt
		_pressedKeys = new Map<Int,Bool>();
		_keyListener = new ICadeKeyboard();
        _keyListener.setKeyboardMode(true);
        _keyListener.addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent) { 
			if (playerId>=0 && !_pressedKeys.exists(e.keyCode))
			{
				var player = game.GetPlayer(playerId);
				var gp = new NilsGamePacket(playerId,e.keyCode,player.x,player.y);
				gs.send(gp.serialize());
				_pressedKeys.set(e.keyCode, true);
			}
		});
        _keyListener.addEventListener(KeyboardEvent.KEY_UP, function(e:KeyboardEvent)
		{ 
			if (playerId >= 0)
			{
				var gp:NilsGamePacket = new NilsGamePacket(playerId,-e.keyCode);
				gs.send(gp.serialize());
				_pressedKeys.remove(e.keyCode);
			}
		});
	}

	private function InitSocket():GameSocket
	{
		var gs:GameSocket = new GameSocket("127.0.0.1", 8888);
		gs.addEventListener(GameSocketEvent.GS_DATA, function(e:GameSocketEvent)
		{ 
			var id:Int = e.packet.id;
			// Om vi får ett paket och inte har ett playerid skall vi sätta att vi är spelaren med det aktuella id't.
			if (playerId < 0)
			{
				playerId = id;
				game.playerId = id;
			}

			// Om det inte finns någon spelare med det aktuella id't skall vi skapa upp spelaren. Det kan vara antingen vi eller någon annan spelare.
			if (!game.PlayerExists(id))
				game.AddPlayer(id,0, 0);

			var nilsPacket:NilsGamePacket = new  NilsGamePacket(0,0,0,0); 
			nilsPacket.parse(e.raw);
			Util.Print("id: " + nilsPacket.id + ", xy: " + nilsPacket.x + "/" + nilsPacket.y + ", key: " + nilsPacket.keycode);
			var player = game.GetPlayer(id);
			if (player == null)
				return;
			
			if (nilsPacket.x > 0 || nilsPacket.y > 0)
				player.Set(nilsPacket.x, nilsPacket.y);
				
			player.Input(nilsPacket.keycode);
		});
		return gs;
	}
}


	
