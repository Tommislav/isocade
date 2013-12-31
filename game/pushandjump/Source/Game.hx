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
		playersByIndex = new Array<Player>();
		playerByID = new Map<Int,Player>();
		
		// create level
		tiles = new Array<Tile>();
		for (i in 0...8)
			AddTile("platform_64.png", i*64+128, 705);

		this.addEventListener(Event.ENTER_FRAME, Update);
	}
	
	private function AddTile(name:String, x:Int, y:Int)
	{
		var tile = new Tile(x, y, name);
		tiles.push(tile);
		this.addChild(tile);
	}
	
	public var tiles:Array<Tile>;
	
	public var playerId:Int = -1;
	public var players:Array<Player>;
	public var playersByIndex:Array<Player>;
	public var playerByID:Map<Int,Player>;
	
	public function AddPlayer(id:Int, x:Float = 0,y:Float = 0)
	{
		var player = new Player(x, y, players.length==0);
		player.id = id;
		players.push(player);
		playerByID.set(id, player); // nödlösning tills vidare
		playersByIndex[id-1] = player;
		
		this.addChild(player);
	}
	
	public function GetPlayer(id:Int):Player 
	{
		if(playerByID.exists(id))
			return playerByID[id];
		return null;
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
		
		/*if(f%60==0)
			Util.Print("delta: "+delta);
		*/
		for (p in 0...players.length)
			players[p].Move(players[p].dx * delta, players[p].dy * delta);			
		
		Physics();
		
		if (f%240==0)
			SendPlayerPosition();
		
			
			
		// bitar skall falla ner efter en viss tid så att det blir trängr.	
		if (f % (60*5) == 0 && f>0)
		{
			var item =  Std.int(f / (60 * 5)) - 1;
			if(tiles.length>item)
				tiles[item].Gravity = true;
			Util.Print("done" + item);
		}
		

		oldTime = currentTime;
		f++;
    }
	
	
	

	
	private function Physics():Void 
	{
		// "gravity"
		
		for (p in 0...players.length)
			if (players[p].dy < 4)
			{
				//players[p].canJump = false;	
				players[p].Move(0, players[p].dy += 0.1);
			}
			
		for (p in 0...tiles.length)
		{
			if (tiles[p].Gravity)
				tiles[p].y *= 1.005;
		}
			
			
		// floor
		for (p in 0...players.length)
			for (t in 0...tiles.length)
			{
				var tile = tiles[t];
				var player = players[p];
				if (Collision.Intersects(tile, player))
				{
					player.dy = 0;
					player.y = tile.y - player.height;
					
				}

			}
		
		for (i in 0...players.length-1)
			for (ii in i...players.length)
			{

				var playerA = GetPlayer(i);
				var playerB = GetPlayer(ii);
				
				if (playerA == null || playerB == null)
					continue;
				
				if (Collision.Intersects(playerA,playerB)) // BROADPHASE
				{
					Util.Print("HIT!");
					
					
					if (playerA == playerB)
						continue;
					
					// horizontal sensors
					for (s in 0...playerA.sensors.length)
					{
						var c = Collision.PointInsideRect(playerA.x + playerA.sensors[s].X, playerA.y + playerA.sensors[s].Y, playerB);
	
						if(c.Hit)
						{
							Util.Print("A");
							var tmp = playerA.dx;
							playerA.dx = playerB.dx;
							playerB.dx = tmp;
							
							playerA.acceleration *= 0.2;
							playerB.acceleration *= 0.2;
							
							if (Math.abs(playerA.acceleration) > Math.abs(playerB.acceleration))
								playerB.dx *= 2;
							else if(Math.abs(playerB.acceleration) > Math.abs(playerA.acceleration))
								playerA.dx *= 2;
								
							return;
						}
					}

					
					// vertical sensors
					for (s in 0...playerA.verticalSensors.length)
					{
						var c = Collision.PointInsideRect(playerA.x + playerA.verticalSensors[s].X, playerA.y +playerA.verticalSensors[s].Y, playerB);
						if (c.Hit)
						{
							playerA.y = playerB.y - 64;
							playerA.dy = 0;
							break;
						}
						
						
						var c = Collision.PointInsideRect(playerB.x + playerB.verticalSensors[s].X, playerB.y +playerB.verticalSensors[s].Y, playerA);
						if (c.Hit)
						{
							playerB.y = playerA.y - 64;
							playerB.dy = 0;
							break;
						}
					}
					
					/*
					for (s in 0...playerB.sensors.length)
					{
						var c = Collision.PointInsideRect(playerB.x + playerB.sensors[s].X, playerB.y + playerB.sensors[s].Y, playerA);
	
						if(c.Hit)
						{
							Util.Print("A");
							var tmp = playerA.dx;
							playerA.dx = playerB.dx;
							playerB.dx = tmp;
							
							playerA.acceleration *= 0.2;
							playerB.acceleration *= 0.2;
							
							if (Math.abs(playerA.acceleration) > Math.abs(playerB.acceleration))
								playerB.dx *= 2;
							else if(Math.abs(playerB.acceleration) > Math.abs(playerA.acceleration))
								playerA.dx *= 2;
								
							return;
						}
						
					}*/
				}
			}

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
		var packet = new GamePacket(playerId, player.lastKeyCode, player.x, player.y);
		var packet = new GamePacket(playerId, 0, player.x, player.y);
		this.dispatchEvent(new GameSocketEvent(GameSocketEvent.GS_SEND,packet,""));
	}
}