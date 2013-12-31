import flash.net.Socket;
import flash.events.EventDispatcher;
import flash.events.Event;
import flash.events.ProgressEvent;
import flash.events.DataEvent;

class GameSocket extends Socket implements IGameSocket
{
	private var _eventDispatcher:EventDispatcher;
	private var _serverIP:String;
	private var _serverPort:Int;
	public var LastSend:GamePacket;
	private var id:Int;
	public function new(serverIP:String = "127.0.0.1", serverPort:Int = 80)
	{
		super();
		_serverIP = serverIP;
		_serverPort = serverPort;
		_eventDispatcher = new EventDispatcher();
		LastSend = new GamePacket( -1);
	}

	// fulmetod som inte skall existera
	public function CreateRandomPlayer() { }
	
	public function Connect():Void
	{
		this.addEventListener(ProgressEvent.SOCKET_DATA,OnData);
		this.addEventListener(Event.CLOSE,OnClose);
		this.connect(_serverIP,_serverPort);
	}
	
	public function Send(gp:GamePacket)
	{
		this.writeUTFBytes(GamePacket.Serialize(gp));
		this.flush();
		LastSend = gp;
	}

	public function OnData(e:ProgressEvent)
	{
		if(this.bytesAvailable!=0)
        { 
			var raw = this.readUTFBytes(this.bytesAvailable);
			var packets = GamePacket.Parse(raw);
			for (i in 0...packets.length)
			{
				this.dispatchEvent(new GameSocketEvent(GameSocketEvent.GS_DATA,packets[i],raw));
			}
			
		}
	}

	public function OnClose(e:Event)
	{
		this.dispatchEvent(new GameSocketEvent(GameSocketEvent.GS_CLOSED,null,"closed"));
	}
}





