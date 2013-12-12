package rx;

using haxe.unit.TestCases;

import stx.Chunk;
import Stax.*;
import haxe.unit.TestCase;

using rx.Observable;
using stx.Arrays;

import rx.observable.IterableObservable;

class ObservableTest extends TestCase{
  public function testScan(){
    var obs = [1,2,3].observe();
    var out = [];
    obs.scan(
      function(memo,next){
        return (memo * 3) + 10;
      }
    ).each(out.push);
    isEqual([1,13,49].map(Val).add(Nil),out);
  }
  public function testFinalValue(){
    var out = [];
    var obs = [1,2,3].finalValue().each(out.push);
    isEqual([Val(3),Nil],out);
  }
}