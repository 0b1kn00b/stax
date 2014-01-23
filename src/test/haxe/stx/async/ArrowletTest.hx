package stx.async;

using stx.async.ArrowletTest;

using stx.UnitTest;

import haxe.Timer;

import stx.io.Log.*;
import Prelude;
import stx.async.Eventual;

using stx.Tuples;
using stx.async.Eventual;

using stx.io.Log;
using stx.Functions;

//import stx.arrowlet.Outcome;

using stx.async.Arrowlet;

using stx.async.Arrowlet;
import stx.arrowlet.*;

class ArrowletTest extends Suite{

  public function testSimpleWorkingCase(u:TestCase):TestCase{
    var evt = Eventual.unit();

    var a = function(x){ trace(x);return x+0;}
    var b = function(y):Eventual<Dynamic>{ return Eventual.pure(y);}

    Arrowlet.unit().then(a).then(b).apply(1).each(
      function(y){  
        evt.deliver( isTrue(true));
      }
    );
    return u.add(evt);
  }
}