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
		this.addEventListener(Event.ENTER_FRAME, Update);
		
		// debug
		AddPlayer();
		AddPlayer(100);
		AddPlayer(0,100);
	}
	
	public var players:Array<Player>;
	public function AddPlayer(x:Float = 0,y:Float = 0)
	{
		players.push(new Player(x,y));
		this.addChild(players[players.length-1]);
	}
	
	public function SetPlayerInput(id:Int,keycode:Int):Void 
	{
		players[id].Input(keycode);
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
		
		oldTime = currentTime;
		f++;
    }
	
	private function Physics():Void 
	{
		for (p in 0...players.length)
			players[p].Move(0, 1);	
		for (p in 0...players.length)
			if (players[p].y > 400)
				players[p].y = 400;
	}
}