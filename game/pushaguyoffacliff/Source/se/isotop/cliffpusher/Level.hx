package se.isotop.cliffpusher;
import com.haxepunk.Entity;
import com.haxepunk.graphics.atlas.TileAtlas;
import com.haxepunk.graphics.Tilemap;
import com.haxepunk.masks.Grid;
import flash.display.BitmapData;
import openfl.Assets;

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
		type = "solid";
		
		
		var level:BitmapData = Assets.getBitmapData("assets/level0.png");
		
		levelWidthTiles = level.width;
		levelWidthPx = level.width * 32;
		levelHeightTiles = level.height;
		levelHeightPx = level.height * 32;
		tileW = tileH = 32;
		
		var atlas:TileAtlas = new TileAtlas("assets/sheet.png", 32, 32);
		var map:Tilemap = new Tilemap(atlas, levelWidthPx, levelHeightPx, 32, 32, 0, 0);
		var coll:Grid = new Grid(levelWidthPx, levelHeightPx, 32, 32);
		
		for (y in 0...level.height) {
			for (x in 0...level.width) {
				if (level.getPixel(x, y) == 0) {
					map.setTile(x, y, 10);
					coll.setTile(x, y, true);
				}
			}
		}
		
		this.graphic = map;
		this.mask = coll;
	}
}





