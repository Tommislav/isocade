package se.isotop.cliffpusher;
import com.haxepunk.graphics.prototype.Rect;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.Lib;
import openfl.Assets;

/**
 * ...
 * @author Tommislav
 */
class CliffAssets
{
	private static var _sheet:BitmapData;// = Assets.getBitmapData("assets/sheet.png");
	
	public static function getEyes():Bitmap {
		var image = new Bitmap(Assets.getBitmapData("assets/player.png"));
		return image;
		//var sheet = Assets.getBitmapData("assets/my_sheet.png");
		
		//var bd = new BitmapData(32, 32, true);
		//sheet.copyPixels(bd, new Rectangle(32, 0, 32, 32), new Point(0, 0));
		//var bmp = new Bitmap(bd);
		//return bmp;
	}
	
}