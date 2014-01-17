package se.isotop.cliffpusher;
import com.haxepunk.Entity;
import com.haxepunk.graphics.atlas.TileAtlas;
import com.haxepunk.graphics.Tilemap;
import com.haxepunk.masks.Grid;
import flash.display.BitmapData;
import flash.geom.Point;
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
	
	public var playerSpawnPoint:Point;
	public var enemyPositionList:Array<Point>;
	public var pickupSpawnPointList:Array<Point>;
	public var scoreAboveYPx:Float;
	
	
	private static inline var TYPE_SOLID:Int = 0x000000;
	private static inline var TYPE_ENEMY:Int = 0xff0000;
	private static inline var TYPE_PLAYER_SPAWN_POINT = 0x0000ff;
	private static inline var TYPE_SCORE_LIMIT_Y = 0x00ff00;
	private static inline var TYPE_PICKUP = 0x00ffff;
	
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
		
		playerSpawnPoint = new Point();
		enemyPositionList = new Array();
		pickupSpawnPointList = new Array();
		
		for (y in 0...level.height) {
			for (x in 0...level.width) {
				var px  = level.getPixel(x, y);
				switch (px) {
					case TYPE_SOLID:
						map.setTile(x, y, 10);
						coll.setTile(x, y, true);
						
					case TYPE_ENEMY:
						enemyPositionList.push(new Point(x*tileW, y*tileH));
						
					case TYPE_PLAYER_SPAWN_POINT:
						playerSpawnPoint = new Point(x * tileW, y * tileH);
					
					case TYPE_PICKUP:
						pickupSpawnPointList.push(new Point(x*tileW, y*tileH));
					
					case TYPE_SCORE_LIMIT_Y:
						scoreAboveYPx = y * tileH;
						for (lineX in 0...levelWidthTiles) {
							map.setTile(lineX, y, 15);
						}
				}
			}
		}
		
		this.graphic = map;
		this.mask = coll;
	}
}





