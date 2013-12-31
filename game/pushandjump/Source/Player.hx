import flash.display.Sprite;
import flash.display.Bitmap;
import openfl.Assets;
import se.salomonsson.icade.ICadeKeyCode;
class Player extends Sprite
{
	public var id:Int;
	public var dx:Float;
	public var dy:Float;
	public var collided:Bool;
	public var canJump:Bool = true; // fult och bort
	public var sensors:Array<Point>;
	public var verticalSensors:Array<Point>;
	public var sensorLength:Int;
	public var lastKeyCode:Int;
	public var vx:Float = 0;
	public var acceleration:Float = 0;
	public var maxSpeed:Float = 3;
	public var friction:Float = 0.95;
	
	public function new(x:Float = 0,y:Float = 0, isLocal:Bool)
	{
		super();
		Set(x, y);
		var image = new Bitmap(Assets.getBitmapData("assets/" + (isLocal ? "player.png" : "enemy.png")));
		this.addChild(image);
		
		// sensors
		sensorLength = 8;
		sensors = new Array<Point>();
		// vänster och höger
		sensors.push(new Point(0-sensorLength, 8));
		sensors.push(new Point(64 + sensorLength, 8));
		sensors.push(new Point(0-sensorLength, 56));
		sensors.push(new Point(64 + sensorLength, 56));	
		
		// neråt
		verticalSensors = new Array<Point>();
		
		verticalSensors.push(new Point(0, 64+sensorLength));
		verticalSensors.push(new Point(64, 64+sensorLength));
		/*sensors.push(new Point(0-sensorLength, 64));
		sensors.push(new Point(64+sensorLength, 64));
		
		sensors.push(new Point(32, 64+sensorLength)); // bottom left
		sensors.push(new Point(0, 64+sensorLength)); // bottom middle
		sensors.push(new Point(64, 64+sensorLength)); // bottom right*/
		
	}
	
	// flytta spelaren
	public function Move(dx:Float, dy:Float, dt:Int = 1)
	{
		if (acceleration > 0 && this.dx == 0)
			this.dx = 0.1;
			
		if(Math.abs(this.dx)<maxSpeed)
			this.dx += acceleration;

		
		if (acceleration == 0)
		{
			if (this.dx != 0)
				this.dx *= friction;
		}
		
		this.x += dx;
		this.y += dy;

	}
	
	public function Set(x:Float, y:Float)
	{
		this.x = x;
		this.y = y;
	}
	
	public function SetVelocity(dx:Float, dy:Float)
	{
		this.dx = dx;
		this.dy = dy;
	}
	
	public function Input(keycode:Int)
	{
		/*
		switch(Math.abs(keycode))
        {
            case ICadeKeyCode.RIGHT: this.dx=keycode>0 ? 1 : 0; // -> RIGHT
            case ICadeKeyCode.LEFT: this.dx=keycode>0 ? -1 : 0; // <- LEFT
            case ICadeKeyCode.UP: this.dy=keycode>0 ? -4 : 0; // ^ UP
            case ICadeKeyCode.DOWN: this.dy=keycode>0 ? 1 : 0; // v DOWN
        }
		*/
		
		switch(Math.abs(keycode))
        {
            case ICadeKeyCode.RIGHT: this.acceleration=keycode>0 ? 0.1 : 0; // -> RIGHT
            case ICadeKeyCode.LEFT: this.acceleration=keycode>0 ? -0.1 : 0; // <- LEFT
            case ICadeKeyCode.UP: this.dy=keycode>0 && this.dy==0 ? -5 : 0; // ^ UP
            case ICadeKeyCode.DOWN: this.dy=keycode>0 ? 1 : 0; // v DOWN
        }

	}
}

class Point
{
	public var X:Float;
	public var Y:Float;
	public function new(x:Float,y:Float):Void 
	{
		this.X = x;
		this.Y = y;
	}
}