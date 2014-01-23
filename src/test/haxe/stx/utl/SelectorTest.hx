package stx.utl;

import stx.Strings;

import Stax.*;
import stx.Compare.*;
import stx.io.Log.*;

using stx.UnitTest;

import stx.utl.Selector;

private enum TestEvent{
  EventVal(v:Int);
  OtherEventVal(v:Int);
}

class SelectorTest extends Suite{
  public function testSelector(u:TestCase):TestCase{
    var a   = new Selector(tuple2(cast Enums.alike,EventVal(999)));
    var t0  = a.apply(EventVal(3));
    return u;
  }
}

