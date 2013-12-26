import se.isotop.gamesocket.GamePacket;
class NilsGamePacket extends GamePacket
{	
	public var keycode:Int;
	public var x:Float;
	public var y:Float;
	
	public function new(id:Int, keycode:Int = -1, x:Float = -1, y:Float = -1)
	{
		super();
		this.id = id;
		this.type = 0;
		
		this.values = new Array<String>();
		values.push(Std.string(keycode));
		values.push(Std.string(x));
		values.push(Std.string(y));
		
		this.keycode = keycode;
		this.x = x;
		this.y = y;
	}
	
	override public function parse(data:String):GamePacket 
	{
		super.parse(data);
		this.keycode = Std.parseInt(values[0]);
		this.x = Std.parseFloat(values[1]);
		this.y = Std.parseFloat(values[2]);
		return this;
	}
	
}