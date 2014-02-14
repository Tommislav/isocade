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
	private var _hudPowerjump:Image;
	private var _num:Text;
	
	public function new() 
	{
		var centerX = HXP.screen.width / 2 - 32;
		super(centerX, 16);
		
		_hudMine = new Image(GraphicsFactory.instance.getHudMine());
		_hudPowerjump = new Image(GraphicsFactory.instance.getHudPowerJump());
		
		var options:TextOptions = {};
		options.color = 0x000000;
		options.size = 20;
		
		_num = new Text("", 4, 42, 64, 32, options);
		
		var gList:Graphiclist = new Graphiclist();
		gList.add(new Image(GraphicsFactory.instance.getHudFrame()));
		gList.add(_hudMine);
		gList.add(_hudPowerjump);
		gList.add(_num);
		
		followCamera = true;
		
		active = false; // no update loop
		layer = HXP.BASELAYER - 1; // render on top
		
		this.graphic = gList;
		
		nothing();
		setNumber(-1);
		
		addEventListener(ExtraWeaponEvent.CHANGE, onNewExtraWeapon);
		addEventListener(ExtraWeaponEvent.NUM_CHANGE, onNumChange);
	}
	
	override public function removed():Void 
	{
		super.removed();
		removeEventListener(ExtraWeaponEvent.CHANGE, onNewExtraWeapon);
		removeEventListener(ExtraWeaponEvent.NUM_CHANGE, onNumChange);
	}
	
	private function onNumChange(e:ExtraWeaponEvent):Void 
	{
		setNumber(e.num);
	}
	
	private function onNewExtraWeapon(e:ExtraWeaponEvent):Void 
	{
		switch(e.extraWeaponType) {
			case ExtraWeaponType.NONE:
				nothing();
			case ExtraWeaponType.MINE:
				mine();
			case ExtraWeaponType.DECOY:
				mine();
			case ExtraWeaponType.POWER_JUMP:
				powerjump();
			case ExtraWeaponType.LONGER_SHOTS:
				mine();
		}
		
		setNumber(e.num);
	}
	
	
	
	public function setNumber(v:Int) {
		if (v >= 0) {
			_num.text = v + " s";
		} else {
			_num.text = "";
		}
		
		
	}
	
	public function nothing() {
		_hudMine.visible = _hudPowerjump.visible = false;
	}
	
	public function mine() {
		nothing();
		_hudMine.visible = true;
	}
	
	public function powerjump() {
		nothing();
		_hudPowerjump.visible = true;
	}
}