package se.isotop.gamesocket;

import com.haxepunk.HXP;
import flash.net.Socket;
import flash.events.EventDispatcher;
import flash.events.Event;
import flash.events.ProgressEvent;
import flash.events.DataEvent;

class GameSocket extends Socket
{
	private static inline var TYPE_CONNECTION_HANDSHAKE = 1;
	private static inline var TYPE_PLAYER_CONNECTED = 2;
	private static inline var TYPE_PLAYER_DISCONNECTED = 3;
	
	private var _eventDispatcher:EventDispatcher;
	private var _serverIP:String;
	private var _serverPort:Int;
	public var lastSend:String;
	private var id:Int;
	public function new(?host:String, ?port:Int=0)
	{
		super();
		_eventDispatcher = new EventDispatcher();
		lastSend = "";
	}

	override public function connect(?host:String, ?port:Int):Void 
	{
		this.addEventListener(ProgressEvent.SOCKET_DATA, onData);
		this.addEventListener(Event.CLOSE,onClose);
		super.connect(host, port);
	}
	
	
	public function send(data:String)
	{
		this.writeUTFBytes(data);
		lastSend = data;
	}

	public function onData(e:ProgressEvent)
	{
		if(this.bytesAvailable!=0)
        { 
			var rawArray = this.readUTFBytes(this.bytesAvailable).split("|");
			for (i in 0...rawArray.length) {
				var raw = rawArray[i];
				if (raw.length <= 1) continue;
				
				var packet = new GamePacket();
				packet.parse(raw);
				
				var type = GameSocketEvent.GS_DATA;
				if (packet.type == TYPE_CONNECTION_HANDSHAKE)
					type = GameSocketEvent.GS_CONNECTION_HANDSHAKE;
				if (packet.type == TYPE_PLAYER_CONNECTED)
					type = GameSocketEvent.GS_NEW_PLAYER_CONNECTED;
				if (packet.type == TYPE_PLAYER_DISCONNECTED)
					type = GameSocketEvent.GS_PLAYER_DISCONNECTED;
				
				HXP.console.log(["onData ", raw, packet.type]);
				this.dispatchEvent( new GameSocketEvent( type, packet, raw ) );
			}
			
		}
	}

	public function onClose(e:Event)
	{
		this.dispatchEvent(new GameSocketEvent(GameSocketEvent.GS_CLOSED,null,"closed"));
	}
}
