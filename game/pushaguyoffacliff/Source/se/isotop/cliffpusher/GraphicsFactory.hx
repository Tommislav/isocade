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
	private var _eyes2Region:AtlasRegion;
	private var _shadeRegion:AtlasRegion;
	private var _bodys:Array<AtlasRegion>;
	private var _shields:Array<AtlasRegion>;
	
	public function new() 
	{
		_atlas = AtlasData.getAtlasDataByName("assets/sheet.png", true);
		
		_bodys = new Array<AtlasRegion>();
		_shields = new Array<AtlasRegion>();
		
		_bodys.push(_atlas.createRegion(new Rectangle(128,0,32,64), new Point(0, 0)));
		_bodys.push(_atlas.createRegion(new Rectangle(160,0,32,64), new Point(0, 0)));
		_bodys.push(_atlas.createRegion(new Rectangle(192,0,32,64), new Point(0, 0)));
		_bodys.push(_atlas.createRegion(new Rectangle(224,0,32,64), new Point(0, 0)));
		_bodys.push(_atlas.createRegion(new Rectangle(256,0,32,64), new Point(0, 0)));
		
		_shields.push(_atlas.createRegion(new Rectangle(128,0,4,64), new Point(0, 0)));
		_shields.push(_atlas.createRegion(new Rectangle(160,0,4,64), new Point(0, 0)));
		_shields.push(_atlas.createRegion(new Rectangle(192,0,4,64), new Point(0, 0)));
		_shields.push(_atlas.createRegion(new Rectangle(224,0,4,64), new Point(0, 0)));
		_shields.push(_atlas.createRegion(new Rectangle(256,0,4,64), new Point(0, 0)));
		
		_blockRegion = _atlas.createRegion(new Rectangle(0, 64, 32, 32), new Point(0,0));
		_eyesRegion = _atlas.createRegion(new Rectangle(32, 0, 32, 32), new Point(0, 0));
		_eyes2Region = _atlas.createRegion(new Rectangle(64, 0, 32, 32), new Point(0, 0));
		_shadeRegion = _atlas.createRegion(new Rectangle(0, 0, 32, 64), new Point(0, 0));
	}
	
	public function getBody(index:Int):AtlasRegion {
		return _bodys[index];
	}
	
	public function getShield(index:Int):AtlasRegion {
		return _shields[index];
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
	
	public function getClosedEyes():AtlasRegion
	{
		return _eyes2Region;
	}
}