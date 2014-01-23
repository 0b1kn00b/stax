package stx;


import Prelude;
using stx.Tuples;

import stx.UnitTest;

class TupleTest extends Suite{

	/**
	 * Shows one can get arity/length from the typedef.
	 */
	public function testConstructor(u:TestCase):TestCase {
		var a = tuple2( null , 32 );
		return u.add(isTrue(Reflect.hasField( a, '_2') ));
	}
	/**
	 * 
	 */
	public function testArity(u:TestCase):TestCase {
		var a = tuple5( null , null , null , null , null );
		var b : Product = a;
		return u.add(isEqual( 5 , b.length ));
	}
	public function testElement(u:TestCase):TestCase {
		var a = tuple2( 1 , 2 );
		var b : Product = a;
		return u.add(isEqual(2,b.element(1)));
	}
	public function testElements(u:TestCase):TestCase {
		var a = tuple2( 1, 2);
		var b : Product = a;
		return u.add(isEqual([1, 2],cast b.elements()));
	}
}