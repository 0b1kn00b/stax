package stx;

import Prelude;
import stx.test.Suite;

using stx.Bools;

class BoolsTest extends Suite{
	public function testIfTrue(){
		this.assertEquals( Some(true), true.ifTrue(function()return true) );
	}
}