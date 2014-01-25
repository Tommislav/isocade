package se.isotop.cliffpusher;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;
import flash.Lib;

/**
 * ...
 * @author Tommislav
 */
class WpnHUD extends Entity
{
	private var _hudMine:Image;
	private var _hudDecoy:Image;
	private var _num:Text;
	private var _score:Text;
	
	public function new() 
	{
		var centerX = Lib.current.stage.stageWidth / 2 - 32;
		super(centerX, 16);
		
		_hudMine = new Image(GraphicsFactory.instance.getHudMine());
		_hudDecoy = new Image(GraphicsFactory.instance.getHudDecoy());
		
		var options:TextOptions = {};
		options.color = 0x000000;
		options.size = 20;
		
		_num = new Text("", 4, 42, 32, 32, options);
		
		var gList:Graphiclist = new Graphiclist();
		gList.add(new Image(GraphicsFactory.instance.getHudFrame()));
		gList.add(_hudMine);
		gList.add(_hudDecoy);
		gList.add(_num);
		
		var scoreOpt:TextOptions = { };
		scoreOpt.color = 0x000000;
		scoreOpt.size =  18;
		_score = new Text("Score", 10, 10, 300, 200, scoreOpt);
		gList.add(_score);
		
		followCamera = true;
		
		active = false; // no update loop
		layer = HXP.BASELAYER - 1; // render on top
		
		this.graphic = gList;
		
		mine();
		setNumber(4);
	}
	
	public function setNumber(v:Int) {
		_num.text = "x" + v;
	}
	
	public function nothing() {
		_hudMine.visible = _hudDecoy.visible = false;
	}
	
	public function mine() {
		nothing();
		_hudMine.visible = true;
	}
	
	public function decoy() {
		nothing();
		_hudDecoy.visible = true;
	}
}