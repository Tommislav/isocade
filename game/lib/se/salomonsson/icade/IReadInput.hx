package se.salomonsson.icade;

/**
 * Should also have add/remove eventListener...
 * @author Tommislav
 */
interface IReadInput
{
	function getDegrees():Float;
	function getKeyIsDown(keyCode:Int):Bool;
}