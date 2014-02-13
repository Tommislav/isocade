package se.isotop.cliffpusher;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;
import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFormat;
import openfl.Assets;

/**
 * ...
 * @author ...
 */
class IpPart extends Sprite
{
	
	private var _buttonUp:Sprite;
	private var _buttonDown:Sprite;
	private var _text:TextField;
	private var _ipValue:Int;
	private var _textFormat:TextFormat;
	
	public function new(value:Int = 192) 
	{
		super();
		
		var bUp = new Bitmap(Assets.getBitmapData("assets/arrow_up.png"));
		var bDn = new Bitmap(Assets.getBitmapData("assets/arrow_down.png"));
		
		_buttonUp = new Sprite();
		_buttonUp.addChild(bUp);
		
		_buttonDown = new Sprite();
		_buttonDown.addChild(bDn);
		
		_buttonDown.y = 100;
		
		addChild(_buttonUp);
		addChild(_buttonDown);
		
		_textFormat = new TextFormat ();
		_textFormat.size = 36;

		_text = new TextField();
		_text.selectable = false;
		_text.mouseEnabled = false;
		_ipValue = value;
		_text.text = _ipValue + "";
		_text.y = 40;
		_text.x = (_buttonDown.width / 2) - (_buttonDown.width / 2);
		_text.textColor = 0x000000;
		_text.setTextFormat(_textFormat);
		addChild(_text);
		
		
		_buttonUp.addEventListener(MouseEvent.CLICK, onButtonUpClicked);
		_buttonDown.addEventListener(MouseEvent.CLICK, onButtonDownClicked);
	}
	
	private function onButtonUpClicked(event:MouseEvent)
	{
		if (_ipValue < 255)
		{
			_ipValue++;
			_text.text = _ipValue + "";
			_text.setTextFormat(_textFormat);
		}
	}
	
	private function onButtonDownClicked(event:MouseEvent)
	{
		if (_ipValue > 0)
		{
			_ipValue--;
			_text.text = _ipValue + "";
			_text.setTextFormat(_textFormat);
		}
	}
	
	public function GetValue():String
	{
		return Std.string(_ipValue);
	}
	
	public function Destroy()
	{
		_buttonDown.removeEventListener(MouseEvent.CLICK, onButtonDownClicked);
		_buttonUp.removeEventListener(MouseEvent.CLICK, onButtonUpClicked);
	}
	
}