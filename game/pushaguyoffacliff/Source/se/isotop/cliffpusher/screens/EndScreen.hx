package se.isotop.cliffpusher.screens;

import se.isotop.gamesocket.GamePacket;
import com.haxepunk.Graphic;
import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Text;
import com.haxepunk.graphics.Image;

import com.haxepunk.Scene;
import se.isotop.cliffpusher.PlayerGraphics;
import se.isotop.cliffpusher.Score;


/**
 * ...
 * @author Tommislav
 */
class EndScreen extends Scene
{

    private var _scores:Array<Score>;

	public function new(scores:Array<Score>)
	{
		super();

        _scores = scores;

        trace(scores.length);

	}


    override public function begin() {
        var titleText:Text = new Text("The Winner is: ");
        titleText.color = 0x0000BB;
        titleText.size = 72;
        var textEntity:Entity = new Entity(0,0,titleText);
        textEntity.x = (HXP.width/2)-(titleText.width/2);
        textEntity.y = 100;
        add(textEntity);
        var st:String = "";
        for (s in _scores) {
            st = st + "Player: " +s.playerId + ": " + s.score + "\n";
        }
        trace(st);
        var scoreText:Text = new Text(st);
        scoreText.color = 0xFF22BB;
        scoreText.size = 24;
        var scoreTextEntity:Entity = new Entity(0,0,scoreText);
        scoreTextEntity.x = (HXP.width/2)-(scoreText.width/2);
        scoreTextEntity.y = 200;
        add(scoreTextEntity);

        var bgImage:Image = new Image("assets/podium.png");

        var bgEntity = new Entity(HXP.width/2-bgImage.width/2,450, bgImage);
        add(bgEntity);

        if (_scores.length > 0) {
            var player1:Graphic = new PlayerGraphics(_scores[0].playerId);
            addGraphic(player1,0,HXP.width/2-20,420);
        }
        if (_scores.length > 1) {
            var player1:Graphic = new PlayerGraphics(_scores[1].playerId);
            addGraphic(player1,0,HXP.width/2-200,470);
        }

        if (_scores.length > 2) {
            var player1:Graphic = new PlayerGraphics(_scores[2].playerId);
            addGraphic(player1,0,HXP.width/2+170,470);
        }

        if (_scores.length > 3) {
            var player1:Graphic = new PlayerGraphics(_scores[3].playerId);
            addGraphic(player1,0,HXP.width/2-100,720);
        }


        //addGraphic(backgroundImage,-1,HXP.width/2,450);

        //addGraphic(gfx);

    }




}