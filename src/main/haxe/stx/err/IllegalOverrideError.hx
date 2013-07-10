package stx.err;

/**
 * ...
 * @author 0b1kn00b
 */
using Std;
using stx.Error;
																
class IllegalOverrideError extends Error{

	public function new(of:String,?pos) {
		super( 'Attempting illegal override of "$of".', pos);
	}
	
}