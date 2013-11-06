Laztpackage stx;

using stx.ArrowTest;

using stx.UnitTest;

import haxe.Timer;

import stx.Log.*;
import Prelude;
import stx.Eventual;

using stx.Tuples;
using stx.Eventual;

using stx.Log;
using stx.Functions;

import stx.arw.OutcomeArrow;

using stx.Arrow;
import stx.Arrow.Arrow.*;
using stx.Arrow;
import stx.arw.*;

class ArrowTest extends TestCase{
  /**
    Degenerate case. Because there is no inferable type, implicit constructor inference order specifies an Eventual and then backtracks it
    as the input.
  */
  public function testDegenerateCase(u:UnitArrow):UnitArrow{
    /*
    var evt = Eventual.unit();

    var a = function(x){ trace(x);return x;}
    var b = function(y):Eventual<Dynamic>{ return Eventual.pure(y);}

    arw().then(a).then(b).apply(1).each(
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

    arw().then(a).then(b).apply(1).each(
      function(y){
        evt.deliver(isTrue(true));
      }
    );
    return u.add(evt.flatten());
  }
}