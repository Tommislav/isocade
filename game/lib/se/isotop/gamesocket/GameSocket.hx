package se.isotop.gamesocket;

import flash.net.Socket;
import flash.events.EventDispatcher;
import flash.events.Event;
import flash.events.ProgressEvent;
import flash.events.DataEvent;

class GameSocket extends Socket
{
	private var _eventDispatcher:EventDispatcher;
	private var _serverIP:String;
	private var _serverPort:Int;
	public var lastSend:String;
	private var id:Int;
	public function new(?host : String, ?port : Int = 0)
	{
		super();
		_serverIP = host;
		_serverPort = port;
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
			var raw = this.readUTFBytes(this.bytesAvailable);
			var packet = new GamePacket();
			packet.parse(raw);
			this.dispatchEvent(new GameSocketEvent(GameSocketEvent.GS_DATA,packet,raw));
		}
	}

	public function onClose(e:Event)
	{
		this.dispatchEvent(new GameSocketEvent(GameSocketEvent.GS_CLOSED,null,"closed"));
	}
}





