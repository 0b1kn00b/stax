package stx;

import Prelude;
import stx.UnitTest;

using stx.Bools;

class BoolsTest extends Suite{
	public function testIfTrue(u:TestCase):TestCase{
    return u.add(isEqual(Some(true), true.ifTrue(function()return true)));
	}
}