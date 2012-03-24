package stx.error;
import haxe.PosInfos;

/**
 * ...
 * @author 0b1kn00b
 */

class OutOfBoundsError extends Error {

	public function new(?pos:PosInfos) {
		super( "Index out of bounds at " + pos , pos );
	}
}