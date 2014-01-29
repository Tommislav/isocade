package se.isotop.cliffpusher.events;

import flash.events.Event;

/**
 * ...
 * @author Tommislav
 */
class SoundEvent extends Event
{

	public static inline var PLAY_SOUND:String = "SoundEvent.PLAY_SOUND";
	public var soundId = "";
	
	public function new(type:String, soundId:String) 
	{
		super(type, false, false);
		this.soundId = soundId;
	}
	
	override public function clone():Event 
	{
		return new SoundEvent(this.type, this.soundId);
	}
	
}