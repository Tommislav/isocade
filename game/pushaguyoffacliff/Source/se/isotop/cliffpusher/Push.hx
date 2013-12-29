package se.isotop.cliffpusher;

import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;
import com.haxepunk.Mask;
import com.haxepunk.Tween.CompleteCallback;
import com.haxepunk.Tween.TweenType;
import com.haxepunk.tweens.misc.MultiVarTween;
import com.haxepunk.tweens.misc.VarTween;
import com.haxepunk.utils.Ease;
import com.haxepunk.utils.Ease.EaseFunction;

/**
 * ...
 * @author Tommislav
 */
class Push extends Entity
{
	private var _dir:Int;
	private var _playerId:Int;
	private var _image:Image;
	
	public function new(posX:Float, y:Float, dir:Int, fromPlayer:Int ) 
	{
		super(posX, y);
		_dir = dir;
		_playerId = fromPlayer;
		
		_image = Image.createRect(16, 32, 0x00fff9);
		
		this.graphic = _image;
		var t:VarTween = new VarTween( onDone, TweenType.OneShot );
		//t.tween(this, "x", posX + 100 * _dir, 1, Ease.sineOut);
		t.tween(_image, "alpha", 0, 1, Ease.sineOut);
	}
	
	public function onDone(d:Dynamic):Void {
		scene.remove(this);
	}
	
}