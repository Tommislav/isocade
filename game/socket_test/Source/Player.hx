import flash.display.Sprite;
import flash.display.Bitmap;
import openfl.Assets;
class Player extends Sprite
{
	public var dx:Float;
	public var dy:Float;
	public var collided:Bool;
	
	public function new(x:Float = 0,y:Float = 0)
	{
		super();
		Set(x, y);
		var image = new Bitmap(Assets.getBitmapData("assets/player.png"));
		this.addChild(image);
	}
	
	public function Move(dx:Float, dy:Float)
	{
		this.x += dx;
		this.y += dy;
	}
	
	public function Set(x:Float, y:Float)
	{
		this.x = x;
		this.y = y;
	}
	
	public function Input(keycode:Int)
	{
		switch(Math.abs(keycode))
        {
            case 68: this.dx=keycode>0 ? 1 : 0; // -> RIGHT
            case 65: this.dx=keycode>0 ? -1 : 0; // <- LEFT
            case 87: this.dy=keycode>0 ? -10 : 0; // ^ UP
            case 83: this.dy=keycode>0 ? 1 : 0; // v DOWN
        }
	}
}