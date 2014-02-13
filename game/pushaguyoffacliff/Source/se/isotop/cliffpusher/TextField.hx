package se.isotop.cliffpusher;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Text;
import com.haxepunk.utils.Input;

/**
 * ...
 * @author ...
 */
class TextField extends Entity
{
	private var _text:String = "";
	private var textGraphic:Text;
	private var fontSize:Int;
	
	public function new(x:Int=0, y:Int=0, text:String="", fontSize:Int=32)  
	{
		super(x, y);
		_text = text;
		this.fontSize = fontSize;
		textGraphic = new Text(this._text, 0, 0, { size: this.fontSize, color: 0x666666 } );
		graphic = textGraphic;
	}

	public function get_text():String
	{
		return _text;
	}
	 
	public function set_text(value:String)
	{
		_text = value;
		textGraphic.text = value;
	}
	
	override public function update():Void 
	{
		super.update();
		
		if (Input.keyString != "")
		{
			_text += Input.keyString;
			Input.keyString = "";
		}
	}
	
}