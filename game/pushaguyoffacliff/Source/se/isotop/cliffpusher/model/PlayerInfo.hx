package se.isotop.cliffpusher.model;

class PlayerInfo {
    public var id:Int;
    public var name:String;
    public var color:Int;

    public function new(id:Int) {
        this.id = id;
        this.color = id > 3 ? id % 4 : id;
        this.name = "Player " + this.color;
    }
}