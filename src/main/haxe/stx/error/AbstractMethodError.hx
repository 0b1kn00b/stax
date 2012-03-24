package stx.error;
import haxe.PosInfos;

/**
 * ...
 * @author 0b1kn00b
 */
import haxe.PosInfos;

class AbstractMethodError extends Error {
	
	public function new(?pos:PosInfos) {
		super( "Called abstract method", pos );
	}
}