class GamePacket
{
	public var id:Int;
	public var keycode:Int;
	public function new(id:Int)
	{
		this.id = id;
	}
	
	public inline static var GP_MOVE = "GP_KEY";
}