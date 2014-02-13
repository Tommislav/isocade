package se.isotop.cliffpusher.screens;
import com.haxepunk.Scene;
import com.haxepunk.HXP;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.graphics.Text;
import com.haxepunk.Entity;
import se.isotop.cliffpusher.GameScene;
import flash.events.KeyboardEvent;
import se.isotop.cliffpusher.IpPart;


/**
 * ...
 * @author ...
 */
class SettingsScreen extends Scene
{
	private var _ipPart:IpPart;
	private var _ipPart2:IpPart;
	private var _ipPart3:IpPart;
	private var _ipPart4:IpPart;
	
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
		
		var xOffset = 140;
		
		_ipPart = new IpPart(192);
		_ipPart.x = textEntity.x;
		_ipPart.y = textEntity.y + 40;
		HXP.stage.addChild(_ipPart);

		_ipPart2 = new IpPart(168);
		_ipPart2.x = _ipPart.x + xOffset;
		_ipPart2.y = _ipPart.y;
		HXP.stage.addChild(_ipPart2);
		
		_ipPart3 = new IpPart(0);
		_ipPart3.x = _ipPart2.x + xOffset;
		_ipPart3.y = _ipPart.y;
		HXP.stage.addChild(_ipPart3);
		
		_ipPart4 = new IpPart(1);
		_ipPart4.x = _ipPart3.x + xOffset;
		_ipPart4.y = _ipPart.y;
		HXP.stage.addChild(_ipPart4);
	}
	
	override public function end() 
	{
		super.end();
		_ipPart.Destroy();
		_ipPart2.Destroy();
		_ipPart3.Destroy();
		_ipPart4.Destroy();
		
	}
	
}