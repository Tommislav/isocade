package se.isotop.cliffpusher;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Tilemap;

/**
 * ...
 * @author Tommislav
 */
class Level extends Entity
{
	public static inline var NAME = "Level";
	
	public var levelWidthTiles:Int;
	public var levelHeightTiles:Int;
	public var levelWidthPx:Int;
	public var levelHeightPx:Int;
	public var tileW:Int;
	public var tileH:Int;
	
	public function new() 
	{
		super();
		name = NAME;
	}
}