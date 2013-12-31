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
	
	public static function Parse(data:String) : Array<GamePacket>
	{
		var packets:Array<GamePacket> = new Array<GamePacket>();
		var packetSegments = data.split('|');
		for (i in 0...packetSegments.length)
		{
			var dataSegments = packetSegments[i].split(':');
			if (dataSegments.length != 4)
				break;
			var id = Std.parseInt(dataSegments[0]);
			var keycode:Int = Std.parseInt(dataSegments[1]);
			var x:Float = Std.parseFloat(dataSegments[2]);
			var y:Float = Std.parseFloat(dataSegments[3]);
			
			var packet = new GamePacket(id);
			packet.keycode = keycode;
			packet.x = x;
			packet.y = y;
			packets.push(packet);
		}
		Util.Print("packet length: " + packets.length);
		return packets;
	}
	
	public static function Serialize(packet:GamePacket):String 
	{
		return packet.id+":"+ packet.keycode + ":" + packet.x + ":" + packet.y + "|";
	}
	
	
}