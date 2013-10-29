package stx;

import Stax.*;
import stx.Compare.*;
import stx.Log.*;

using stx.UnitTest;

class UnitTestTest extends TestCase{
  public function testUnitTest(u:UnitArrow):UnitArrow{
    return u.add(isTrue(true));
  }
}

