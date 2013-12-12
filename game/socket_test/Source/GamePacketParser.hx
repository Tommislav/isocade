class GamePacketParser
{
	public static function Parse(data:String) : GamePacket
	{
		var packetSegments = data.split('|');
		var dataSegments = packetSegments[0].split(':');
		var id = Std.parseInt(dataSegments[0]);
        var keycode:Int = Std.parseInt(dataSegments[1]);
		
		var packet = new GamePacket(id);
		packet.keycode = keycode;
		
		return packet;
	}
	
	public static function Serialize(packet:GamePacket):String 
	{
		return packet.id+":"+ packet.keycode + "|";
	}
}