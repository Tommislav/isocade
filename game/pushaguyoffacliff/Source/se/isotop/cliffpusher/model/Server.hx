package se.isotop.cliffpusher.model;
import flash.net.SharedObject;
/**
 * ...
 * @author 
 */
class Server
{
	private var _serverData:SharedObject;

	public var _serverIP:String;
	public var _port:Int;
	public function new(server:String,port:Int) 
	{
		_serverIP = server;
		_port = port;
	}
	
	public function GetServerIpParts():Array<Int>
	{
		var ipPartsStr:Array<String> =  _serverIP.split(".");
		var ipParts:Array<Int> = new Array<Int>();
		
		for(i in 0...ipPartsStr.length)
		{
			ipParts.push(Std.parseInt(ipPartsStr[i]));
		}
		
		return ipParts;
	}
	
	public function SetServerIp(ipParts:Array<String>)
	{
		_serverIP = ipParts.join(".");
		trace("SERVER IP: " + _serverIP + " SAVED!");
	}
	
	private function SaveServerFile(serverInformation:Server) : Void
	{
		this._serverData.clear();
		
		
		if (this._serverData.data.server == null)
		{
			this._serverData.data.server = new Array();	
			this._serverData.data.server.push(serverInformation);
			this._serverData.flush();
		}	
	}
}

class DefaultServer extends Server
{
	public function new() 
	{
		super("127.0.0.1", 8888);
	}	
}