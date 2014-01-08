package se.isotop.cliffpusher;

/**
 * ...
 * @author Tommislav
 */
interface IBullet
{
	function getDamage():Float;
	function getDir():Int;
	function getPlayerId():Int;
	function destroy(withExplosion:Bool=false):Void;
}