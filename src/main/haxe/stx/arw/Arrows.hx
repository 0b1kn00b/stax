package stx.arw;

using stx.Tuples;

import stx.ifs.Reply;

import stx.Tuples;
import stx.Prelude;
import stx.arw.OptionArrow;
import stx.arw.StateArrow;

import stx.Eithers;

typedef Consume<A>      = A -> Void;
typedef ArrowType<A,B>  = A -> (B->Void) -> Void;

abstract Arrow<I,O>(ArrowType<I,O>) from ArrowType<I,O>{
  @:op(A > B) static public function then<A,B,C>(lhs:Arrow<A,B>, rhs:Arrow<B,C>):Arrow<A,C>{
    return Arrows.then(lhs,rhs);
  }
  @:op(A * B) static public function pair<A,B,C,D>(pair_:Arrow<A,B>,_pair:Arrow<C,D>):Arrow<Tuple2<A,C>,Tuple2<B,D>>{
    return Arrows.pair(pair_,_pair);
  }
  @:op(A & B) static public function split<A,B,C>(split_:Arrow<A,B>,_split:Arrow<A,C>):Arrow<A,Tuple2<B,C>> { 
    return Arrows.split(split_,_split);
  }
  @:op(A / B) static public function tie<A,B,C>(bindl:Arrow<A,B>,bindr:Arrow<Tuple2<A,B>,C>):Arrow<A,C>{
    return Arrows.tie(bindl,bindr);
  }
  @:op(A % B) static public function join<A,B,C>(joinl:Arrow<A,B>,joinr:Arrow<B,C>):Arrow<A,Tuple2<B,C>>{
    return Arrows.join(joinl,joinr);
  }
  /*#if js
  static public inline function evt<O>(str:String):Arrow<EventTarget,O>{
    return new EventArrow1(str);
  }
  #end*/
  static public inline function arw<A,B>(?arw:ArrowType<A,B>):Arrow<A,B>{
    return arw == null ? cast unit() : arw;
  }
  @:noUsing static public function unit<A>():Arrow<A,A>{
    //trace('unit');
    return function(a:A,cont:A->Void):Void{
      cont(a);
    }
  }
  @:noUsing static public function pure<A,B>(v:B):Arrow<A,B>{
    //trace('pure');
    return function(a:A,cont:B->Void):Void{
      cont(v);
    }
  }
  @:from static inline public function fromUnitEventualConstructor<A>(fn:Void->Eventual<A>):Arrow<Unit,A>{
    //trace('fromUnitEventualConstructor');
    return inline function(a:Unit,b:A->Void):Void{
      fn().foreach(b);
    }
  }
  @:noUsing static public function pureEventual<A>(v:Eventual<A>):Arrow<Unit,A>{
    //trace('pureEventual');
    return function(a:Unit,cont:A->Void):Void{
      v.foreach(cont);
    }
  }
  public function new(v){
    //trace('new');
    this  = v;
  }
  @:from static inline public function fromReplyEventual<A>(rpl:stx.ifs.Reply<Eventual<A>>):Arrow<Unit,A>{
    //trace('fromReplyEventual');
    return fromEventualConstructor(function(u:Unit):Eventual<A>{
      return rpl.reply();
    });
  }
  @:from static inline public function fromEventualConstructor<A,B>(fn:A->Eventual<B>):Arrow<A,B>{
    //trace('fromEventualConstructor');
    return inline function(a:A,b:Consume<B>):Void{
      fn(a).foreach(b);
    }
  }
  @:from static inline public function fromEventualConstructor2<A,B,C>(fn:A->B->Eventual<C>):Arrow<Tuple2<A,B>,C>{
    //trace('fromEventualConstructor2');
    return inline function(a:Tuple2<A,B>,b:Consume<C>):Void{
      fn.spread()(a).foreach(b);
    }
  }
  @:from static inline public function fromEventualConstructor3<A,B,C,D>(fn:A->B->C->Eventual<D>):Arrow<Tuple3<A,B,C>,D>{
    //trace('fromEventualConstructor3');
    return inline function(a:Tuple3<A,B,C>,b:Consume<D>):Void{
      fn.spread()(a).foreach(b);
    }
  }
  @:from static inline public function fromEventualConstructor4<A,B,C,D,E>(fn:A->B->C->D->Eventual<E>):Arrow<Tuple4<A,B,C,D>,E>{
    //trace('fromEventualConstructor4');
    return inline function(a:Tuple4<A,B,C,D>,b:Consume<E>):Void{
      fn.spread()(a).foreach(b);
    }
  }
  @:from static inline public function fromEventualConstructor5<A,B,C,D,E,F>(fn:A->B->C->D->E->Eventual<F>):Arrow<Tuple5<A,B,C,D,E>,F>{
    //trace('fromEventualConstructor5');
    return inline function(a:Tuple5<A,B,C,D,E>,b:Consume<F>):Void{
      fn.spread()(a).foreach(b);
    }
  }
  @:from static inline public function fromEventualThunk<T:Eventual<A>,A>(fn:Void->T):Arrow<Unit,A>{
    //trace('fromThunk');
    return inline function(a:Unit,b:A->Void):Void{
      fn().foreach(b);
    }
  }
  @:from static inline public function fromThunk<A>(fn:Void->A):Arrow<Unit,A>{
    //trace('fromThunk');
    return inline function(a:Unit,b:A->Void):Void{
      b(fn());
    }
  }
  @:from static inline public function fromFunction<A,B>(fn:A->B):Arrow<A,B>{
    //trace('fromFunction');
    return inline function(a:A,b:B->Void):Void{
      //trace('called fromFunction');
      b(fn(a));
      /*untyped process.nextTick(
        function(){
          
        }
      );*/
    }
  }
  @:from static inline public function fromFunction2<A,B,C>(fn:A->B->C):Arrow<Tuple2<A,B>,C>{
    //trace('fromFunction2');
    return inline function(a:Tuple2<A,B>,b:C->Void):Void{
      b(fn.spread()(a));
    }
  }
  @:from static inline public function fromFunction3<A,B,C,D>(fn:A->B->C->D):Arrow<Tuple3<A,B,C>,D>{
    //trace('fromFunction3');
    return inline function(a:Tuple3<A,B,C>,b:D->Void):Void{
      b(fn.spread()(a));
    }
  }
  @:from static inline public function fromFunction4<A,B,C,D,E>(fn:A->B->C->D->E):Arrow<Tuple4<A,B,C,D>,E>{
    //trace('fromFunction4');
    return inline function(a:Tuple4<A,B,C,D>,b:E->Void):Void{
      b(fn.spread()(a));
    }
  }
  @:from static inline public function fromFunction5<A,B,C,D,E,F>(fn:A->B->C->D->E->F):Arrow<Tuple5<A,B,C,D,E>,F>{
    //trace('fromFunction5');
    return inline function(a:Tuple5<A,B,C,D,E>,b:F->Void):Void{
      b(fn.spread()(a));
    }
  }
  @:from static inline public function fromStateFunction<A,B>(fn:A->Tuple2<B,A>):Arrow<A,Tuple2<B,A>>{
    //trace('fromStateFunction');
    return inline function(a:A,b:Tuple2<B,A>->Void):Void{
      b(fn(a));
    }
  }
  /*@:from static inline public function fromReply<T:Reply<A>,A>(rpl:T):Arrow<Unit,A>{
    //trace('fromReply');
    return fromThunk(rpl.reply);
  }*/
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
  static public inline function apply<I,O>(arw:Arrow<I,O>,i:I):Eventual<O>{
    return Continuation.toEventual(withInput.bind(arw,i));
  }
  static public inline function reply<A>(arw:Arrow<Unit,A>):Eventual<A>{
    return apply(arw,Unit);
  }
  static public function then<A,B,C>(before:Arrow<A,B>, after:Arrow<B,C>):Arrow<A,C> { 
    //trace('then');
    return function(i : A, cont : Function1<C,Void>) : Void {
      //trace('thenl');
      function m(reta : B) { 
        //trace('thenr');
        withInput(after,reta, cont);
      };
      withInput(before,i, m);
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
      return withInput(pair(split_,_split),tuple2(i,i) , cont);
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
        withInput(pair_, i.fst() , hl );
        withInput(_pair, i.snd() , hr );
      }
  }
  static public function swap<A,B,C>(a:Arrow<A,Tuple2<B,C>>):Arrow<A,Tuple2<C,B>>{
    return then(a,Tuples2.swap);
  }
  static public function fan<I,O>(a:Arrow<I,O>):Arrow<I,Tuple2<O,O>>{
    return then(a,
      function(x:O):Tuple2<O,O>{
        return tuple2(x,x);
      }
    );
  }
  static public function pinch<I,O1,O2>(a:Arrow<Tuple2<I,I>,Tuple2<O1,O2>>):Arrow<I,Tuple2<O1,O2>>{
    return then(fan(Arrow.unit()),a);
  }
  static public function both<A,B>(a:Arrow<A,B>):Arrow<Tuple2<A,A>,Tuple2<B,B>>{
    return pair(a,a);
  }
  static public function as<A,B,C>(a:Arrow<A,B>,type:Class<C>):Arrow<A,C>{
    return then(a, function(x:B):C { return cast x; } ); 
  }
  static public function join<A,B,C>(joinl:Arrow<A,B>,joinr:Arrow<B,C>):Arrow<A,Tuple2<B,C>>{
    return then( joinl , split(Arrow.unit(),joinr) );
  }
  static public function tie<A,B,C>(bindl:Arrow<A,B>,bindr:Arrow<Tuple2<A,B>,C>):Arrow<A,C>{
    return then( split(Arrow.unit(),bindl) , bindr );
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
    return then(new LeftChoiceArrow(arr),Eithers.flattenL);
  }
  public static function option<I,O>(a:Arrow<I,O>):OptionArrow<I,O>{
    return new OptionArrow(a);
  }
  public static function exchange<I,O,N>(a:Arrow<I,O>,n:N):Arrow<I,N>{
    return then(a,
      function(x:O):N{
        return n;
      }
    );
  }
  static public function flatten<I,O>(arw:Arrow<Option<I>,Option<Option<O>>>):ArrowOption<I,O>{
    return then(arw, Options.flatten);
  }
  static public function fromMbe<I,O>(arw:Arrow<I,Option<O>>):ArrowOption<I,O>{
    return flatten(option(arw));
  }
  static public function printA<A,B>(a:Arrow<A,B>):Arrow<A,B>{
    var m : Function1<B,B> = function(x:B):B { haxe.Log.trace(x) ; return x;};
    return new ThenArrow( a, m );
  }
  static public function invoke<A,B,C>(a:Arrow<A,B>,b:Thunk<Arrow<B,C>>){
    return then(a,
      function(x:B){
        var n = b();
        return apply(n,x);
      }
    );
  }
  static public function invokeWith<B,C,D>(b:Arrow<B,Arrow<C,D>>,inpt:C):Arrow<B,D>{
    return then(b,
      function(arw:Arrow<C,D>){
        return apply(arw,inpt);
      }
    );
  }
  static public function uncurry<A,B,C>(a:Arrow<A,Arrow<B,C>>):Arrow<Tuple2<A,B>,C>{
    return function(tp:Tuple2<A,B>){
      return apply(a,tp.fst()).flatMap(
        function(a0){
          return apply(a0,tp.snd());
        }
      );
    }
  }
  @:noUsing static public function state<S,A>(a:Arrow<S,Tuple2<A,S>>):ArrowState<S,A>{
    return a;
  }
  @:noUsing static public function application<I,O>():ApplyArrow<I,O>{
    return inline function(i:Tuple2<Arrow<I,O>,I>,cont : O->Void){
        Arrows.withInput(i.fst(),
          i.snd(),
            function(x:O):Void{
              cont(x);
            }
        );
      }
  }
  static public function lazy<T>(arw:Arrow<Unit,T>):Arrow<Unit,T>{
    var evt : Eventual<T> = null;
    return function(x:Unit){
      if(evt!=null){
        return evt;
      }
      return evt = apply(arw,Unit);
    }
  }
}
class EventualArrows{
  public static function arrow<I>(p:Eventual<I>):Arrow<Unit,I>{
    return function(u:Unit){ return p; }
  }
}
/*class CallbackTypeArrows{
  static public function lift<A,B>(fn:A->B->Void):Arrow<A,B>{
    return Arrow.fromCallbackTypeConstructor(fn);
  }
}*/