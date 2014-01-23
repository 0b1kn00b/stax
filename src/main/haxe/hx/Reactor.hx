package hx;

import stx.async.Arrowlet;
import stx.utl.Selector;

import hx.reactive.DefaultReactor;
import hx.ifs.Reactor in IReactor;

abstract Reactor<I>(IReactor<I>) from IReactor<I> to IReactor<I>{
  @:noUsing static public function unit<T>():Reactor<T>{
    return new DefaultReactor();
  }
  /*@:to public function stream(?of:Selector<I>):Stream<I>{
    of = of == null ? any() : of;
    var s : Stream<I> = Streams.unit();
    this.on(of,
      function(x:I){
        s.dispatch(x);
      }
    );
    return s;
  }*/
  public function new(v){
    this = v;
  }
  public function on(slct:Selector<I>, handler:I->Void):Void{
    return this.on(slct,handler);
  }
  public function once(slct:Selector<I>, handler:I->Void):Void{
    return this.once(slct,handler);
  }
  public function rem(slct : Selector<I>, handler:I->Void):Void{
    return this.rem(slct,handler);
  }
  public function has(slct:Selector<I>):Bool{
    return this.has(slct);
  }
  @:access(hx.ifs)public function emit(event:I):Bool{
    return this.emit(event);
  }
}
class Reactors{
  @:noUsing static public function any<T>():Selector<T>{
    return tuple2(function(x,y) return true,null);
  }
  @:noUsing static public function arrow<I,O>(?of:Selector<I>):Arrowlet<Reactor<I>,I>{
    of = of == null ? any() : of;
    var arw : Arrowlet<Reactor<I>,I> = function(x:Reactor<I>,cont:I->Void):Void{
      x.once(of,cont);
    }
    return arw;
  }
  static public function map<I,O>(rct:Reactor<I>,fn:I->O):Reactor<O>{
    var n = new DefaultReactor();
    rct.on(any(),
      function(x){
        n.emit(fn(x));
      }
    );
    return n;
  }
  static public function flatMap<I,O>(rct:Reactor<I>,fn:I->Reactor<O>):Reactor<O>{
    var n = new DefaultReactor();
    rct.on(any(),
      function(x){
        var n0 = fn(x);
            n0.on(any(),n.emit);
      }
    );
    return n; 
  }
  /*static public function flatFold<I,O>(rct:Reactor<T>,fn:I->Reactor<I>):Reactor<I>{
    var n = new DefaultReactor();
    rct.on(any(),
      function(x){
        var n0 = fn(x);
            n0.on(any(),n.emit);
      }
    );
    return n;  
  }*/
  static public function filter<I,O>(rct:Reactor<I>,fn:I->Bool):Reactor<I>{
    return flatMap(rct,
      function(x){
        var n = new DefaultReactor();
            rct.on(
              any(),
              function(y){
                if(fn(y)){
                  n.emit(y);
                }
              }
            );
        return n;
      }
    );
  }
}