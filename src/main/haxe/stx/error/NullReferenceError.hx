package stx.error;

/**
 * ...
 * @author 0b1kn00b
 */
import stx.error.Error;			using stx.error.Error;

class NullReferenceError extends Error {

	public function new(fieldname: String, ?pos) {
		super( [fieldname].printf(' "${0}" is null') , pos );
	}
}