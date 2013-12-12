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
	private var id:Int = -1;
	public function new ()
	{
		super();
        var gs = InitSocket("127.0.0.1", 8888);
		gs.Connect();
		game = new Game();
		this.addChild(game);
		
		// lite evenst tmptmpt
		_pressedKeys = new Map<Int,Bool>();
		_keyListener = new ICadeKeyboard();
        _keyListener.setKeyboardMode(true);
        _keyListener.addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent) { 
			if (id>=0 && !_pressedKeys.exists(e.keyCode))
			{
				var gp = new GamePacket(id);
				gp.keycode = e.keyCode;
				gs.Send(gp);
				_pressedKeys.set(e.keyCode, true);
			}
		});
        _keyListener.addEventListener(KeyboardEvent.KEY_UP, function(e:KeyboardEvent)
		{ 
			if (id >= 0)
			{
				var gp = new GamePacket(id);
				gp.keycode = -e.keyCode;
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
			Util.Print("data" + e.raw + " : " + e.packet.keycode);
			if (this.id < 0)
				this.id = e.packet.id;
			
			game.SetPlayerInput(e.packet.id,e.packet.keycode);
		});
		return gs;
	}
}


	
