class GamePacket
{
	public var id:Int;
	public var keycode:Int;
	public var x:Float;
	public var y:Float;
	//public inline static var GP_MOVE = "GP_KEY";
	public function new(id:Int, keycode:Int = -1, x:Float = -1, y:Float = -1)
	{
		this.id = id;
		this.keycode = keycode;
		this.x = x;
		this.y = y;
	}
	
	public static function Parse(data:String) : GamePacket
	{
		var packetSegments = data.split('|');
		var dataSegments = packetSegments[0].split(':');
		var id = Std.parseInt(dataSegments[0]);
        var keycode:Int = Std.parseInt(dataSegments[1]);
		var x:Float = Std.parseFloat(dataSegments[2]);
		var y:Float = Std.parseFloat(dataSegments[3]);
		
		var packet = new GamePacket(id);
		packet.keycode = keycode;
		packet.x = x;
		packet.y = y;
		
		return packet;
	}
	
	public static function Serialize(packet:GamePacket):String 
	{
		return packet.id+":"+ packet.keycode + ":" + packet.x + ":" + packet.y + "|";
	}
	
	
}