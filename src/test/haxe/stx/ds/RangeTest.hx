package stx.ds;
import stx.ds.Range;
using stx.Functions;
using stx.Anys;

class RangeTest extends stx.test.TestCase{
	
	public function testDefaultInitialisation(){
		var range = Range.create();
		assertTrue(range.min == (-1.7976931348623157 * Math.pow(10,308)));
		assertTrue(range.max == (1.7976931348623157 * Math.pow(10,308)));
	}
	public function testRange(){
		var a = Range.create();
		var range = Range.create();

		assertTrue(a.equals(range));
	}
	/*public function testClone(){
		var range = Range.create(-10,10);
		var a = range.clone();
		assertTrue(a.equals(range));
	}*/
	public function testOverlap(){
		var a 		= Range.create(10,110);
		var b 		= Range.create(180,260);
		var range = Range.create(100,200);

		assertTrue(range.overlap(a));
		assertTrue(range.overlap(b));
		assertFalse(a.overlap(b));
	}
	public function testWithin(){
		var range = Range.create(-10,10);
		assertTrue(range.within(0));
		assertFalse(range.within(-11));
		assertFalse(range.within(10.00001));
	}
	public function testInside(){
		var a = Range.create(-100,-10);
		var range = Range.create(-90,-20);

		assertTrue(range.inside(a));
		range = 
			range.sendTo(
				function(x){
					return Range.create(-110,x.max);
				}
			);
		assertFalse(range.inside(a));
		range = 
			range.sendTo( Range.create.lazy(-90,0).promote() );

		assertFalse(range.inside(a));
	}
}
