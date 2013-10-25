package stx;

import Stax.*;
import stx.Compare.*;
import stx.Log.*;

using stx.UnitTest;

using stx.Positions;

class PositionsTest extends TestCase{
  public function testPositions(u:UnitArrow):UnitArrow{
    trace(here().toString());
    return u;
  }
}

