package se.isotop.cliffpusher;
import com.haxepunk.graphics.atlas.AtlasData;
import com.haxepunk.graphics.atlas.AtlasRegion;
import flash.geom.Point;
import flash.geom.Rectangle;
import openfl.Assets;

/**
 * ...
 * @author Tommislav
 */
class GraphicsFactory
{	
	private var _atlas:AtlasData;
	private var _blockRegion:AtlasRegion;
	private var _eyesRegion:AtlasRegion;
	private var _shadeRegion:AtlasRegion;

	
	public function new() 
	{
		_atlas = AtlasData.getAtlasDataByName("assets/sheet.png", true);
		_blockRegion = _atlas.createRegion(new Rectangle(0, 64, 32, 32), new Point(0,0));
		_eyesRegion = _atlas.createRegion(new Rectangle(32, 0, 32, 32), new Point(0,0));
		_shadeRegion = _atlas.createRegion(new Rectangle(0, 0, 32, 64), new Point(0,0));
	}
	
	public function getEyes():AtlasRegion {
		return _eyesRegion;
	}
	
	public function getShade():AtlasRegion {
		return _shadeRegion;
	}
	
	public function getGroundTile():AtlasRegion {
		return _blockRegion;
	}
}