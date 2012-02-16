package stax.error;
import haxe.PosInfos;

/**
 * ...
 * @author 0b1kn00b
 */

class AbstractMethodError extends Error {
	
	public function new(?pos:PosInfos) {
		super( "Called abstract method at " + pos );
	}
	
}