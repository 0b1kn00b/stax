package stx;

using stx.ArrowsTest;

import haxe.Timer;

import stx.Log.*;
import stx.Prelude;
import stx.Muster;
using stx.Muster;
import stx.Muster.*;
import stx.Niladic;
import stx.Future;

using stx.Tuples;
using stx.Eventual;

using stx.Log;
using stx.Functions;

using stx.Arrows;
import stx.Arrows.Arrow.*;
using stx.Arrows;
import stx.arw.*;

class ArrowsTest extends TestCase{
  /**
    Degenerate case. Because there is no inferable type, implicit constructor inference order specifies an Eventual and then backtracks it
    as the input.
  */
  public function testDegenerateCase(u:UnitArrow):UnitArrow{
    /*
    var evt = Eventual.unit();

    var a = function(x){ trace(x);return x;}
    var b = function(y):Eventual<Dynamic>{ return Eventual.pure(y);}

    arw().then(a).then(b).apply(1).foreach(
      function(y){
        evt.deliver(test().isTrue(true));
      }
    );*/
    return u;//.add(evt.flatten());
  }
  public function testSimpleWorkingCase(u:UnitArrow):UnitArrow{
    var evt = Eventual.unit();

    var a = function(x){ trace(x);return x+0;}
    var b = function(y):Eventual<Dynamic>{ return Eventual.pure(y);}

    arw().then(a).then(b).apply(1).foreach(
      function(y){
        evt.deliver(test().isTrue(true));
      }
    );
    return u.add(evt.flatten());
  }
}