package stx.error;

/**
 * ...
 * @author 0b1kn00b
 */
																using stx.error.Error;
																
class IllegalOverrideError extends Error{

	public function new(of,?pos) {
		super( [of].printf('Attempting illegal override of ${0}'), pos);
	}
	
}