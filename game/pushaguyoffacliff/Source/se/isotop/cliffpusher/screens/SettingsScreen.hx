package se.isotop.cliffpusher.screens;
import flash.events.MouseEvent;
import se.isotop.cliffpusher.model.Socket;
import com.haxepunk.graphics.Image;
import com.haxepunk.Scene;
import com.haxepunk.HXP;
import com.haxepunk.utils.Input;
import com.haxepunk.graphics.Text;
import com.haxepunk.Entity;
import se.isotop.cliffpusher.IpPart;
import se.isotop.cliffpusher.NetworkGameLogic;
import se.isotop.cliffpusher.model.Server;
import flash.display.Sprite;
import flash.display.Bitmap;
import openfl.Assets;


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
	private var _saveButton:Sprite;
	private var _serverInformation:Server;
	private var _network:NetworkGameLogic;
    private var _socket:Socket;

	
	public function new() 
	{
		super();
        trace("Settings (new): " + HXP.width + ":" + HXP.height);
        trace("Settings (new) screen: " + HXP.screen.width + ":" + HXP.screen.height);
	}
	
	override public function begin() 
	{
        _socket = Socket.instance;

        trace("Settings (begin): " + HXP.width + ":" + HXP.height);
        trace("Settings (begin) screen: " + HXP.screen.width + ":" + HXP.screen.height);
		_serverInformation = _socket.getServerInformation();
		var serverIpParts = _serverInformation.GetServerIpParts();
		trace("SERVER IP PARTS: " + serverIpParts);
		
		var bgImage:Image = new Image("assets/settings_bg.png");
		var bgEntity = new Entity(0, (HXP.height / 2) - (bgImage.height / 2), bgImage);
		add(bgEntity);
		
		var titleText:Text = new Text("Server IP");
        titleText.color = 0x000000;
        titleText.size = 36;
        var textEntity:Entity = new Entity(0,0,titleText);

        textEntity.x = (HXP.screen.width/2)-(titleText.width/2);
        textEntity.y = (HXP.screen.height/2)-(bgImage.height/2) + 20;
        add(textEntity);
		
		var xOffset = HXP.screen.width/10;
        var horizCenter  = HXP.screen.width/2;

		_ipPart = new IpPart(serverIpParts[0]);
		_ipPart.x = horizCenter-xOffset*3-_ipPart.width/2;
		_ipPart.y = textEntity.y + 80;
		HXP.stage.addChild(_ipPart);

		_ipPart2 = new IpPart(serverIpParts[1]);
		_ipPart2.x = horizCenter-xOffset-_ipPart.width/2;
		_ipPart2.y = _ipPart.y;
		HXP.stage.addChild(_ipPart2);
		
		_ipPart3 = new IpPart(serverIpParts[2]);
		_ipPart3.x = horizCenter+xOffset-_ipPart.width/2;
		_ipPart3.y = _ipPart.y;
		HXP.stage.addChild(_ipPart3);
		
		_ipPart4 = new IpPart(serverIpParts[3]);
		_ipPart4.x = horizCenter+xOffset*3-_ipPart.width/2;
		_ipPart4.y = _ipPart.y;
		HXP.stage.addChild(_ipPart4);
		
		var buttonImage:Image = new Image("assets/save_button.png");

        var bSave = new Bitmap(Assets.getBitmapData("assets/save_button.png"));

        _saveButton = new Sprite();
        _saveButton.addChild(bSave);


        _saveButton.addEventListener(MouseEvent.CLICK, onSaveClicked);
        _saveButton.x = HXP.screen.width/2 - _saveButton.width/2;
        _saveButton.y = HXP.screen.height - _saveButton.height - 100;


		HXP.stage.addChild(_saveButton);
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


        _saveButton.removeEventListener(MouseEvent.CLICK, onSaveClicked);
        HXP.stage.removeChild(_saveButton);


        removeAll();
	}
	
	override public function update() 
	{
		super.update();

	}

    private function onSaveClicked(event:MouseEvent) {
        var ipArray:Array<String> = new Array<String>();
        ipArray.push(_ipPart.GetValue());
        ipArray.push(_ipPart2.GetValue());
        ipArray.push(_ipPart3.GetValue());
        ipArray.push(_ipPart4.GetValue());

        _serverInformation.SetServerIp(ipArray);
        _socket.saveServerFile(_serverInformation);

        HXP.scene = new StartScreen();

    }


}