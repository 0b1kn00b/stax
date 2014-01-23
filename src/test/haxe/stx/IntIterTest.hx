package stx;

import stx.UnitTest;

using Prelude;
using stx.io.Log;
using stx.Iterables;

class IntIterTest extends Suite{
	public function testToArray(u:TestCase):TestCase{
		var a = 0.until(1);
		return u.add(isTrue(a.toArray().length == 1));
	}
}