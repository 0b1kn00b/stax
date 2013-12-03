package stx;

using stx.ArrowletTest;

using stx.UnitTest;

import haxe.Timer;

import stx.Log.*;
import Prelude;
import stx.Eventual;

using stx.Tuples;
using stx.Eventual;

using stx.Log;
using stx.Functions;

//import stx.arrowlet.Outcome;

using stx.Arrowlet;

using stx.Arrowlet;
import stx.arrowlet.*;

class ArrowletTest extends Suite{

  /*
  @:note("Retired because of change in Arrows")
  public function testDegenerateCase(u:TestCase):TestCase{
    
    var evt = Eventual.unit();

    var a = function(x){ trace(x);return x;}
    var b = function(y):Eventual<Dynamic>{ return Eventual.pure(y);}

    arw().then(a).then(b).apply(1).each(
      function(y){
        evt.deliver(test().isTrue(true));
      }
    );
    return u;//.add(evt.flatten());
  }*/
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