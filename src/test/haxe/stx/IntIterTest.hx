package stx;

import stx.test.Suite;
import stx.test.Assert;

using Prelude;
using stx.Log;

class IntIteratorTest extends Suite{
	public function testNone(){
		var a = 0.until(0);
		Assert.isTrue(true);
	}
	public function testOne(){
		var a = 0.until(1);
		Assert.isTrue(true);
	}
	public function testToArray(){
		var a = 0.until(1);
		a.toArray();
		trace(a.toArray());
		Assert.isTrue(true);
	}
}