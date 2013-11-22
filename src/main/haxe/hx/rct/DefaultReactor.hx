package hx.rct;

import hx.evt.EventException;
import hx.ifs.Reactor in IReactor;

import stx.utl.Selector;

import stx.plus.Equal;

using stx.Eventual;
using stx.Arrow;
using Prelude;
using stx.Arrays;
using stx.Tuples;
using stx.Option;
using stx.Compose;
using stx.Functions;

class DefaultReactor<I> implements IReactor<I>{
  private var equality    : I -> I -> Bool;
  @:isVar public var dispatchers(get,null) : Dispatchers<I,I>;
  private function get_dispatchers(){
    return dispatchers; 
  }
  public function new(){
    this.dispatchers = new Dispatchers();
  }
  public function on(slct:Selector<I>, handler:I->Void):Void{
    check(slct);
    dispatchers.addWith(slct,handler,equality);
  }
  public function once(slct:Selector<I>, handler:I->Void):Void{
    check(slct);
    var handler0 = null;
        handler0 = function(o:I){
          handler(o);
          rem(slct,handler0);
        }
    this.on(slct,handler0);
  }
  public function rem(slct : Selector<I>, handler:I->Void):Void{
    check(slct);
    dispatchers.remWith(slct,handler,equality);
  }
  public function emit(event:I):Bool {
    return try {
      dispatchers.native().each(
        function(slct:Selector<I>,arr:Array<I->Void>){
          if (slct.apply(event)){
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
  public function has(slct:Selector<I>):Bool{
    check(slct);
    return dispatchers.hasWith(slct,equality);
  }
/*  public function push(?of:Selector<I>):LazyStream<I>{
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
  }*/
  private inline function check(slct:Selector<I>){
    if(equality == null) equality = Equal.getEqualFor(slct.value());
  }
}