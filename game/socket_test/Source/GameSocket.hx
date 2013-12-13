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
	public var LastSend:GamePacket;
	private var id:Int;
	public function new(serverIP:String, serverPort:Int)
	{
		super();
		_serverIP = serverIP;
		_serverPort = serverPort;
		_eventDispatcher = new EventDispatcher();
		LastSend = new GamePacket( -1);
	}

	public function Connect()
	{
		this.addEventListener(ProgressEvent.SOCKET_DATA,OnData);
		this.addEventListener(Event.CLOSE,OnClose);
		this.connect(_serverIP,_serverPort);
	}
	
	public function Send(gp:GamePacket)
	{
		Sys.println("sending");
		this.writeUTFBytes(GamePacket.Serialize(gp));
		LastSend = gp;
	}

	public function OnData(e:ProgressEvent)
	{
		if(this.bytesAvailable!=0)
        { 
			var raw = this.readUTFBytes(this.bytesAvailable);
			var packet = GamePacket.Parse(raw);
			this.dispatchEvent(new GameSocketEvent(GameSocketEvent.GS_DATA,packet,raw));
		}
	}

	public function OnClose(e:Event)
	{
		_eventDispatcher.dispatchEvent(new GameSocketEvent(GameSocketEvent.GS_CLOSED,null,"closed"));
	}
}





