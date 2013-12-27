package se.isotop.gamesocket;
import flash.events.Event;

class GameSocketEvent extends Event
{
	public var raw:String;
	public var packet:GamePacket;
	public function new(type:String, packet:GamePacket, raw:String)
	{ 
		super(type, false, false);
		this.raw = raw;
		this.packet = packet;
	}
	public inline static var GS_DATA = "GS_DATA";
	public inline static var GS_CLOSED = "GS_CLOSED";
	public inline static var GS_SEND = "GS_SEND";
	static public inline var GS_CONNECTION_HANDSHAKE:String = "GS_CONNECTION_HANDSHAKE";
	static public inline var GS_NEW_PLAYER_CONNECTED:String = "GS_NEW_PLAYER_CONNECTED";
	static public inline var GS_PLAYER_DISCONNECTED:String = "GS_PLAYER_DISCONNECTED";
	
}