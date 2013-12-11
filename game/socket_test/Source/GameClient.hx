import flash.net.Socket;
import flash.events.EventDispatcher;
import flash.events.Event;
import flash.events.DataEvent;

class GameSocket extends Socket
{
	private var _eventDispatcher = new EventDispatcher();
	private var _serverIP:String;
	private var _serverPort:Int;
	public function new(serverIP:String, serverPort:Int)
	{
		super();
		_serverIP = serverIP;
		_serverPort = serverPort;
	}

	public function Connect()
	{
		this.addEventListener(ProgressEvent.SOCKET_DATA,OnBroadcast);
		this.addEventListener(Event.CLOSE,OnClose);
		this.connect(_serverIP,_serverPort);
	}

	public function OnBroadcast()
	{
		_eventDispatcher.dispatchEvent(new GameSocketEvent("GS_DATA"));
	}

	public function OnClose()
	{
		_eventDispatcher.dispatchEvent(new GameSocketEvent("GS_CLOSED"));
	}
}

class GameSocketEvent extends Event
{
	public function new(type:String){super(type,false,false);}
}