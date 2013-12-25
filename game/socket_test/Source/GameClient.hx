import flash.net.Socket;
import flash.events.EventDispatcher;
import flash.events.Event;
import flash.events.DataEvent;

class GameSocket extends Socket
{
	private var _eventDispatcher = new EventDispatcher();
	private var _serverIP:String;
	private var _serverPort:Int;
	public function new(?host:String, port:Int=0)
	{
		super(host, port);
		
	}

	override public function connect(host:String, port:Int):Void 
	{
		_serverIP = serverIP;
		_serverPort = serverPort;
		
		this.addEventListener(ProgressEvent.SOCKET_DATA,onBroadcast);
		this.addEventListener(Event.CLOSE, onClose);
		
		super.connect(host, port);
	}
	

	public function onBroadcast()
	{
		_eventDispatcher.dispatchEvent(new GameSocketEvent("GS_DATA"));
	}

	public function onClose()
	{
		_eventDispatcher.dispatchEvent(new GameSocketEvent("GS_CLOSED"));
	}
}

class GameSocketEvent extends Event
{
	public function new(type:String){super(type,false,false);}
}