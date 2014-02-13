package se.isotop.cliffpusher;

class Score {
    public var playerId:Int;
    public var playerName:String;
    public var score:Int;

    public function new(id:Int, score:Int){
        this.playerId = id;
        this.score = score;
    }
}