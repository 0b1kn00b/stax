package stx;

import Prelude;
import stx.UnitTest;

using stx.Outcome;

class OutcomeTest extends Suite{
  public function testOutcome(u){
    var a = Success(1);
    var b = a.flatMap(
      function(x){
        var o = Success(x+1);
        trace(o);
        return o;
      }
    );
    var c = b.map(Success);
    var f = stx.Compose.unit();
    var d = c.map(f);
    var d = c.flatMap;
    return u;
  }
}

