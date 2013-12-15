import flash.display.Sprite;
import flash.display.Bitmap;
import flash.events.Event;
import flash.Lib;

class Game extends Sprite
{
	public function new()
	{
		super();
		players = new Array<Player>();
		playerByID = new Map<Int,Player>();
		this.addEventListener(Event.ENTER_FRAME, Update);
	}
	
	public var playerId:Int = -1;
	public var players:Array<Player>;
	public var playerByID:Map<Int,Player>;
	
	public function AddPlayer(id:Int, x:Float = 0,y:Float = 0)
	{
		var player = new Player(x, y);
		players.push(player);
		playerByID.set(id,player); // nödlösning tills vidare
		this.addChild(player);
	}
	
	public function GetPlayer(id:Int):Player 
	{
		return playerByID[id];
	}
	
	public function PlayerExists(id:Int)
	{
		return playerByID.exists(id);
	}
	
	var tmpbitmap:Bitmap;
	var tmpspeed:Float = 1;
	
	private var f:Int;
	private var oldTime:UInt;
    private function Update(e:Event)
    {
		var currentTime = Lib.getTimer();
		var delta = (currentTime-oldTime)/10;
		
		if(f%60==0)
			Util.Print("delta: "+delta);
		
		for (p in 0...players.length)
			players[p].Move(players[p].dx * delta, players[p].dy * delta);			
		
		Physics();
		
		if (f%60==0)
			SendPlayerPosition();
		
		oldTime = currentTime;
		f++;
    }
	
	private function Physics():Void 
	{
		// "floor"
		for (p in 0...players.length)
			if (players[p].y > 400)
				players[p].y = 400;
		
		// players
		if(players.length>1)
			for (i in 0...players.length)
				for (ii in i...players.length)
					if (PlayerCollision(players[i], players[ii], 64))
					{
						if (players[i].dx != 0)
						{
							players[i].Move(-players[i].dx, 0);
						}
						if (players[ii].dx != 0)
						{
							players[ii].Move(-players[ii].dx, 0);
						}
						players[i].collided = true;
						players[ii].collided = true;
					}
		
		// "gravity"
			for (p in 0...players.length)
				if(!players[p].collided)
					players[p].Move(0, 1);
					
			for (p in 0...players.length)
				players[p].collided = false;
	}
	
	private function PlayerCollision(playerA:Player,playerB:Player,rad:Int)
	{
		if (playerA == playerB)
			return false;
		
		var dx=playerB.x-playerA.x;
		var dy=playerB.y-playerA.y;
		var distance = Math.sqrt(dx * dx + dy * dy);

		return distance < rad;
	}
	
	private function SendPlayerPosition()
	{
		if (playerId < 0)
			return;
			
		var player = GetPlayer(playerId);
		var packet = new GamePacket(playerId, -1, player.x, player.y);
		this.dispatchEvent(new GameSocketEvent(GameSocketEvent.GS_SEND,packet,""));
	}
}