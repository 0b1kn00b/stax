package hx.reactive;

import stx.Strings;

import Stax.*;
import stx.Compare.*;
import stx.io.Log.*;

using stx.UnitTest;

import stx.utl.Selector;

class DispatchersTest extends Suite{
  public function testDispatchers(u:TestCase):TestCase{
    var tsts = [];
    var a : Selector<String> = 'a';
    var b : Selector<String> = 'b';
    var c     = new Selectors();
    var eq    = Strings.equals;
    var hdl   = function(x){};
    var d     = c.addWith(a,hdl,eq);
    var e     = c.addWith(a,hdl,eq);
    var hdl0  = function(y){};
    var f     = c.addWith(a,hdl0,eq);

    tsts.push(isTrue(d));
    tsts.push(isFalse(e));
    tsts.push(isTrue(f));

    return u.append(tsts);
  }
}

