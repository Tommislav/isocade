package se.isotop.haxepunk;
import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.Mask;
import flash.events.Event;
import flash.events.EventDispatcher;

/**
 * ...
 * @author Tommislav
 */
class Eventity extends Entity
{
	private static var _eventDispatcher:EventDispatcher;

	public function new(x:Float=0, y:Float=0, graphic:Graphic=null, mask:Mask=null) 
	{
		super(x, y, graphic, mask);
		if (_eventDispatcher == null) {
			_eventDispatcher = new EventDispatcher();
		}
	}
	
	
	public function addEventListener(type:String, listener:Dynamic -> Void, useCapture:Bool = false, priority:Int = 0, useWeakReference:Bool = false):Void {
		_eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
	}
	
	public function dispatchEvent(event : Event):Bool {
		return _eventDispatcher.dispatchEvent(event);
	}
	
	public function removeEventListener(type:String, listener:Dynamic -> Void, useCapture:Bool = false):Void {
		_eventDispatcher.removeEventListener(type, listener, useCapture);
	}
	
}