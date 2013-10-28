package stx.ds;

import Stax.*;

import hx.ds.ifs.Enumerator;

import stx.Muster;
import stx.Muster.*;
import stx.Log.*;
import stx.Fail;

import stx.plus.Plus;

using stx.Compose;
using stx.Option;
using stx.Prelude;
using stx.Iterables;

using stx.ds.ListNewTest;

class ListNewTest extends TestCase{
  public function testListNew(u:UnitArrow):UnitArrow{
    var itr                         = 0.until(3);
    var l  : List<Int>              = itr;//constructor
    var l2 : List<Int>              = 3.until(5);
    var l3                          = l.append(l2);
    //var l4                          = l.prepend(1);
    //var l4                          = l3.flatMap(function(x) return Nil.add(x).add(x+10));
    return u;
  }
}