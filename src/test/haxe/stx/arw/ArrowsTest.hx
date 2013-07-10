package stx.arw;

import haxe.Timer;

import stx.Log.*;
import stx.Prelude;
import stx.Muster;
import stx.Muster.Test.*;
import stx.Niladic;
import stx.Future;

using stx.Tuples;
using stx.Eventual;
using stx.test.Assert;
using stx.arw.Arrows;
using stx.Log;
using stx.Functions;

//using stx.Method;
import stx.arw.Arrows.Arrow.*;
using stx.arw.Arrows;
import stx.arw.*;

typedef Niladic = Void->Void;
typedef Continuation<Z,A> = (A -> Z) -> Z;
typedef CallbackType<A> = Continuation<Niladic,A>;

/*abstract Callback<A>(CallbackType<A>) from CallbackType<A> to CallbackType<A>{
  public function new(v:(A->Niladic)->Niladic){
    this = v;
  } 
}*/
class ArrowsTest extends TestCase implements tink.lang.Cls{
  public function testSomething(u:UnitArrow):UnitArrow{
    
    return u;
  }
  public function testLift(u:UnitArrow):UnitArrow{
    var a = function(x:Int):Int{
      return x +1;
    }
    /*
    var b : Arrow<Int,Int> = function(x:Int):Int{
      return x *2;
    }
    a.withInput(10,
      function(x){
        trace('fst');
      }
    );*/
    $type(a.apply);
    var c = a;
    $type(c);
    c.withInput(11,
      function(x){
        trace('snd');
      }
    );
    return u;
  }
}