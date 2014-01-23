package stx.reactive;

using haxe.unit.TestCases;

import hx.reactive.Dispatcher;

import stx.Maths;
import stx.Chunk;
import Stax.*;
import haxe.unit.TestCase;

using stx.reactive.Observable;
using stx.Arrays;

import stx.reactive.observable.IterableObservable;

class ObservableTest extends TestCase{
  public function testScan(){
    var obs = [1,2,3].observable();
    var out = [];
    var o2  = 
      obs.scan1(
        function(memo,next){
          return (memo * 3) + 10;
        }
      );
    o2.each(out.push);
    
    isEqual([1,13,49].map(Val).add(Nil),out);
  }
  public function testLast(){
    var out = [];
    var observer = Observer.create(out.push);
    var obs = [1,2,3].observable().last().subscribe(observer);
    isEqual([3],out);
  }
  public function testStartWith(){
    var out                   = [];
    var src                   = [3,4,5];
    var obs : Observable<Int> = src;
    var nxt = obs.startWith([1,2]);
    nxt.subscribe(Observer.create(out.push));
    isEqual([1,2,3,4,5],out);
  }
  public function testAggregate(){
    var src       = [1,1,1];
    var out       = [];
    var fn        = out.push;
    var observer : Observer<Int>  = Observer.create(fn);

    src.aggregate(Ints.add,1).subscribe(observer);

    isEqual([4],out);
  }
  public function testFilter(){
    var src = [1,1,2].observable();
    var out = [];
    var fn  = out.push;
    var observer = Observer.create(fn);

    var nxt = src.filter(function(x){
      return x != 1;
    }).subscribe(observer);

    isEqual([2],out);
  }
  public function testMerge(){
    var src0 = [0,1];
    var src1 = [2,3];
    var src2 = src0.merge(src1);
    var out = [];
    var observer = Observer.create(out.push);
    src2.subscribe(observer);
    isEqual([0,1,2,3],out);
  }
  public function testConcat(){
    var src0 : Dispatcher<Chunk<Int>> = new Dispatcher();
    var src1 : Observable<Int> = [2,3];
    var src2 = src0.concat(src1);
    var out = [];
    var observer = Observer.create(out.push);
    src2.subscribe(observer);
  
    [0,1].map(Val).add(Nil).each(src0.emit);

    isEqual([0,1,2,3],out); 
  }
  public function testEmpty(){
    var src = Observable.empty();
  }
}