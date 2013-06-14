package stx.arw;

import stx.Tuples.*;
import stx.Prelude;
import stx.arw.OptionArrow;
import stx.arw.StateArrow;

import stx.Eithers;
import stx.Continuation.*;
import stx.Continuation;

using stx.arw.Arrows;
using stx.Tuples;


using stx.Functions;

typedef Consume<A>      = A -> Void;
typedef ArrowType<A,B>  = A -> Consume<B> -> Void;

abstract Arrow<I,O>(ArrowType<I,O>) from ArrowType<I,O>{
  /*#if js
  static public inline function evt<O>(str:String):Arrow<EventTarget,O>{
    return new EventArrow1(str);
  }
  #end*/
  static public inline function arw<A,B>(?arw:ArrowType<A,B>):Arrow<A,B>{
    return arw == null ? cast unit : arw;
  }
  @:noUsing static public function unit<A>():Arrow<A,A>{
    return function(a:A,cont:A->Void):Void{
      cont(a);
    }
  }
  @:noUsing static public function pure<A,B>(v:B):Arrow<A,B>{
    return function(a:A,cont:B->Void):Void{
      cont(v);
    }
  }
  @:noUsing static public function pureFuture<A>(v:Future<A>):Arrow<Unit,A>{
    return function(a:Unit,cont:A->Void):Void{
      v.foreach(cont);
    }
  }
  public function new(v){
    this  = v;
  }
  @:from static inline public function fromFutureConstructor<A,B>(fn:A->Future<B>):Arrow<A,B>{
    return inline function(a:A,b:Consume<B>):Void{
      fn(a).foreach(b);
    }
  }
  @:from static inline public function fromFutureConstructor2<A,B,C>(fn:A->B->Future<C>):Arrow<Tuple2<A,B>,C>{
    return inline function(a:Tuple2<A,B>,b:Consume<C>):Void{
      fn.spread()(a).foreach(b);
    }
  }
  @:from static inline public function fromFutureConstructor3<A,B,C,D>(fn:A->B->C->Future<D>):Arrow<Tuple3<A,B,C>,D>{
    return inline function(a:Tuple3<A,B,C>,b:Consume<D>):Void{
      fn.spread()(a).foreach(b);
    }
  }
  @:from static inline public function fromFutureConstructor4<A,B,C,D,E>(fn:A->B->C->D->Future<E>):Arrow<Tuple4<A,B,C,D>,E>{
    return inline function(a:Tuple4<A,B,C,D>,b:Consume<E>):Void{
      fn.spread()(a).foreach(b);
    }
  }
  @:from static inline public function fromFutureConstructor5<A,B,C,D,E,F>(fn:A->B->C->D->E->Future<F>):Arrow<Tuple5<A,B,C,D,E>,F>{
    return inline function(a:Tuple5<A,B,C,D,E>,b:Consume<F>):Void{
      fn.spread()(a).foreach(b);
    }
  }
/*  @:from static inline public function fromConsumer<A>(fn:(A->Void)->Void){
    return inline function(a:Unit,b:A->Void):Void{
      fn(b);
    }
  }*/
  @:from static inline public function fromThunk<A>(fn:Void->A):Arrow<Unit,A>{
    return inline function(a:Unit,b:A->Void):Void{
      b(fn());
    }
  }
  @:from static inline public function fromFunction<A,B>(fn:A->B):Arrow<A,B>{
    return inline function(a:A,b:B->Void):Void{
      b(fn(a));
    }
  }
  @:from static inline public function fromFunction2<A,B,C>(fn:A->B->C):Arrow<Tuple2<A,B>,C>{
    return inline function(a:Tuple2<A,B>,b:C->Void):Void{
      b(fn.spread()(a));
    }
  }
  @:from static inline public function fromFunction3<A,B,C,D>(fn:A->B->C->D):Arrow<Tuple3<A,B,C>,D>{
    return inline function(a:Tuple3<A,B,C>,b:D->Void):Void{
      b(fn.spread()(a));
    }
  }
  @:from static inline public function fromFunction4<A,B,C,D,E>(fn:A->B->C->D->E):Arrow<Tuple4<A,B,C,D>,E>{
    return inline function(a:Tuple4<A,B,C,D>,b:E->Void):Void{
      b(fn.spread()(a));
    }
  }
  @:from static inline public function fromFunction5<A,B,C,D,E,F>(fn:A->B->C->D->E->F):Arrow<Tuple5<A,B,C,D,E>,F>{
    return inline function(a:Tuple5<A,B,C,D,E>,b:F->Void):Void{
      b(fn.spread()(a));
    }
  }
  @:from static inline public function fromStateFunction<A,B>(fn:A->Tuple2<B,A>):Arrow<A,Tuple2<B,A>>{
    return inline function(a:A,b:Tuple2<B,A>->Void):Void{
      b(fn(a));
    }
  }
  public function asFunction():ArrowType<I,O>{
    return this;
  }
}
class Arrows{
  static public function action<I>(fn:I->Void):Arrow<I,I>{
    return function(x:I){
      fn(x); return x;
    }
  }
  static public inline function withInput<I,O>(arw:Arrow<I,O>,i:I,cont:O->Void):Void{
    arw.asFunction()(i,cont);
  }
  static public inline function apply<I,O>(arw:Arrow<I,O>,i:I):Future<O>{
    return Continuation.future(withInput.bind(arw,i));
  }
  static public inline function reply<A>(arw:Arrow<Unit,A>):Future<A>{
    return arw.apply(Unit);
  }
  static public function then<A,B,C>(before:Arrow<A,B>, after:Arrow<B,C>):Arrow<A,C> { 
    return function(i : A, cont : Function1<C,Void>) : Void {
      var m  = function (reta : B) { after.withInput(reta, cont);};
      before.withInput(i, m);
    }
  }
  static public function first<A,B,C>(first:Arrow<A,B>):Arrow<Tuple2<A,C>,Tuple2<B,C>>{
    return pair(first, Arrow.unit());
  }
  static public function second<A,B,C>(second:Arrow<A,B>):Arrow<Tuple2<C,A>,Tuple2<C,B>>{
    return pair(Arrow.unit(), second);
  }
  static public function split<A,B,C>(split_:Arrow<A,B>,_split:Arrow<A,C>):Arrow<A,Tuple2<B,C>> { 
    return function(i:A, cont:Tuple2<B,C>->Void) : Void{
      return pair(split_,_split).withInput(tuple2(i,i) , cont);
    };
  }
  static public function pair<A,B,C,D>(pair_:Arrow<A,B>,_pair:Arrow<C,D>):Arrow<Tuple2<A,C>,Tuple2<B,D>>{ 
    return function(i : Tuple2<A,C>, cont : Function1<Tuple2<B,D>,Void> ) : Void{
        var ol : Option<B>   = null;
        var or : Option<D>   = null;

        var merge   =
          function(l:B,r:D){
            cont( tuple2(l,r) );
          }
        var check   =
          function(){
            if (((ol!=null) && (or!=null))){
              merge(Options.getOrElseC(ol,null),Options.getOrElseC(or,null));
            }
          }
        var hl    = 
          function(v:B){
            ol = v == null ? None : Some(v);
            check();
          }
        var hr    =
          function(v:D){
            or = v == null ? None : Some(v);
            check();
          }
        pair_.withInput( i.fst() , hl );
        _pair.withInput( i.snd() , hr );
      }
  }
  static public function swap<A,B,C>(a:Arrow<A,Tuple2<B,C>>):Arrow<A,Tuple2<C,B>>{
    return a.then(T2.swap);
  }
  static public function fan<I,O>(a:Arrow<I,O>):Arrow<I,Tuple2<O,O>>{
    return a.then(
      function(x:O):Tuple2<O,O>{
        return tuple2(x,x);
      }
    );
  }
  static public function pinch<I,O1,O2>(a:Arrow<Tuple2<I,I>,Tuple2<O1,O2>>):Arrow<I,Tuple2<O1,O2>>{
    return fan(Arrow.unit()).then(a);
  }
  static public function both<A,B>(a:Arrow<A,B>):Arrow<Tuple2<A,A>,Tuple2<B,B>>{
    return a.pair(a);
  }
  static public function as<A,B,C>(a:Arrow<A,B>,type:Class<C>):Arrow<A,C>{
    return a.then( function(x:B):C { return cast x; } ); 
  }
  static public function join<A,B,C>(joinl:Arrow<A,B>,joinr:Arrow<B,C>):Arrow<A,Tuple2<B,C>>{
    return then( joinl , Arrow.unit().split(joinr) );
  }
  static public function tie<A,B,C>(bindl:Arrow<A,B>,bindr:Arrow<Tuple2<A,B>,C>):Arrow<A,C>{
    return then( Arrow.unit().split(bindl) , bindr );
  }
  static public function repeat<I,O> (a:Arrow<I,FreeM<I,O>>):Arrow<I,O>{
    return new RepeatArrow(a);
  }
  static public function or<P1,P2,R0>(or_:Arrow<P1,R0>,_or:Arrow<P2,R0>):Arrow<Either<P1,P2>,R0>{
      return new OrArrow(or_, _or);
  }
  public static function left<B,C,D>(arr:Arrow<B,C>):Arrow<Either<B,D>,Either<C,D>>{
    return new LeftChoiceArrow(arr);
  }
  public static function either<A,B>(a:Arrow<A,B>,b:Arrow<A,B>):Arrow<A,B>{
    return new EitherArrow(a,b);
  }
  public static function right<B,C,D>(arr:Arrow<B,C>):Arrow<Either<D,B>,Either<D,C>>{
    return new RightChoiceArrow(arr);
  }
  public static function fromR<A,B,C,D>(arr:Arrow<B,Either<C,D>>):Arrow<Either<C,B>,Either<C,D>>{
    return new RightSwitchArrow(arr);
  }
  public static function fromL<A,B,C,D>(arr:Arrow<A,Either<C,D>>):Arrow<Either<A,D>,Either<C,D>>{
    return new LeftChoiceArrow(arr).then(Eithers.flattenL);
  }
  public static function option<I,O>(a:Arrow<I,O>):OptionArrow<I,O>{
    return new OptionArrow(a);
  }
  public static function exchange<I,O,N>(a:Arrow<I,O>,n:N):Arrow<I,N>{
    return a.then(
      function(x:O):N{
        return n;
      }
    );
  }
  static public function flatten<I,O>(arw:Arrow<Option<I>,Option<Option<O>>>):ArrowOption<I,O>{
    return arw.then( Options.flatten);
  }
  static public function fromMbe<I,O>(arw:Arrow<I,Option<O>>):ArrowOption<I,O>{
    return arw.option().flatten();
  }
  static public function printA<A,B>(a:Arrow<A,B>):Arrow<A,B>{
    var m : Function1<B,B> = function(x:B):B { haxe.Log.trace(x) ; return x;};
    return new ThenArrow( a, m );
  }
  static public function invoke<A,B,C>(a:Arrow<A,B>,b:Thunk<Arrow<B,C>>){
    return a.then(
      function(x:B){
        var n = b();
        return n.apply(x);
      }
    );
  }
  static public function invokeWith<B,C,D>(b:Arrow<B,Arrow<C,D>>,inpt:C):Arrow<B,D>{
    return b.then(
      function(arw:Arrow<C,D>){
        return arw.apply(inpt);
      }
    );
  }
  static public function uncurry<A,B,C>(a:Arrow<A,Arrow<B,C>>):Arrow<Tuple2<A,B>,C>{
    return function(tp:Tuple2<A,B>){
      return a.apply(tp.fst()).flatMap(
        function(a0){
          return a0.apply(tp.snd());
        }
      );
    }
  }
  @:noUsing
  static public function state<S,A>(a:Arrow<S,Tuple2<A,S>>):ArrowState<S,A>{
    return a;
  }
  @:noUsing
  static public function application<I,O>():ApplicationArrow<I,O>{
    return inline function(i:Tuple2<Arrow<I,O>,I>,cont : Function1<O,Void>){
        i.fst().withInput(
          i.snd(),
            function(x:O){
              cont(x);
            }
        );
      }
  }
}
class FutureArrows{
  public static function arrow<I>(p:Future<I>):Arrow<Unit,I>{
    return function(u:Unit){ return p; }
  }
}
/*class CallbackArrows{
  static public function lift<A,B>(fn:A->Callback<B>):Arrow<A,B>{
    return Arrow.fromCallbackConstructor(fn);
  }
}*/