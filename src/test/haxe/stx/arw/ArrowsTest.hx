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
import stx.arw.ApplyArrow;
import stx.arw.ChoiceArrow;
import stx.arw.CPSArrow;
import stx.arw.EitherArrow;
import stx.arw.FutureArrow;
import stx.arw.LeftChoiceArrow;
import stx.arw.MapArrow;
import stx.arw.MaybeArrow;
import stx.arw.OrArrow;
import stx.arw.OutcomeArrow;
import stx.arw.PairArrow;
import stx.arw.ReaderArrow;
import stx.arw.RepeatArrow;
import stx.arw.RightChoiceArrow;
import stx.arw.RightSwitchArrow;
import stx.arw.SplitArrow;
import stx.arw.StateArrow;
import stx.arw.ThenArrow;

class ArrowsTest extends TestCase{

  public function new() {
    super();
  }
  public function testLift() {
    var a = Arrow.unit();
    var b = function(x) return x + 1;
    var c = a.then(b.lift());
        c.apply(10).foreach(Log.printer());
  }
}