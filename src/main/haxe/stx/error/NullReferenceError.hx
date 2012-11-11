package stx.error;

/**
 * ...
 * @author 0b1kn00b
 */
import stx.Error;			using stx.Error;

using Std;

class NullReferenceError extends Error {

	public function new(fieldname: String, ?pos) {
		super( "'$fieldname' is null.".format() , pos );
	}
}