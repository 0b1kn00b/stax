package stx.arw;

import haxe.Timer;

using stx.Tuples;
using stx.Future;
using stx.test.Assert;
using stx.arw.Arrows;
using stx.Log;

import stx.Prelude;
import stx.test.TestCase;

using stx.arw.Arrows;

class ArrowsTest extends TestCase{

  public function new() {
    super();
  }
  public function testLift() {
    var a = Arrow.unit();
    var b = function(x) return x + 1;
    var c = a.then(b);
        c.apply(10).foreach(Log.printer());
  }
}