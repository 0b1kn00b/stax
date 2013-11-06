package stx;

import Prelude;

/*import Stax.*;
import stx.Compare.*;
import stx.Log.*;

using stx.UnitTest;*/

using stx.fnc.Monad;

class OutcomeTest /*extends TestCase*/{
  public function new(){}
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

