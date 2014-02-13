package se.isotop.cliffpusher.model;

import se.isotop.cliffpusher.model.Server.DefaultServer;
import flash.net.SharedObject;
import flash.events.Event;
import se.isotop.gamesocket.GameSocketEvent;
import flash.events.EventDispatcher;
import se.isotop.gamesocket.GameSocket;

class Socket extends EventDispatcher {
    private static inline var SERVER_STORAGE:String = "serverConnection";

    private var _serverData:SharedObject;

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

        if (_serverData.data.server == null)
            saveServerFile(new Server("127.0.0.1",8888));
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
        var server:Server = getServerInformation();

        _gameSocket.connect(server._serverIP, server._port);
    }

    private function onGameSocketConnected(e:GameSocketEvent) {
        _gameSocket.removeEventListener(GameSocketEvent.GS_CONNECTION_HANDSHAKE, onGameSocketConnected);
        _isConnected = true;
        dispatchEvent(new Event("connected"));
    }

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