package rx;

using stx.Maths;

import stx.Log.*;
import haxe.unit.TestCase;

import rx.Future;

class FutureTest extends TestCase{
  public function testFutureSimple(){
    var done  = false;
    var ft    = new Future();
        ft.deliver(1);
    ft.subscribe(
      function(v){
        if(v == 1){
          done = true;
        }
      }
    );
    assertTrue(done);
  }
  public function testMap(){
    var v   = 0;
    var ft  = new Future();
    var ft0 = ft.map(Ints.add.bind(1));
    var h0  = function(x) v+=x;
    var h1  = function(x) v+=x;
    ft.each(h0);
    ft0.each(h1);
    ft0.each(h1);
    ft.deliver(1);
    assertEquals(5,v);
  }
  public function testFunctionLift(){
    var val = null;
    var fn = function(fn:Int->Void):Void{
      fn(1);
    }
    var ft : Future<Int> = fn;
        ft.each(function(x) val = x);

    assertEquals(1,val);
  }
  public function testFlatMap(){
    var val = null;
    (function(fn:Int->Void){
      fn(1);
    }:Future<Int>).flatMap(
      function(x):Future<Int>{ //needs typeinfo
        return function(fn2){
          fn2(x+1);
        }
      }
    ).each(function(x) val = x);
    assertEquals(2,val);
  }
  public function testMultipleListeners(){
    var val = 0;
    var a = new Future();
    a.each(function(x) val +=1);
    a.each(function(x) val +=1);
    a.deliver(1);
    assertEquals(2,val);
  }
}