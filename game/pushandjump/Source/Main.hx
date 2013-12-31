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


// joypad
import openfl.events.JoystickEvent;

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
		
		game = new Game();
		game.addEventListener(GameSocketEvent.GS_SEND, function(e:GameSocketEvent)
		{ 
			gs.Send(e.packet);
		});
		this.addChild(game);
		gs.Connect();
		
		
		// fejka ut ett par klienter om vi kör lokal
		if (Std.is(gs, LocalGameSocket))
		{
			gs.CreateRandomPlayer();
			
			//gs.CreateRandomPlayer();
		}
		
		var lastX = -1;
		var lastY = -1;
		stage.addEventListener (JoystickEvent.AXIS_MOVE, function(e:JoystickEvent)
		{ 
			Util.Print("joystick" + e.x + ":" + e.y + ":" + e.id);
			
			var keyCode = -1;
			switch(e.x)
			{
				case -1: keyCode = ICadeKeyCode.LEFT;
				case 1: keyCode = ICadeKeyCode.RIGHT;
			}
			if (keyCode > -1)
			{
				this.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, true, false, -1, keyCode));
				lastX = keyCode;
			}
			else
			{
				this.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, true, false, -1, lastX));
				//lastX = -1;
				}	
				
			// y
			/*var keyCodeY = -1;
			switch(e.y)
			{
				case -1: keyCodeY = ICadeKeyCode.UP;
				case 1: keyCodeY = ICadeKeyCode.DOWN;

			}
			
			if (keyCodeY > -1)
			{
				this.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, true, false, -1, keyCodeY));
				lastY = keyCodeY;
			}
			else
			{
				this.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, true, false, -1, lastY));
				//lastY = -1;
				}	*/
			//this.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN,true,false,ch arCode,keyCode,0,ctrlKey,altKey,shiftKey))
			
		});
		
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
				var gp = new GamePacket(playerId, -e.keyCode);
				
				var player = game.GetPlayer(playerId);
				// problemet är att när man skickar in t.ex. höger ner, sen kommer vänster ner och sedan när höger upp kommer så stannar man.
				if(_pressedKeys.exists(e.keyCode))
					gs.Send(gp);
				
				
				
				
				if(e.keyCode==ICadeKeyCode.LEFT)
					_pressedKeys.remove(ICadeKeyCode.RIGHT);
				if(e.keyCode==ICadeKeyCode.RIGHT)
					_pressedKeys.remove(ICadeKeyCode.LEFT);
					
				_pressedKeys.remove(e.keyCode);
			}
		});
	}

	private function InitSocket(ip:String, port:Int):IGameSocket
	{
		//var gs:GameSocket = new GameSocket(ip,port);
		var gs:LocalGameSocket = new LocalGameSocket();
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


	
