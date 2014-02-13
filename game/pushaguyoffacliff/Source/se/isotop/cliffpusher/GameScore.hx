package se.isotop.cliffpusher;

import flash.geom.Rectangle;
import com.haxepunk.Scene;
import com.haxepunk.Entity;

class GameScore extends Entity {
    private static inline var MAX_SCORE = 1000;
    private var _playerScores:Array<Score>;

    public static inline var NAME  = "score";

    public function new() {
        super();

        _playerScores = new Array<Score>();
        type = NAME;
    }

    override public function update():Void {
        updatePlayerScores();

        super.update();
    }

    private function updatePlayerScores():Void {
        var players = new Array<Player>();
        this.scene.getType(Player.NAME, players);

        for(player in players){
            var success = setPlayerScore(player.id, player.score);
            if (!success) {
                _playerScores.push(new Score(player.id, player.score));
            }
        }
    }

    private function setPlayerScore(id:Int, score:Int):Bool {
        for(playerScore in _playerScores) {
            if (playerScore.playerId == id) {
                playerScore.score = score;
                return true;
            }
        }
        return false;
    }

    public function getCurrentPlayerScores():Array<Score> {
        return _playerScores;
    }

    public function getLeaderScore():Int {

    }

    private function traceDebug(msg:String):Void {
        #if (debug)
            trace(msg);
        #end
    }
}