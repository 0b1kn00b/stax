package stx.macro;

import stx.Prelude;
import stx.Objects;
import stx.test.TestCase;

import stx.macro.LensesMacro;

using stx.Lenses;

class LensesMacroTest extends TestCase {
  public function testLense(){
    var c = ABC_.c_;
    var d = DEF_.d_;

    var def : DEF = 
    {
      d : 'w00t'
    }
    var abc : ABC = 
    {
      a   : 'first',
      b   : 'second',
      c   : def
    }
    var cd = c.then(d);
    trace(cd.get(abc));
    assertTrue(true);
  }
}
typedef ABC = {
  public var a : Dynamic;
  public var b : Object;
  public var c : DEF;
}
typedef DEF = {
  public var d : String;
}
class ABC_ implements LensesFor<ABC>{}
class DEF_ implements LensesFor<DEF>{}