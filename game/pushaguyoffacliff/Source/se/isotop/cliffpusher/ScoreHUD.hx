package se.isotop.cliffpusher;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Text;

/**
 * ...
 * @author Tommislav
 */
class ScoreHUD extends Entity
{
	private var _score:Text;
	private var _players:Array<Player>;
	
	public function new() 
	{
		super();
		var scoreOpt:TextOptions = { };
		scoreOpt.color = 0x000000;
		scoreOpt.size =  18;
		_score = new Text("", 10, 40, 300, 200, scoreOpt);
		this.graphic = _score;
		followCamera = true;
	}
	
	override public function update():Void 
	{
		super.update();
		_players = [];
		scene.getType(Player.NAME, _players);
		
		
		var score = "";
		for (pl in _players) {
			score += pl.id + ": " + pl.score + "\n";
		_score.text = score;
		}
	}
	
}