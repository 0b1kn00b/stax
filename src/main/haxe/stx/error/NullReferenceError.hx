package stx.error;

/**
 * ...
 * @author 0b1kn00b
 */
import stx.Error;			using stx.Error;

class NullReferenceError extends Error {

	public function new(fieldname: String, ?pos) {
		super( [fieldname].printf(' "${0}" is null') , pos );
	}
}