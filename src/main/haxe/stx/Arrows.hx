package stx;

import haxe.Constraints;

using stx.Tuples;

import stx.ifs.Reply;

import stx.Log.*;
import stx.Tuples;
import stx.Prelude;
import stx.arw.OptionArrow;
import stx.arw.StateArrow;
import stx.arw.*;

import stx.Eithers;

typedef Consume<A>      = A -> Void;
typedef ArrowType<A,B>  = A -> (B->Void) -> Void;

abstract Arrow<I,O>(ArrowType<I,O>) from ArrowType<I,O>{
  /**
    Externally accessible constructor.
  */
  static public inline function arw<A>():Arrow<A,A>{
    return unit();
  }
  /**
    Simple case, return the input.
  */
  @:noUsing static public function unit<A>():Arrow<A,A>{
    return function(a:A,cont:A->Void):Void{
      cont(a);
    }
  }
  /*
    Produces an arrow returning `v`.
  */
  @:noUsing static public function pure<A,B>(v:B):Arrow<A,B>{
    return function(a:A,cont:B->Void):Void{
      cont(v);
    }
  }
  /*
    Produces an Arrow<Unit,A> from a Thunk<Eventual<A>>
  */
  @:from static inline public function fromUnitEventualConstructor<A>(fn:Void->Eventual<A>):Arrow<Unit,A>{
    return inline function(a:Unit,b:A->Void):Void{
      fn().foreach(b);
    }
  }
  public function new(v){
    this  = v;
  }
  /*
    Produces an Arrow from a reply
  */
  @:bug('#0b1kn00b: why does this not work?')
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
  @:from static inline public function fromEventualThunk<A>(fn:Void->Eventual<A>):Arrow<Unit,A>{
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
  /**
    Arrow application primitive. Calls Arrow with `i` and places result in `cont`.
  */
  static public inline function withInput<I,O>(arw:Arrow<I,O>,i:I,cont:O->Void):Void{
    arw.asFunction()(i,cont);
  }
  /**
    Applies an Arrow and returns an Eventual that will contain the output.
  */
  static public inline function apply<I,O>(arw:Arrow<I,O>,i:I):Eventual<O>{
    return Continuation.toEventual(withInput.bind(arw,i));
  }
  /**
    Applies an Arrow, returning a callback consumer.
  */
  /*static public inline function partial<I,O>(arw:Arrow<I,O>,i:I):Future<O>{
    return withInput.bind(arw,i);
  }*/
  /**
    Applies an Arrow<Unit,A>, returning an Eventual.
  */
  static public inline function reply<A>(arw:Arrow<Unit,A>):Eventual<A>{
    return apply(arw,Unit);
  }
  /**
    left to right composition of Arrows. Produces an Arrow running `before` and placing it's value in `after`.
  */
  static public function then<A,B,C>(before:Arrow<A,B>, after:Arrow<B,C>):Arrow<A,C> { 
    return function(i : A, cont : Function1<C,Void>) : Void {
      function m(reta : B) { 
        withInput(after,reta, cont);
      };
      withInput(before,i, m);
    }
  }
  /**
    Takes an Arrow<A,B>, and produces one taking a Tuple2 that runs the Arrow on the left-hand side, leaving the right-hand
    side untouched.
  */
  static public function first<A,B,C>(first:Arrow<A,B>):Arrow<Tuple2<A,C>,Tuple2<B,C>>{
    return pair(first, Arrow.unit());
  }
  /**
    Takes an Arrow<A,B>, and produces one taking a Tuple2 that runs the Arrow on the right-hand side, leaving the left-hand 
    side untouched.
  */
  static public function second<A,B,C>(second:Arrow<A,B>):Arrow<Tuple2<C,A>,Tuple2<C,B>>{
    return pair(Arrow.unit(), second);
  }
  /**
    Takes two Arrows with the same input type, and produces one which applies each Arrow with the
    same input.
  */
  static public function split<A,B,C>(split_:Arrow<A,B>,_split:Arrow<A,C>):Arrow<A,Tuple2<B,C>> { 
    return function(i:A, cont:Tuple2<B,C>->Void) : Void{
      return withInput(pair(split_,_split),tuple2(i,i) , cont);
    };
  }
  /**
    Takes two Arrows and produces on that runs them in parallel, waiting for both responses before output.
  */
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
  /**
    Changes <B,C> to <C,B> on the output of an Arrow
  */
  static public function swap<A,B,C>(a:Arrow<A,Tuple2<B,C>>):Arrow<A,Tuple2<C,B>>{
    return then(a,Tuples2.swap);
  }
  /**
    Produces a Tuple2 output of any Arrow.
  */
  static public function fan<I,O>(a:Arrow<I,O>):Arrow<I,Tuple2<O,O>>{
    return then(a,
      function(x:O):Tuple2<O,O>{
        return tuple2(x,x);
      }
    );
  }
  /*
    Pinches the input stage of an Arrow. <I,I> as <I>
  */
  static public function pinch<I,O1,O2>(a:Arrow<Tuple2<I,I>,Tuple2<O1,O2>>):Arrow<I,Tuple2<O1,O2>>{
    return then(fan(Arrow.unit()),a);
  }
  /**
    Produces an Arrow that runs the same Arrow on both sides of a Tuple2
  */
  static public function both<A,B>(a:Arrow<A,B>):Arrow<Tuple2<A,A>,Tuple2<B,B>>{
    return pair(a,a);
  }
  /**
    Casts the output of an Arrow to `type`.
  */
  static public function as<A,B,C>(a:Arrow<A,B>,type:Class<C>):Arrow<A,C>{
    return then(a, function(x:B):C { return cast x; } ); 
  }
  /*
    Runs the first Arrow, then the second, preserving the output of the first on the left-hand side.
  */
  static public function join<A,B,C>(joinl:Arrow<A,B>,joinr:Arrow<B,C>):Arrow<A,Tuple2<B,C>>{
    return then( joinl , split(Arrow.unit(),joinr) );
  }
  /**
    Runs the first Arrow and places the input of that Arrow and the output in the second Arrow.
  */
  static public function tie<A,B,C>(bindl:Arrow<A,B>,bindr:Arrow<Tuple2<A,B>,C>):Arrow<A,C>{
    return then( split(Arrow.unit(),bindl) , bindr );
  }
  /**
    Runs an Arrow until it returns Done(out).
  */
  static public function repeat<I,O> (a:Arrow<I,FreeM<I,O>>):Arrow<I,O>{
    return new RepeatArrow(a);
  }
  /**
    Produces an Arrow that will run `or_` if the input is Left(in), or '_or' if the input is Right(in);
  */
  static public function or<P1,P2,R0>(or_:Arrow<P1,R0>,_or:Arrow<P2,R0>):Arrow<Either<P1,P2>,R0>{
      return new OrArrow(or_, _or);
  }
  /**
    Produces an Arrow that will run only if the input is Left.
  */
  public static function left<B,C,D>(arr:Arrow<B,C>):Arrow<Either<B,D>,Either<C,D>>{
    return new LeftChoiceArrow(arr);
  }
  /**
    Produces an Arrow that returns a value from the first completing Arrow.
  */
  public static function either<A,B>(a:Arrow<A,B>,b:Arrow<A,B>):Arrow<A,B>{
    return new EitherArrow(a,b);
  }
  /**
    Produces an Arrow that will run only if the input is Right.
  */
  public static function right<B,C,D>(arr:Arrow<B,C>):Arrow<Either<D,B>,Either<D,C>>{
    return new RightChoiceArrow(arr);
  }
  /**
    Takes an Arrow that produces an Either, and produces one that will run that Arrow if the input is Right.
  */
  public static function fromR<A,B,C,D>(arr:Arrow<B,Either<C,D>>):Arrow<Either<C,B>,Either<C,D>>{
    return new RightSwitchArrow(arr);
  }
  /**
    Takes an Arrow that produces an Either, and produces one that will run that Arrow if the input is Left.
  */
  public static function fromL<A,B,C,D>(arr:Arrow<A,Either<C,D>>):Arrow<Either<A,D>,Either<C,D>>{
    return then(new LeftChoiceArrow(arr),Eithers.flattenL);
  }
  /**
    Produces an Arrow that is applied if the input is Some.
  */
  public static function option<I,O>(a:Arrow<I,O>):OptionArrow<I,O>{
    return new OptionArrow(a);
  }
  /**
    Produces an Arrow that patches the output with `n`.
  */
  public static function exchange<I,O,N>(a:Arrow<I,O>,n:N):Arrow<I,N>{
    return then(a,
      function(x:O):N{
        return n;
      }
    );
  }
  /**
    Flattens the output of an Arrow where it is Option<Option<O>> 
  */
  static public function flatten<I,O>(arw:Arrow<Option<I>,Option<Option<O>>>):ArrowOption<I,O>{
    return then(arw, Options.flatten);
  }
  /**
    Takes an Arrow that produces an Option and returns one that takes an Option also.
  */
  static public function fromOption<I,O>(arw:Arrow<I,Option<O>>):ArrowOption<I,O>{
    return flatten(option(arw));
  }
  /**
    Print the output of an Arrow
  */
  static public function printA<A,B>(a:Arrow<A,B>):Arrow<A,B>{
    var m : Function1<B,B> = function(x:B):B { haxe.Log.trace(x) ; return x;};
    return new ThenArrow( a, m );
  }
  /**
    Runs a `then` operation where the creation of the second arrow requires a function call to produce it.
  */
  static public function invoke<A,B,C>(a:Arrow<A,B>,b:Thunk<Arrow<B,C>>){
    return then(a,
      function(x:B){
        var n = b();
        return apply(n,x);
      }
    );
  }
  /**
    Runs a `then` operation where the creation of the second arrow requires a function call (with `input`) to create it.
  */
  static public function invokeWith<B,C,D>(b:Arrow<B,Arrow<C,D>>,inpt:C):Arrow<B,D>{
    return then(b,
      function(arw:Arrow<C,D>){
        return apply(arw,inpt);
      }
    );
  }
  /**
    Uncurry an Arrow.
  */
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
  /**
    Returns an ApplyArrow
  */
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
  /**
    Returns an Arrow that memoizes it's output.
  */
  static public function memo<T>(arw:Arrow<Unit,T>):Arrow<Unit,T>{
    var evt : Eventual<T> = null;
    return Arrow.fromEventualConstructor( function(x:Unit):Eventual<T>{
      if(evt!=null){
        return evt;
      }
      evt = Arrows.apply(arw,Unit);
      return evt;
    });
  }
  /**
    Delay an Arrow.
  */
  #if (flash || js)
  static public function delay<A>(ms:Int):Arrow<A,A>{
    var out = function(i,cont){
    haxe.Timer.delay(
        function(){
          cont(i);
        },ms);
    }     
    return out;
  }
  #end
}
class EventualArrows{
  static public function toArrow<I>(p:Eventual<I>):Arrow<Unit,I>{
    return function(u:Unit,fn:I->Void){ 
      p.foreach(fn);
    }
  }
  static public function lift<I,O>(fn:I->Eventual<O>):Arrow<I,O>{
    return function(i:I,cont:O->Void){
      fn(i).foreach(cont);
    }
  }
}
/*class CallbackTypeArrows{
  static public function lift<A,B>(fn:A->B->Void):Arrow<A,B>{
    return Arrow.fromCallbackTypeConstructor(fn);
  }
}*/