package se.isotop.cliffpusher;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;
import flash.Lib;
import se.isotop.cliffpusher.enums.ExtraWeaponType;
import se.isotop.cliffpusher.events.ExtraWeaponEvent;
import se.isotop.cliffpusher.factories.GraphicsFactory;
import se.isotop.haxepunk.Eventity;

/**
 * ...
 * @author Tommislav
 */
class WpnHUD extends Eventity
{
	private var _hudMine:Image;
	private var _hudDecoy:Image;
	private var _num:Text;
	
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
		
		followCamera = true;
		
		active = false; // no update loop
		layer = HXP.BASELAYER - 1; // render on top
		
		this.graphic = gList;
		
		nothing();
		setNumber(-1);
		
		addEventListener(ExtraWeaponEvent.CHANGE, onNewExtraWeapon);
	}
	
	private function onNewExtraWeapon(e:ExtraWeaponEvent):Void 
	{
		switch(e.extraWeaponType) {
			case ExtraWeaponType.NONE:
				nothing();
			case ExtraWeaponType.MINE:
				mine();
			case ExtraWeaponType.DECOY:
				decoy();
		}
		
		setNumber(e.num);
	}
	
	public function setNumber(v:Int) {
		if (v >= 0) {
			_num.text = "x" + v;
		} else {
			_num.text = "";
		}
		
		
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