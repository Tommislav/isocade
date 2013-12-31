import flash.display.Sprite;
class Collision
{
	public static function Intersects(playerA:Sprite, playerB:Sprite)
	{
		// det här skall aldrig kunna hända.
		if (playerA == playerB)
			return false;
			
		return !(playerA.x + playerA.width < playerB.x ||
				playerA.y + playerA.height < playerB.y ||
				playerB.x + playerB.width < playerA.x ||
				playerB.y + playerB.height < playerA.y);
	}
	
	
	// Bör returnera en collisionresponse med hur långt in punkten penetrerat?
	public static function PointInsideRect(x:Float, y:Float, player:Player):CollisionResponse
	{	
		var c = new CollisionResponse();
		var c = new CollisionResponse();
		c.Hit = (x > player.x && x < player.x + player.width) && (y > player.y && y < player.y + player.height);
		
		if (c.Hit)
		{
			
			
			/*
			var right = player.x + player.width - x;
			var left = player.x - x;
			c.X = Math.abs(right) > Math.abs(left) ? left + player.sensorLength : right - player.sensorLength;
			
			var top = player.y - y;
			var bottom = player.y + player.height - y;
			c.Y = Math.abs(top) > Math.abs(bottom) ? bottom + player.sensorLength : top + player.sensorLength;
			
			if (Math.abs(c.X) > Math.abs(c.Y))
				c.X = 0;
			else
				c.Y = 0;
			*/
		}
		
		return c;
	}
}

class CollisionResponse
{
	public var X:Float;
	public var Y:Float;
	public var Hit:Bool;
	public function new()
	{
		
	}
}