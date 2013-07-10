package stx.ifs;

import stx.Muster;
import stx.Muster.Test.*;
import stx.Log.*;

using stx.ifs.Pure;

class PureTest extends TestCase{
  public function testPure(u:UnitArrow):UnitArrow{
    Eventual.pure(1);
    return u;
  }
}
