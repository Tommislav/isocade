import flash.display.Bitmap;
import flash.display.Sprite;
import openfl.Assets;
class Tile extends Sprite
{
	public var Gravity:Bool;

	public function new(x:Int,y:Int,tileName:String) 
	{
		super();
		this.x = x;
		this.y = y;
		var image = new Bitmap(Assets.getBitmapData("assets/" + tileName));
		this.addChild(image);
		
	}
}