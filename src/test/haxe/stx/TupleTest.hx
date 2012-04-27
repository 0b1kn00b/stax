package stx;

/**
 * ...
 * @author 0b1kn00b
 */
import stx.Tuples;				using stx.Tuples;
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
		var a = Tuples.t2( null , 32 );
		Assert.isTrue(Reflect.hasField( a, '_2') );
	}
	/**
	 * 
	 */
	public function testArity() {
		var a = Tuples.t5( null , null , null , null , null );
		Assert.equals( 5 , a.arity() );
	}
	public function testElement() {
		var a = Tuples.t2( 1 , 2 );
		2.equals( a.element(2) );
	}
	public function testElements() {
		var a = Tuples.t2( 1, 2);
		[1, 2].equals(cast a.elements());
	}
}