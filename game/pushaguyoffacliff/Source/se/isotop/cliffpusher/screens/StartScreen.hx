package se.isotop.cliffpusher.screens;

import com.haxepunk.graphics.atlas.AtlasData;
import flash.geom.Rectangle;
import se.isotop.cliffpusher.model.PlayerModel;
import flash.events.MouseEvent;
import com.haxepunk.graphics.Image;
import com.haxepunk.Scene;
import com.haxepunk.HXP;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.graphics.Text;
import com.haxepunk.Entity;
import se.isotop.cliffpusher.GameScene;
import se.isotop.cliffpusher.Mine;
import se.isotop.cliffpusher.screens.HelpScreen;
import com.haxepunk.utils.Touch;
import flash.events.KeyboardEvent;

class StartScreen extends Scene {

	var mine:Mine;

    private var startButton:Entity;
    private var helpButton:Entity;
	private var settingsButton:Entity;
	
	private var _imgConnect:Image;
	private var _imgConnAnim1:Image;
	private var _imgConnAnim2:Image;
	private var _imgStart:Image;
	private var _imgSettings:Image;
	
	private var _startButtonState:Int = 0; // 0="connect", 1&2="connecting", 3="start"
	private var _connAnimationCounter:Int;


    public function new() {
        super();

    }

    override public function begin() {
        HXP.screen.color = 0x332222;

        trace("HXP screen" + HXP.width);
		
		mine = new Mine(50, 50);
		add(mine);
		
		var buttonAtlas:AtlasData = AtlasData.getAtlasDataByName("assets/buttons.png", true);
		var btnW = 290;
		var btnH = 71;
		
		_imgConnect 	= new Image(buttonAtlas.createRegion(new Rectangle(0, btnH*0, btnW, btnH)));
		_imgConnAnim1 	= new Image(buttonAtlas.createRegion(new Rectangle(0, btnH*1, btnW, btnH)));
		_imgConnAnim2 	= new Image(buttonAtlas.createRegion(new Rectangle(0, btnH*2, btnW, btnH)));
		_imgSettings	= new Image(buttonAtlas.createRegion(new Rectangle(0, btnH*3, btnW, btnH)));
		
		
		
        startButton = new Entity(HXP.width / 2 - btnW / 2, HXP.height / 2, _imgConnect);
        startButton.setHitbox(btnW, btnH);
		startButton.type = "start_button";
        add(startButton);
		
		settingsButton = new Entity(HXP.width - btnW - 50, HXP.height - btnH - 50, _imgSettings);
		settingsButton.setHitbox(btnW, btnH);
		settingsButton.type = "settings_button";
		add(settingsButton);
		
        var splashText:Text = new Text("IsoCade adventures");
        splashText.color = 0xBB3377;
        splashText.size = 56;
        var splashTextEntity:Entity = new Entity(0,0,splashText);
        splashTextEntity.x = (HXP.width/2)-(splashText.width/2);
        splashTextEntity.y = (HXP.height/3)-(splashText.height/2);
        add(splashTextEntity);
    }

    override public function update():Void {
		
		var isConnected:Bool = false;
		
		if (Input.check(Key.X)) {
            HXP.screen.color = 0x222233;
            HXP.scene = new GameScene();
        }
        if (Input.check(Key.H)) {
            HXP.scene = new HelpScreen();
        }

        if (Input.mouseReleased) {
            if (this.collidePoint("start_button", Input.mouseX, Input.mouseY) != null) {
				
				if (_startButtonState == 0) {
					// start connecting...
					_connAnimationCounter = 0;
					_startButtonState = 1;
				}
				if (_startButtonState == 3) { // connected
					HXP.scene = new GameScene();
				}
            }

			
            if(this.collidePoint("help_button",Input.mouseX,Input.mouseY)!= null ) {
                HXP.scene = new HelpScreen();
            }
			
			if (this.collidePoint("settings_button", Input.mouseX, Input.mouseY) != null) {
				HXP.scene = new SettingsScreen();
			}
        }
		
		
		var connected:Bool = false;
		if (_startButtonState == 1 || _startButtonState == 2) {
				if (--_connAnimationCounter <= 0) {
					startButton.graphic = (_startButtonState == 1) ? _imgConnAnim1 : _imgConnAnim2;
					_startButtonState = (_startButtonState == 1) ? 2:1;
					_connAnimationCounter = 30;
				}
				
				if (connected) {
					startButton.graphic = _imgStart;
					_startButtonState = 3;
				}
			}
		
		mine.update();
		super.update();

    }


}