package se.isotop.cliffpusher.screens;

import flash.events.MouseEvent;
import com.haxepunk.graphics.Image;
import com.haxepunk.Scene;
import com.haxepunk.HXP;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.graphics.Text;
import com.haxepunk.Entity;
import se.isotop.cliffpusher.GameScene;
import se.isotop.cliffpusher.screens.HelpScreen;
import com.haxepunk.utils.Touch;
import flash.events.KeyboardEvent;

class StartScreen extends Scene {
    var startButton:Entity;
    var helpButton:Entity;
	var settingsButton:Entity;

    public function new() {
        super();

    }

    override public function begin() {
        HXP.screen.color = 0x332222;

        trace("HXP screen" + HXP.width);

//        HXP.stage.addEventListener(MouseEvent.CLICK, onClick);

        var startButtonImage:Image = new Image("assets/start_button.png");
        startButton = new Entity(HXP.width/2-startButtonImage.width-50,HXP.height/2,startButtonImage);
        startButton.type = "start_button";
        startButton.setHitbox(startButtonImage.width,startButtonImage.height);
        //addGraphic(new Image("start_button.png"));
        add(startButton);

        var helpButtonImage:Image = new Image("assets/help_button.png");
        helpButton = new Entity(HXP.width/2+50,HXP.height/2,helpButtonImage);
        helpButton.setHitbox(helpButtonImage.width,helpButtonImage.height);
        helpButton.type = "help_button";

        //addGraphic(new Image("help_button.png"));

        add(helpButton);
		
		
		var settingsButtonImage:Image = new Image("assets/start_button.png");
		settingsButton = new Entity(HXP.width - settingsButtonImage.width - 50, HXP.height - settingsButtonImage.height - 50, settingsButtonImage);
		settingsButton.setHitbox(settingsButtonImage.width, settingsButtonImage.height);
		settingsButton.type = "settings_button";
		
		add(settingsButton);



//        var titleText:Text = new Text("Press X to Start\nPress H for Help screen");
//        titleText.color = 0x000000;
//        titleText.size = 24;
//        var textEntity:Entity = new Entity(0,0,titleText);
//        textEntity.x = (HXP.width/2)-(titleText.width/2);
//        textEntity.y = (HXP.height/2)-(titleText.height/2);
//        add(textEntity);
//
        var splashText:Text = new Text("IsoCade adventures");
        splashText.color = 0xBB3377;
        splashText.size = 56;
        var splashTextEntity:Entity = new Entity(0,0,splashText);
        splashTextEntity.x = (HXP.width/2)-(splashText.width/2);
        splashTextEntity.y = (HXP.height/3)-(splashText.height/2);
        add(splashTextEntity);

    }

    private function onClick(e:MouseEvent) {
        var clickX = e.stageX;
        var clickY = e.stageY;




        trace("Clicked: " + clickX + " : " +clickY );

    }


    override public function update():Void {
        if (Input.check(Key.X)) {
            HXP.screen.color = 0x222233;
            HXP.scene = new GameScene();
        }
        if (Input.check(Key.H)) {

            HXP.scene = new HelpScreen();
        }

        if (Input.mouseReleased) {

            var e:Entity = this.collidePoint("start_button",Input.mouseX,Input.mouseY);

            trace(e);

            if(e != null) {
                HXP.scene = new GameScene();
            }

            if(this.collidePoint("help_button",Input.mouseX,Input.mouseY)!= null ) {
                HXP.scene = new HelpScreen();
            }
			
			if (this.collidePoint("settings_button", Input.mouseX, Input.mouseY) != null) {
				HXP.scene = new SettingsScreen();
			}
        }

    }


}