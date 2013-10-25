package stx.rct;

import stx.utl.Selector;
import stx.reactive.Reactive;
import stx.reactive.Streams;

import stx.plus.Equal;

using stx.Eventual;
using stx.Arrow;
using stx.Prelude;
using stx.Arrays;
using stx.Tuples;
using stx.Options;
using stx.Compose;
using stx.Functions;

import stx.rct.*;
import stx.rct.Reactors;
import stx.rct.Reactor;

class DefaultReactor<I> implements Reactor<I>{
  private var equality    : I -> I -> Bool;
  private var dispatchers : Dispatchers<I,I>;

  public function new(){
    this.dispatchers = new Dispatchers();
  }
  public function selectors(){
    return dispatchers.map(Tuples2.fst);
  }
  public function on(slct:Selector<I>, handler:I->Void):I->Void{
    check(slct);
    dispatchers.addWith(slct,handler,equality);
    return handler;
  }
  public function once(slct:Selector<I>, handler:I->Void):I->Void{
    check(slct);
    var handler0 = null;
        handler0 = function(o:I){
          handler(o);
          rem(slct,handler0);
        }
    return this.on(slct,handler0);
  }
  public function rem(slct : Selector<I>, handler:I->Void):I-> Void {
    check(slct);
    dispatchers.remWith(slct,handler,equality);
    return handler;
  }
  public function emit(event:I):Bool {
    return try {
      dispatchers.native().foreach(
        function(slct:Selector<I>,arr:Array<I->Void>){
          if (slct.test(event)){
            for (fn in arr){
              fn(event);
            }
          }
        }.tupled()
      );
      true;
    } catch( exc : EventException ) {
      false;
    }
  }
  public function has(slct:Selector<I>):Bool {
    check(slct);
    return dispatchers.findWith(slct,equality).isDefined();
  }
  public function push(?of:Selector<I>):LazyStream<I>{
    of = of == null ? Reactors.any() : of;
    var gen : LazyStream<I> = null;
    gen = function(x:Unit):Eventual<Tuple2<I,LazyStream<I>>>{
      return Reactors.arrow(of).apply(this).map(
        function(x){
          return tuple2(x,gen);
        }
      );
    }
    return gen;
  }
  private inline function check(slct:Selector<I>){
    if(equality == null) equality = Equal.getEqualFor(slct.value());
  }
}