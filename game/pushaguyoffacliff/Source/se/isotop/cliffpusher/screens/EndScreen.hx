package se.isotop.cliffpusher.screens;

import flash.events.MouseEvent;
import openfl.Assets;
import flash.display.Bitmap;
import flash.display.Sprite;
import se.isotop.cliffpusher.model.PlayerModel;
import se.isotop.cliffpusher.model.PlayerInfo;
import se.isotop.gamesocket.GamePacket;
import com.haxepunk.Graphic;
import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Text;
import com.haxepunk.graphics.Image;

import com.haxepunk.Scene;
import se.isotop.cliffpusher.PlayerGraphics;
import se.isotop.cliffpusher.Score;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;


/**
 * ...
 * @author Tommislav
 */
class EndScreen extends Scene
{

    private var _scores:Array<Score>;
    private var _playerModel:PlayerModel;

    private var _restartButton:Sprite;

	public function new(scores:Array<Score>)
	{
		super();
        _scores = scores;
        _playerModel = PlayerModel.instance;
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

            var info:PlayerInfo = _playerModel.getPlayer(_scores[0].playerId);
            var player1:Graphic = new PlayerGraphics(info.color);
            addGraphic(player1,0,HXP.width/2-20,420);
        }
        if (_scores.length > 1) {
            var info:PlayerInfo = _playerModel.getPlayer(_scores[1].playerId);
            var player1:Graphic = new PlayerGraphics(info.color);
            addGraphic(player1,0,HXP.width/2-200,470);
        }

        if (_scores.length > 2) {
            var info:PlayerInfo = _playerModel.getPlayer(_scores[2].playerId);
            var player1:Graphic = new PlayerGraphics(info.color);
            addGraphic(player1,0,HXP.width/2+170,470);
        }

        if (_scores.length > 3) {
            var info:PlayerInfo = _playerModel.getPlayer(_scores[3].playerId);
            var player1:Graphic = new PlayerGraphics(info.color);
            addGraphic(player1,0,HXP.width/2-100,720);
        }

        if (_scores.length > 4) {
            var info:PlayerInfo = _playerModel.getPlayer(_scores[4].playerId);
            var player1:Graphic = new PlayerGraphics(info.color);
            addGraphic(player1,0,HXP.width/2-10,720);
        }

        if (_scores.length > 5) {
            var info:PlayerInfo = _playerModel.getPlayer(_scores[5].playerId);
            var player1:Graphic = new PlayerGraphics(info.color);
            addGraphic(player1,0,HXP.width/2+80,720);
        }
        //addGraphic(backgroundImage,-1,HXP.width/2,450);

        //addGraphic(gfx);

        var bRestart = new Bitmap(Assets.getBitmapData("assets/restart_button.png"));
        _restartButton = new Sprite();
        _restartButton.addChild(bRestart);
        _restartButton.x = HXP.screen.width/2 - _restartButton.width/2;
        _restartButton.y = HXP.height - _restartButton.height -100;
        _restartButton.addEventListener(MouseEvent.CLICK, onRestartClicked);
        HXP.stage.addChild(_restartButton);
        
    }

    override public function update()
    {
        super.update();

        if (Input.check(Key.S)) {
            HXP.scene = new StartScreen();
        }


        if (Input.mouseReleased) {

            if (this.collidePoint("restart_button", Input.mouseX, Input.mouseY) != null) {

                HXP.scene = new StartScreen();
            }
        }
    }
    
    override public function end()
    {
        super.end();

        _restartButton.removeEventListener(MouseEvent.CLICK, onRestartClicked);

        HXP.stage.removeChild(_restartButton);


        removeAll();
    }

    private function onRestartClicked(event:MouseEvent) {
        HXP.scene = new StartScreen();
    }

}