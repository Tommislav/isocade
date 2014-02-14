package se.isotop.cliffpusher.factories;
import com.haxepunk.graphics.atlas.AtlasData;
import com.haxepunk.graphics.atlas.AtlasRegion;
import com.haxepunk.graphics.atlas.TileAtlas;
import com.haxepunk.graphics.Spritemap;
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
	private var _spriteMap:Spritemap;
	private var _blockRegion:AtlasRegion;
	private var _eyesRegion:AtlasRegion;
	private var _eyes2Region:AtlasRegion;
	private var _shadeRegion:AtlasRegion;
	private var _bodys:Array<AtlasRegion>;
	private var _shields:Array<AtlasRegion>;
	private var _explosionSheet:AtlasRegion;
	private var _scoreRegion:AtlasRegion;
	private var _pickupRegion:AtlasRegion;
	
	private var _bulletRegion:AtlasRegion;
	private var _bulletBigRegion:AtlasRegion;
	
	private var _hudFrame:AtlasRegion;
	private var _hudPowerJump:AtlasRegion;
	private var _hudMine:AtlasRegion;
	
	private var _particle:AtlasRegion;
	
	public static var instance:GraphicsFactory;
	
	public function new() 
	{
		GraphicsFactory.instance = this;
		
		_atlas = AtlasData.getAtlasDataByName("assets/sheet.png", true);
		
		//var tileAtlas:TileAtlas = new TileAtlas("assets/sheet.png", 32, 32);
		//_spriteMap = new Spritemap(tileAtlas, 32, 32, null, "spriteMap");
		
		_bodys = new Array<AtlasRegion>();
		_shields = new Array<AtlasRegion>();

		_bodys.push(_atlas.createRegion(new Rectangle(0,230,60,70), new Point(0, 0)));
		_bodys.push(_atlas.createRegion(new Rectangle(60,230,60,70), new Point(0, 0)));
		_bodys.push(_atlas.createRegion(new Rectangle(120,230,60,70), new Point(0, 0)));
		_bodys.push(_atlas.createRegion(new Rectangle(180,230,60,70), new Point(0, 0)));
		_bodys.push(_atlas.createRegion(new Rectangle(240,230,60,70), new Point(0, 0)));
		
		_shields.push(_atlas.createRegion(new Rectangle(128,0,4,64), new Point(0, 0)));
		_shields.push(_atlas.createRegion(new Rectangle(160,0,4,64), new Point(0, 0)));
		_shields.push(_atlas.createRegion(new Rectangle(192,0,4,64), new Point(0, 0)));
		_shields.push(_atlas.createRegion(new Rectangle(224,0,4,64), new Point(0, 0)));
		_shields.push(_atlas.createRegion(new Rectangle(256,0,4,64), new Point(0, 0)));
		
		_blockRegion = _atlas.createRegion(new Rectangle(0, 64, 32, 32), new Point(0,0));
		_eyesRegion = _atlas.createRegion(new Rectangle(32, 0, 32, 32), new Point(0, 0));
		_eyes2Region = _atlas.createRegion(new Rectangle(64, 0, 32, 32), new Point(0, 0));
		_shadeRegion = _atlas.createRegion(new Rectangle(0, 0, 32, 64), new Point(0, 0));
		
		
		// pickup box
		_pickupRegion = _atlas.createRegion(new Rectangle(32, 64, 32, 32), new Point());
		
		// score limit
		_scoreRegion = _atlas.createRegion(new Rectangle(64, 64, 32, 32), new Point());
		
		_hudFrame = _atlas.createRegion(new Rectangle(128, 64, 64, 64), new Point());
		_hudPowerJump = _atlas.createRegion(new Rectangle(192, 64, 64, 64), new Point());
		_hudMine = _atlas.createRegion(new Rectangle(256, 64, 64, 64), new Point());
		
		var explosion:AtlasData = AtlasData.getAtlasDataByName("assets/explosion.png", true);
		_explosionSheet = explosion.createRegion(new Rectangle(0, 0, explosion.width, explosion.height), new Point());
		
		_particle = _atlas.createRegion(new Rectangle(96, 64, 32, 32), new Point());
		
		_bulletRegion = _atlas.createRegion(new Rectangle(472, 0, 50, 23), new Point(25, 11));
		_bulletBigRegion = _atlas.createRegion(new Rectangle(472,23, 50, 23), new Point(25,11));
		
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
	
	public function getExplosionSheetRegion():AtlasRegion {
		return _explosionSheet;
	}
	
	public function getPickupRegion():AtlasRegion {
		return _pickupRegion;
	}
	
	public function getBulletRegion():AtlasRegion { return _bulletRegion; }
	public function getBulletBigRegion():AtlasRegion { return _bulletBigRegion; }
	
	public function getHudFrame():AtlasRegion { return _hudFrame; }
	public function getHudPowerJump():AtlasRegion { return _hudPowerJump; }
	public function getHudMine():AtlasRegion { return _hudMine; }
	
	//public function getMineTileAtlas():TileAtlas {
		//var t:TileAtlas = new TileAtlas(
	//}
}