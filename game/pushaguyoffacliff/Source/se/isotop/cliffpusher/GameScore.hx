package se.isotop.cliffpusher;

import com.haxepunk.Scene;
import com.haxepunk.Entity;

class GameScore extends Entity {
    private var _playerScores:Array<Score>;

    public static inline var TYPE  = "score";

    public function new() {
        super();
        _playerScores = new Array<Score>();
        type = TYPE;
    }

    override public function update():Void {
        super.update();
        updatePlayerScores();
    }

    private function updatePlayerScores():Void {
        var players = new Array<Player>();
        this.scene.getType(Player.NAME, players);
        setScores(players);
    }

    public function setScores(players:Array<Player>):Void {
        
            for (player in players) {
				if (player.id > -1) {
					var success = setPlayerScore(player.id, player.score);
					if (!success) {
						_playerScores.push(new Score(player.id, player.score));
					}
				}
            }
    }

    public function setPlayerScore(id:Int, score:Int):Bool {
        for(playerScore in _playerScores) {
            if (playerScore.playerId == id) {
                playerScore.score = score;
                return true;
            }
        }
        return false;
    }

    public function getSortedPlayerScores():Array<Score> {
        var playerScoresCopy = new Array<Score>();
        for(score in _playerScores) {
            playerScoresCopy.push(score);
        }

        playerScoresCopy.sort( function(a:Score, b:Score):Int {
            if (a.score < b.score) return 1;
            if (a.score > b.score) return -1;
            return 0;
        });

        return playerScoresCopy;
    }

    public function getLeaderScore():Int {
        var scores = getSortedPlayerScores();
        if (scores.length == 0)
            return 0;

        return scores[0].score;
    }

    private function traceDebug(msg:String):Void {
        #if (debug)
            trace(msg);
        #end
    }
}