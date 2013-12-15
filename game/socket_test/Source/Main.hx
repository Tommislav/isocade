import flash.display.Sprite;
import flash.display.Bitmap;

import flash.events.KeyboardEvent;
import flash.utils.Timer;
import se.salomonsson.icade.ICadeKeyboard;
import se.salomonsson.icade.ICadeKeyCode;
import GameSocket;
import Game;
import Player;
import Util;
import GameSocketEvent;
class Main extends Sprite
{
    private var _keyListener:ICadeKeyboard;
	private var _pressedKeys:Map<Int,Bool>;
	private var _lastMessageSend:GamePacket;
	
    private var game:Game;
	private var playerId:Int = -1;
	public function new ()
	{
		super();
        var gs = InitSocket("127.0.0.1", 8888);
		gs.Connect();
		game = new Game();
		game.addEventListener(GameSocketEvent.GS_SEND, function(e:GameSocketEvent)
		{ 
			gs.Send(e.packet);
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
				var gp = new GamePacket(playerId,e.keyCode,player.x,player.y);
				gs.Send(gp);
				_pressedKeys.set(e.keyCode, true);
			}
		});
        _keyListener.addEventListener(KeyboardEvent.KEY_UP, function(e:KeyboardEvent)
		{ 
			if (playerId >= 0)
			{
				var gp = new GamePacket(playerId,-e.keyCode);
				gs.Send(gp);
				_pressedKeys.remove(e.keyCode);
			}
		});
	}

	private function InitSocket(ip:String, port:Int):GameSocket
	{
		var gs:GameSocket = new GameSocket(ip,port);
		gs.addEventListener(GameSocketEvent.GS_DATA, function(e:GameSocketEvent)
		{ 
			// Om vi får ett paket och inte har ett playerid skall vi sätta att vi är spelaren med det aktuella id't.
			if (playerId < 0)
			{
				playerId = e.packet.id;
				game.playerId = e.packet.id;
			}

			// Om det inte finns någon spelare med det aktuella id't skall vi skapa upp spelaren. Det kan vara antingen vi eller någon annan spelare.
			if (!game.PlayerExists(e.packet.id))
				game.AddPlayer(e.packet.id,0, 0);
				
			var player = game.GetPlayer(e.packet.id);
			if (player == null)
				return;
			
			if (e.packet.x > 0 || e.packet.y > 0)
				player.Set(e.packet.x, e.packet.y);
				
			player.Input(e.packet.keycode);
		});
		return gs;
	}
}


	
