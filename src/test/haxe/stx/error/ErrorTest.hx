package stx.error;

/**
 * ...
 * @author 0b1kn00b
 */
import stx.test.TestCase;
import stx.test.Assert;						using stx.test.Assert;
import stx.error.Error;						using stx.error.Error;

class ErrorTest extends TestCase{

	public function new() {
		super();
	}
	public function testPrintf() {
		var arr = [1, '54', { thing : true } ];
		arr.printf(' ${0} , ${1} , ${2} raaah' );
	}
	
}