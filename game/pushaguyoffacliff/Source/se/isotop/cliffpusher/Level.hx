package se.isotop.cliffpusher;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Tilemap;

/**
 * ...
 * @author Tommislav
 */
class Level extends Entity
{
	private var _tileMap:Tilemap;

	
	public function new(gfxFactory:GraphicsFactory) 
	{
		super(0,0);
		type = "solid";
		_tileMap = new Tilemap(gfxFactory.getGroundTile(), 1024, 768, 32, 32);
		
		var tilesX = 32;
		var tilesY = 24;
		
		for (i in 0...100) {
			_tileMap.setTile(Std.int(Math.random() * tilesX), Std.int(Math.random() * tilesY), 0);
		}
		
		graphic = _tileMap;
	}
	
}