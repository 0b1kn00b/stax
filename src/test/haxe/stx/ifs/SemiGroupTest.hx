package stx.ifs;

import stx.Muster;
import stx.Muster.Test.*;
import stx.Log.*;

using stx.ifs.SemiGroup;

import stx.ifs.TestArray in Array;

class SemiGroupTest extends TestCase{
  public function testSemiGroup(u:UnitArrow):UnitArrow{
    var arr = new Array();
        arr.push(1);
    var sem : SemiGroup<Int> = arr;

    return u;
  }
}