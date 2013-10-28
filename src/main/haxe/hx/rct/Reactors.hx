package hx.rct;

using stx.Tuples;
using stx.Arrow;

import stx.utl.Selector;

class Reactors{
  @:noUsing static public function stream<I>(rct:Reactor<I>,?of:Selector<I>):Stream<I>{
    of = of == null ? any() : of;
    var s : Stream<I> = Streams.unit();
    rct.on(of,
      function(x){
        s.dispatch(x);
      }
    );
    return s;
  }
  @:noUsing static public function any<T>():Selector<T>{
    return tuple2(function(x,y) return true,null);
  }
  static public function all<T>(rct:Reactor<T>,hnd:T->Void){
    return rct.on(any(),hnd);
  }
  @:noUsing static public function arrow<I,O>(?of:Selector<I>):Arrow<Reactor<I>,I>{
    of = of == null ? any() : of;
    var arw : Arrow<Reactor<I>,I> = function(x:Reactor<I>,cont:I->Void):Void{
      x.once(of,cont);
    }
    return arw;
  }
}