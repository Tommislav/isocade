package se.isotop.cliffpusher;
import com.haxepunk.Sfx;
import openfl.Assets;
import se.isotop.cliffpusher.events.SoundEvent;
import se.isotop.haxepunk.Eventity;

/**
 * ...
 * @author Tommislav
 */
class SoundPlayer extends Eventity
{
	
	public function new() {
		super();
		addEventListener(SoundEvent.PLAY_SOUND, onPlaySound);
	}
	
	private function onPlaySound(e:SoundEvent):Void 
	{
		var snd:Sfx = new Sfx(e.soundId);
		snd.play();
	}
	
}