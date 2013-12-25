package se.isotop.gamesocket;

/**
 * Data is a string, ending with a "|"
 * Each value is separated with a ":"
 * First value is integer id
 * Second value is integer type
 * The rest are the values (as strings)
 * 
 * @author Tommislav
 */
class GamePacket
{
	public var id:Int;
	public var type:Int;
	public var values:Array<String>;
	
	public function new() 
	{
		
	}
	
	public function serialize():String {
		var str:String = id + ":" + type;
		for (i in 0...values.length) {
			str += ":" + values[i];
		}
		return str;
	}
	
	public function parseRaw(data:String):GamePacket {
		var packetSegments = data.split('|');
		var dataSegments = packetSegments[0].split(':');
	
		this.id = Std.parseInt(dataSegments.shift());
		this.type = Std.parseInt(dataSegments.shift());
		this.values = dataSegments;
		return this;
	}
	
	public static function create(id:Int, type:Int, data:Array<String>):GamePacket {
		var gp:GamePacket = new GamePacket();
		gp.id = id;
		gp.type = type;
		gp.values = data;
		return gp;
	}
	
	public static function parse( data:String ):GamePacket
	{
		var gp:GamePacket = new GamePacket();
		gp.parseRaw(data);
		return gp;
	}
}