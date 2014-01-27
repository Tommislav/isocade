package se.isotop.cliffpusher.events;

import flash.events.Event;

/**
 * ...
 * @author Tommislav
 */
class ShootBulletEvent extends Event
{

	public static inline var SHOOT_BULLET:String = "SHOOT_BULLET";
	public var playerId:Int;
	public var bulletType:String;
	public var centerX:Float;
	public var centerY:Float;
	public var angle:Float;
	
	public function new(type:String, playerId:Int, bulletType:String, centerX:Float, centerY:Float, angle:Float) 
	{
		super(type);
		this.playerId = playerId;
		this.bulletType = bulletType;
		this.centerX = centerX;
		this.centerY = centerY;
		this.angle = angle;
	}
	
	override public function clone():Event { return new ShootBulletEvent(type, playerId, bulletType, centerX, centerY, angle); }
}