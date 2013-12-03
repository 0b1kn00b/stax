package stx;

using stx.UnitTest;
import stx.Log.*;

class DelegateTest extends Suite{
  public function testDelegate(u:TestCase):TestCase{
    return u;
  }
    