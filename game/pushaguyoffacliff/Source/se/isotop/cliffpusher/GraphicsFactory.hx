package se.isotop.cliffpusher;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;
import openfl.Assets;

/**
 * ...
 * @author Tommislav
 */
class GraphicsFactory
{
	private var _sheet:BitmapData;
	private var _p:Point;
	
	public function new() 
	{
		_sheet = Assets.getBitmapData("assets/sheet.png");
		_p = new Point(0, 0);
	}
	
	public function getEyes():BitmapData {
		return getPartFromSheet(32, 32, new Rectangle(32, 0, 32, 32));
	}
	
	public function getShade():BitmapData {
		return getPartFromSheet(32, 64, new Rectangle(0,0,32,64));
	}
	
	public function getGroundTile():BitmapData {
		return getPartFromSheet(32,32, new Rectangle(0,64,32,32));
	}
	
	private function getPartFromSheet(w:Int, h:Int, r:Rectangle) {
		var bd = new BitmapData(w, h, true);
		bd.copyPixels(_sheet, r, _p );
		return bd;
	}
}