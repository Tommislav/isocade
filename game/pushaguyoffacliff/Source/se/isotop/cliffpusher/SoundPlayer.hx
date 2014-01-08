package se.isotop.cliffpusher;
import com.haxepunk.Sfx;
import openfl.Assets;

/**
 * ...
 * @author Tommislav
 */
class SoundPlayer
{
	public static inline var SND_JUMP_ME:String = "assets/jump_me.wav";
	public static inline var SND_JUMP_THEM:String = "assets/jump_them.wav";
	public static inline var SND_SHOOT_ME:String = "assets/shoot2.wav";
	public static inline var SND_SHOOT_ENEMY:String = "assets/shoot.wav";
	public static inline var SND_EXPLOSION:String = "assets/explosion.wav";
	public static inline var SND_HIT_SHIELD:String = "assets/shield.wav";
	public static inline var SND_DIE:String = "assets/die.wav";
	
	public static function play(id:String) {
		
		
		var snd:Sfx = new Sfx(id);
		snd.play();
	}
	
	public function new() 
	{
		
	}
	
}