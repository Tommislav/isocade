package se.isotop.cliffpusher.screens;

import com.haxepunk.Scene;
import com.haxepunk.HXP;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.graphics.Text;
import se.isotop.cliffpusher.screens.StartScreen;
import com.haxepunk.Entity;
import se.isotop.cliffpusher.GameScene;
import flash.events.KeyboardEvent;

class HelpScreen extends Scene {

    public function new() {
        super();
    }

    override public function begin() {
        HXP.screen.color = 0x332222;

        var titleText:Text = new Text("Help Screen");
        titleText.color = 0x0000BB;
        titleText.size = 72;
        var textEntity:Entity = new Entity(0,0,titleText);
        textEntity.x = (HXP.width/2)-(titleText.width/2);
        textEntity.y = 100;
        add(textEntity);

        var controlText:Text = new Text("Controls :\n\nA: Left\nW: Up\nD: Right\n\nJ: Shield\nK: Shoot\nL: Jump");
        controlText.color = 0x000000;
        controlText.size = 24;
        var controlTextEntity:Entity = new Entity(0,0,controlText);
        controlTextEntity.x = (200)-(controlText.width/2);
        controlTextEntity.y = (HXP.height/2)-(controlText.height/2);
        add(controlTextEntity);


        var infoText:Text = new Text("(Press S or ESC to return to start screen)");
        infoText.color = 0x000000;
        infoText.size = 24;
        var infoTextEntity:Entity = new Entity(0,0,infoText);
        infoTextEntity.x = (HXP.width/2)-(infoText.width/2);
        infoTextEntity.y = (HXP.height-50)-(infoText.height);
        add(infoTextEntity);

    }

    override public function update():Void {
        if (Input.check(Key.S) || Input.check(Key.ESCAPE)) {
            HXP.screen.color = 0x222233;
            HXP.scene = new StartScreen();
        }

        if(Input.mouseReleased) {
            HXP.scene = new StartScreen();
        }

    }
}