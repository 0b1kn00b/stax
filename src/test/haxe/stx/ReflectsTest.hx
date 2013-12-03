package stx;

import stx.UnitTest;
import stx.Compare.*;
import stx.Log.*;

import stx.Reflects;

class ReflectsTest extends Suite{
  public function testReflects(u:TestCase):TestCase{
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

