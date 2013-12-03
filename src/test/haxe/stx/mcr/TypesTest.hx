package stx.mcr;

import Stax.*;
import stx.Compare.*;
import stx.Log.*;

using stx.UnitTest;

import stx.mcr.Types;

class TypesTest extends Suite{
  public function testTypes(u:TestCase):TestCase{
    var t0 = new Test();
        Types.test(t0);
    return u;
  }
}
private class Test<T>{
  public function new(){}
  var t : T;

  public function c<A>():T{
    return t;
  }
}
    