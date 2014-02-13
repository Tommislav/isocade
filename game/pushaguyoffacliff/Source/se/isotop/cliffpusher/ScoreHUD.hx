package se.isotop.cliffpusher;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;

/**
 * ...
 * @author Tommislav
 */
class ScoreHUD extends Entity
{
	private var _score:Text;
    private var _scores:GameScore;
	
	public function new(scores:GameScore)
	{
		super();
		var scoreOpt:TextOptions = { };
		scoreOpt.color = 0x000000;
		scoreOpt.size =  18;
		_score = new Text("", 10, 40, 300, 200, scoreOpt);
        _scores = scores;
		this.graphic = _score;
		followCamera = true;
		
		layer = HXP.BASELAYER - 1; // render on top
	}
	
	override public function update():Void 
	{
		super.update();
        updateScore();
	}

    private function updateScore():Void {

        if (_scores == null)
            return;

        var score = "";

        for (playerScore in _scores.getSortedPlayerScores()) {
            score += playerScore.playerName + ": " + playerScore.score + "\n";
        }
        _score.text = score;
    }
}