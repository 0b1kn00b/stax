package stx;

import stx.Muster;
import stx.Muster.Test.*;
import stx.Log.*;

class DelegateTest extends TestCase{
  public function testDelegate(u:UnitArrow):UnitArrow{
    return u;
  }
    