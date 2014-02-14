package se.isotop.cliffpusher.events;

import com.haxepunk.Entity;
import flash.events.Event;
import se.isotop.cliffpusher.enums.ExtraWeaponType;

/**
 * ...
 * @author Tommislav
 */
class ExtraWeaponEvent extends Event
{

	public static inline var CHANGE:String = "ExtraWeaponEvent::CHANGE";
	public static inline var FIRE:String = "ExtraWeaponEvent::FIRE";
	public static inline var NUM_CHANGE:String = "ExtraWeaponEvent::NUM_CHANGE";
	
	public var from:Entity;
	public var extraWeaponType:ExtraWeaponType;
	public var angle:Float;
	public var num:Int;
	
	public function new(type:String, from:Entity, extraWeaponType:ExtraWeaponType, angle:Float, num:Int=0) 
	{
		super(type);
		this.from = from;
		this.extraWeaponType = extraWeaponType;
		this.angle = angle;
		this.num = num;
	}
	
	override public function clone():Event { return new ExtraWeaponEvent(type, from, extraWeaponType, angle); }
}