package stx;

import stx.Muster;
import stx.Muster.*;
import stx.Compare.*;
import stx.Log.*;

import stx.Reflects;

class ReflectsTest extends TestCase{
  public function testReflects(u:UnitArrow):UnitArrow{
    var a = {
      a : 1,
    }
    var b = {
      a : 3,
      b : 4
    }
    return u.add(
      it(
        'should be -1',
        eq(-1),
        Reflects.compare(a,b)
      )
    );
  }
}

