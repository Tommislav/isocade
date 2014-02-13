package se.isotop.cliffpusher.screens;
import com.haxepunk.Scene;
import se.isotop.cliffpusher.TextField;

/**
 * ...
 * @author ...
 */
class SettingsScreen extends Scene
{

	public function new() 
	{
		super();
	}
	
	override public function begin() 
	{
		add(new TextField(100, 100, "Settings screen"));
	}
	
}