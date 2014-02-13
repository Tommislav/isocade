package se.isotop.cliffpusher.screens;
import com.haxepunk.Scene;
import com.haxepunk.HXP;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.graphics.Text;
import com.haxepunk.Entity;
import se.isotop.cliffpusher.GameScene;
import flash.events.KeyboardEvent;


/**
 * ...
 * @author ...
 */
class SettingsScreen extends Scene
{

	public function new() 
	{
		super();
	}
	
	override public function begin() 
	{
		
		var splashText:Text = new Text("Settings");
        splashText.color = 0xBB3377;
        splashText.size = 56;
        var splashTextEntity:Entity = new Entity(0,0,splashText);
        splashTextEntity.x = (HXP.width/2)-(splashText.width/2);
        splashTextEntity.y = (HXP.height/3)-(splashText.height/2);
        add(splashTextEntity);
		
		var titleText:Text = new Text("Server IP:");
        titleText.color = 0x000000;
        titleText.size = 24;
        var textEntity:Entity = new Entity(0,0,titleText);
        textEntity.x = (HXP.width/4)-(titleText.width/2);
        textEntity.y = (HXP.height/2)-(titleText.height/2);
        add(textEntity);
		
	}
	
}