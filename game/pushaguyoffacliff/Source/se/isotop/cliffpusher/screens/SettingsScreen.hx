package se.isotop.cliffpusher.screens;
import com.haxepunk.graphics.Image;
import com.haxepunk.Scene;
import com.haxepunk.HXP;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.graphics.Text;
import com.haxepunk.Entity;
import se.isotop.cliffpusher.GameScene;
import flash.events.KeyboardEvent;
import se.isotop.cliffpusher.IpPart;
import se.isotop.cliffpusher.NetworkGameLogic;
import se.isotop.cliffpusher.Server;


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
	private var _saveButton:Entity;
	private var _serverInformation:Server;
	private var _network:NetworkGameLogic;
	
	public function new() 
	{
		super();
	}
	
	override public function begin() 
	{
		_network = new NetworkGameLogic(false);
		_serverInformation = _network.GetServerInformation();
		var serverIpParts = _serverInformation.GetServerIpParts();
		trace("SERVER IP PARTS: " + serverIpParts);
		
		var bgImage:Image = new Image("assets/settings_bg.png");
		var bgEntity = new Entity(0, (HXP.height / 2) - (bgImage.height / 2), bgImage);
		add(bgEntity);
		
		
		var titleText:Text = new Text("Server IP");
        titleText.color = 0x000000;
        titleText.size = 36;
        var textEntity:Entity = new Entity(0,0,titleText);
        textEntity.x = (HXP.width/2)-(titleText.width/2);
        textEntity.y = (HXP.height/2)-(bgImage.height/2) + 20;
        add(textEntity);
		
		var xOffset = 130;

		_ipPart = new IpPart(serverIpParts[0]);
		_ipPart.x = 160;
		_ipPart.y = textEntity.y + 80;
		HXP.stage.addChild(_ipPart);

		_ipPart2 = new IpPart(serverIpParts[1]);
		_ipPart2.x = _ipPart.x + xOffset;
		_ipPart2.y = _ipPart.y;
		HXP.stage.addChild(_ipPart2);
		
		_ipPart3 = new IpPart(serverIpParts[2]);
		_ipPart3.x = _ipPart2.x + xOffset;
		_ipPart3.y = _ipPart.y;
		HXP.stage.addChild(_ipPart3);
		
		_ipPart4 = new IpPart(serverIpParts[3]);
		_ipPart4.x = _ipPart3.x + xOffset;
		_ipPart4.y = _ipPart.y;
		HXP.stage.addChild(_ipPart4);
		
		var buttonImage:Image = new Image("assets/save_button.png");
		_saveButton = new Entity((HXP.width / 2) - (buttonImage.width / 2), (HXP.height / 2) - (buttonImage.height / 2) + (bgImage.height / 2));
		_saveButton.graphic = buttonImage;
		_saveButton.setHitbox(buttonImage.width, buttonImage.height);
		_saveButton.type = "save_button";
		add(_saveButton);
		
		
	}
	
	override public function end() 
	{
		super.end();
		_ipPart.Destroy();
		_ipPart2.Destroy();
		_ipPart3.Destroy();
		_ipPart4.Destroy();
		
		HXP.stage.removeChild(_ipPart);
		HXP.stage.removeChild(_ipPart2);
		HXP.stage.removeChild(_ipPart3);
		HXP.stage.removeChild(_ipPart4);
		
		removeAll();
	}
	
	override public function update() 
	{
		super.update();
		
		if (Input.mouseReleased) {
			
			if (this.collidePoint("save_button", Input.mouseX, Input.mouseY) != null) {
				
				var ipArray:Array<String> = new Array<String>();
				ipArray.push(_ipPart.GetValue());
				ipArray.push(_ipPart2.GetValue());
				ipArray.push(_ipPart3.GetValue());
				ipArray.push(_ipPart4.GetValue());
				
				_serverInformation.SetServerIp(ipArray);
				_network.SaveServerFile(_serverInformation);
				
				HXP.scene = new StartScreen();
			}
        }
	}
	
}