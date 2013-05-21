package stx.err;

/**
 * ...
 * @author 0b1kn00b
 */

class AssertionError extends Error{

	public function new(msg,?pos) {
		super(msg,pos);
	}
}