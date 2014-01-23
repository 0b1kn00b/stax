package stx;

import Stax.*;
import stx.Compare.*;
import stx.io.Log.*;

using stx.UnitTest;

using stx.Positions;

class PositionsTest extends Suite{
  public function testPositions(u:TestCase):TestCase{
    trace(here().toString());
    return u;
  }
}

