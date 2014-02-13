package se.isotop.cliffpusher.model;

class PlayerModel {
    private var _playerInfos:Map<Int, PlayerInfo>;
    private var _myId:Int;

    private static var _instance:PlayerModel;
    public static var instance(get_instance, null):PlayerModel;

    static function get_instance(){
        if (_instance == null)
            _instance = new PlayerModel();

        return _instance;
    }

    private function new() {
        _playerInfos = new Map<Int, PlayerInfo>();
        _myId = -999;
    }

    public function addPlayer(id:Int):Void {
        if (!this.hasPlayer(id))
            _playerInfos.set(id, new PlayerInfo(id));
    }

    public function removePlayer(id:Int):Void {
        if (!this.hasPlayer(id))
            _playerInfos.remove(id);
    }

    public function getPlayer(id:Int):PlayerInfo {
        return _playerInfos.get(id);
    }

    public function hasPlayer(id:Int):Bool {
        return _playerInfos.exists(id);
    }

    public function getAllPlayers():Array<PlayerInfo> {
        var players = new Array<PlayerInfo>();
        for(id in _playerInfos.keys()) {
            players.push(_playerInfos.get(id));
        }

        return players;
    }

    public function addMyself(id:Int) {
        _myId = id;
        this.addPlayer(id);
    }

    public function getMyself():PlayerInfo {
        return this.getPlayer(_myId);
    }
}