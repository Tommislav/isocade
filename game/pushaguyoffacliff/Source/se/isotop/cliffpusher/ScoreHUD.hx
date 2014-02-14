package se.isotop.cliffpusher;

import se.isotop.cliffpusher.model.PlayerModel;
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
	
	public function new()
	{
		super();
		var scoreOpt:TextOptions = { };
		scoreOpt.color = 0x000000;
		scoreOpt.size =  18;
		_score = new Text("", 10, 40, 300, 200, scoreOpt);
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
        var scores:GameScore = cast(scene.typeFirst(GameScore.TYPE), GameScore);

        if (scores == null)
            return;

        var score = "";

        var model = PlayerModel.instance;

        for (playerScore in scores.getSortedPlayerScores()) {
            var playerInfo = model.getPlayer(playerScore.playerId);
            if (playerInfo != null)
                score += playerInfo.name + ": " + playerScore.score + "\n";
        }
        _score.text = score;
    }
}