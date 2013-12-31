// ganska sugit interface
interface IGameSocket
{
	function Connect():Void;
	function Send(gp:GamePacket):Void;
	function CreateRandomPlayer():Void;
	
}