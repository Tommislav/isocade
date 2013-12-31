import flash.events.EventDispatcher;
class LocalGameSocket extends EventDispatcher implements IGameSocket
{
	private var numberOfClients:Int;
	public function new() 
	{
		super();
	}
	
	public function Connect()
	{
		var gp:GamePacket = new GamePacket(numberOfClients,-1,1,1);
		this.dispatchEvent(new GameSocketEvent(GameSocketEvent.GS_DATA, gp, ""));
		numberOfClients++;
	}
	
	public function Send(gp:GamePacket)
	{
		this.dispatchEvent(new GameSocketEvent(GameSocketEvent.GS_DATA,gp,""));
	}
	
	public function CreateRandomPlayer()
	{
		var gp:GamePacket = new GamePacket(numberOfClients,-1,Math.random()*256+100,Math.random()*100);
		this.dispatchEvent(new GameSocketEvent(GameSocketEvent.GS_DATA, gp, ""));
		numberOfClients++;
	}
}