package se.salomonsson.icade;

/**
 * serialize/deserializes the current controller state and puts it into an integer
 * @author Tommislav
 */
interface ISerializeableReadInput extends IReadInput
{
	function serialize():Int;
	function deserialize(d:Int):Void;
}