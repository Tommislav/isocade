package se.isotop.cliffpusher.model;

import se.isotop.cliffpusher.model.Server.DefaultServer;
import flash.net.SharedObject;
import se.isotop.gamesocket.GameSocketEvent;
import flash.events.EventDispatcher;
import se.isotop.gamesocket.GameSocket;

class Socket extends EventDispatcher {
    private static inline var SERVER_STORAGE:String = "serverConnection";

    private var _serverData:SharedObject;
	private var _serverId:Int;

	private var _ip:String = "(none)";
	public function getConnectIp() { return _ip; }

    private static var _socket:Socket;
    public static var instance(get_instance, null):Socket;
    static function get_instance() {
        if (_socket == null)
            _socket = new Socket();

        return _socket;
    }

    private var _gameSocket:GameSocket;
    public var gameSocket(get_gameSocket, null):GameSocket;
    function get_gameSocket() {
        return _gameSocket;
    }

    private var _isConnected:Bool;
    public var isConnected(get_isConnected, null):Bool;
    function get_isConnected() {
        return _isConnected;
    }

    private function new() {
        super();
        _gameSocket = new GameSocket();
        _isConnected = false;

        _serverData = SharedObject.getLocal(SERVER_STORAGE);
		var hasData:Bool = (_serverData.data.serverIp != null);
		#if (windows || mac || newip)
			hasData = false;
		#end
		
        if (!hasData) {
			saveServerFile(new DefaultServer());
		}
    }

    public function getGameSocket():GameSocket {
        return _gameSocket;
    }

    public function saveServerFile(serverInformation:Server) : Void
    {
        _serverData.clear();
        _serverData.data.serverIp = serverInformation._serverIP;
        _serverData.data.serverPort = serverInformation._port;
        this._serverData.flush();
    }

    public function connectToServer() {
        _gameSocket.addEventListener(GameSocketEvent.GS_CONNECTION_HANDSHAKE, onGameSocketConnected);
        _gameSocket.addEventListener(GameSocketEvent.GS_PLAYER_DISCONNECTED, onPlayerDisconnected);
        _gameSocket.addEventListener(GameSocketEvent.GS_CLOSED, onGameSocketClosed);
        var server:Server = getServerInformation();

		_ip = server._serverIP;
		
        _gameSocket.connect(server._serverIP, server._port);
    }

    private function onGameSocketConnected(e:GameSocketEvent) {
        _gameSocket.removeEventListener(GameSocketEvent.GS_CONNECTION_HANDSHAKE, onGameSocketConnected);
        _isConnected = true;
		_serverId = e.packet.id;
    }

    private function onPlayerDisconnected(e:GameSocketEvent) {
        var id = e.packet.id;
        PlayerModel.instance.removePlayer(id);
    }

    private function onGameSocketClosed(e:GameSocketEvent) {
        _gameSocket.removeEventListener(GameSocketEvent.GS_CLOSED, onGameSocketClosed);
        _gameSocket.removeEventListener(GameSocketEvent.GS_PLAYER_DISCONNECTED, onPlayerDisconnected);

        PlayerModel.instance.removePlayer(_serverId);
    }

	public function getMyServerId() { return _serverId; }

    public function getServerInformation() : Server
    {
        if (_serverData.data.serverIp  == null)
        {
            return new DefaultServer();
        }
        var server = new Server(_serverData.data.serverIp, _serverData.data.serverPort);

        return server;
    }
}