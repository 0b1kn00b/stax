package stx;

import stx.Prelude;
import stx.test.TestCase;

using stx.Bools;

class BoolsTest extends TestCase{
	public function testIfTrue(){
		this.assertEquals( Some(true), true.ifTrue(function()return true) );
	}
}