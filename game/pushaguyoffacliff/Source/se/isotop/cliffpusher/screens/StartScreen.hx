package se.isotop.cliffpusher.screens;

import com.haxepunk.Scene;
import com.haxepunk.HXP;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.graphics.Text;
import com.haxepunk.Entity;
import se.isotop.cliffpusher.GameScene;
import flash.events.KeyboardEvent;

class StartScreen extends Scene {
	
    public function new() {
        super();
    }

    override public function begin() {
        HXP.screen.color = 0x332222;

        trace("HXP screen" + HXP.width);

        var titleText:Text = new Text("Press X to Start");
        titleText.color = 0x000000;
        titleText.size = 24;
        var textEntity:Entity = new Entity(0,0,titleText);
        textEntity.x = (HXP.width/2)-(titleText.width/2);
        textEntity.y = (HXP.height/2)-(titleText.height/2);
        add(textEntity);

        var splashText:Text = new Text("IsoCade adventures");
        splashText.color = 0xBB3377;
        splashText.size = 56;
        var splashTextEntity:Entity = new Entity(0,0,splashText);
        splashTextEntity.x = (HXP.width/2)-(splashText.width/2);
        splashTextEntity.y = (HXP.height/3)-(splashText.height/2);
        add(splashTextEntity);

    }

    override public function update():Void {
        if (Input.check(Key.X)) {
            HXP.screen.color = 0x222233;
            HXP.scene = new GameScene();
        }
    }
}