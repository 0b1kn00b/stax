package stx.reactive;

import stx.Maths;

import Stax.*;

import haxe.unit.TestCase;

import stx.async.Dissolvable;

using stx.reactive.Signal;

class SignalTest extends TestCase{
  public function testSignal(){
    var val = null;
    var fn = function(int:Int->Void){
      int(1);
      int(3);
      return noop;
    }.map(Ints.add.bind(1))
     .foldp1(Ints.add)
     .apply(
      function(x){
        val = x;
      }
     );
     assertEquals(6,val);
  }
  public function testMerge(){
    var val = null;
    var fn0 = function(int:Int->Void){
      int(1);
      return noop;
    }
    var fn1 = function(int:Int->Void){
      int(1); 
      return noop;
    }

    fn0.merge(fn1).foldp1(Ints.add)
    .apply(
      function(x){
        val = x;
      }
    );
    assertEquals(2,val);
  }
}