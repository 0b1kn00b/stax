package stx.core;

/**
 * ...
 * @author 0b1kn00b
 */

interface Initializable {
	public function initialize():Void;
	public var initialized (default, null):Bool;
}