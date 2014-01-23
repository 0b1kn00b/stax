package stx.async;

import Stax.*;
import stx.Compare.*;
import stx.io.Log.*;

using stx.UnitTest;

class FutureTest extends Suite{
  public function testSimpleFuture(u:TestCase):TestCase{
    var a : Future<Int> = function(x:Int->Void){
      x(1);
    }
    var b = a.map(isEqual.bind(_,1));
    return u.add(b);
  }
}    