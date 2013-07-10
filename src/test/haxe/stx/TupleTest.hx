package stx;

/**
 * ...
 * @author 0b1kn00b
 */
using stx.Tuples;
import stx.test.TestCase;
import stx.test.Assert;		using stx.test.Assert;

class TupleTest extends TestCase{

	public function new() {
		super();
	}
	/**
	 * Shows one can get arity/length from the typedef.
	 */
	public function testConstructor() {
		var a = tuple2( null , 32 );
		Assert.isTrue(Reflect.hasField( a, '_2') );
	}
	/**
	 * 
	 */
	public function testArity() {
		var a = tuple5( null , null , null , null , null );
		var b : Product = a;
		Assert.equals( 5 , b.length );
	}
	public function testElement() {
		var a = tuple2( 1 , 2 );
		var b : Product = a;
		2.equals( b.element(1) );
	}
	public function testElements() {
		var a = tuple2( 1, 2);
		var b : Product = a;
		[1, 2].equals(cast b.elements());
	}
}