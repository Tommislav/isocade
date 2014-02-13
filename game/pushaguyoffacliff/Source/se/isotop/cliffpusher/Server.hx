package se.isotop.cliffpusher;
/**
 * ...
 * @author 
 */
class Server
{
	public var _serverIP:String;
	public var _port:Int;
	public function new(server:String,port:Int) 
	{
		_serverIP = server;
		_port = port;
	}
}

class DefaultServer extends Server
{
	public function new() 
	{
		super("127.0.0.1", 8888);
	}	
}