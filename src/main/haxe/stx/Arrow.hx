package stx;

import stx.type.*;
import Stax.*;
import haxe.Constraints;


import stx.ifs.Reply;

import stx.Compare.*;

import stx.Assert.*;

import stx.Fail;
import stx.Log.*;
import stx.Tuples;
import Prelude;
import stx.arw.OptionArrow;
import stx.arw.StateArrow;
import stx.arw.*;

import stx.Either;
import stx.Option;

using stx.Tuples;

enum Free<A, B>{
  Cont(v:A);
  Done(v:B);
}
typedef ArrowType<A,B>  = A -> (B->Void) -> Void;

abstract Arrow<I,O>(ArrowType<I,O>) from ArrowType<I,O>{
  @doc("Externally accessible constructor.")
  static public inline function arw<A>():Arrow<A,A>{
    return unit();
  }
  @doc("Simple case, return the input.")
  @:noUsing static public function unit<A>():Arrow<A,A>{
    return function(a:A,cont:A->Void):Void{
      cont(a);
    }
  }
  @doc("Produces an arrow returning `v`.")
  @:noUsing static public function pure<A,B>(v:B):Arrow<A,B>{
    return function(a:A,cont:B->Void):Void{
      cont(v);
    }
  }
  public function new(v:I -> (O->Void) -> Void){
    this  = v;
  }
  @:from static inline public function fromFn<A,B,C,D:(ArrowType<B,C>,Function)>(fn:A -> Tuple2<D,B>):Arrow<A,C>{
    return new Arrow(function(a:A,cont:C->Void):Void{
      var cont0 : Tuple2<D,B> -> Void 
      =  function(next:Tuple2<D,B>){
        Arrows.withInput(next.fst(),next.snd(),cont);
      }
      cont0(fn(a));
    });
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
      b(fn.tupled()(a));
    }
  }
  @:from static inline public function fromFunction3<A,B,C,D>(fn:A->B->C->D):Arrow<Tuple3<A,B,C>,D>{
    //trace('fromFunction3');
    return inline function(a:Tuple3<A,B,C>,b:D->Void):Void{
      b(fn.tupled()(a));
    }
  }
  @:from static inline public function fromFunction4<A,B,C,D,E>(fn:A->B->C->D->E):Arrow<Tuple4<A,B,C,D>,E>{
    //trace('fromFunction4');
    return inline function(a:Tuple4<A,B,C,D>,b:E->Void):Void{
      b(fn.tupled()(a));
    }
  }
  @:from static inline public function fromFunction5<A,B,C,D,E,F>(fn:A->B->C->D->E->F):Arrow<Tuple5<A,B,C,D,E>,F>{
    //trace('fromFunction5');
    return inline function(a:Tuple5<A,B,C,D,E>,b:F->Void):Void{
      b(fn.tupled()(a));
    }
  }
  @:from static inline public function fromStateFunction<A,B>(fn:A->Tuple2<B,A>):Arrow<A,Tuple2<B,A>>{
    //trace('fromStateFunction');
    return inline function(a:A,b:Tuple2<B,A>->Void):Void{
      b(fn(a));
    }
  }
  public inline function asFunction():ArrowType<I,O>{
    return this;
  }
}
class Arrows{
  static public function action<I>(fn:I->Void):Arrow<I,I>{
    return function(x:I){
      fn(x); return x;
    }
  }
  @doc("Arrow application primitive. Calls Arrow with `i` and places result in `cont`.")
  static public inline function withInput<I,O>(arw:Arrow<I,O>,i:I,cont:O->Void):Void{
    arw.asFunction()(i,cont);
  }
  static public inline function proceed<I,O>(arw:Arrow<I,O>,i:I):Continuation<Void,O>{
    return withInput.bind(arw,i);
  }
  // static public inline function apply<I,O>(arw:Arrow<I,O>,i:I):Future<Void,O>{
  //   return withInput.bind(arw,i);
  // }
  @doc("left to right composition of Arrows. Produces an Arrow running `before` and placing it's value in `after`.")
  static public function then<A,B,C>(before:Arrow<A,B>, after:Arrow<B,C>):Arrow<A,C> { 
    /*assert(before);
    assert(after);*/
    return function(i : A, cont : C->Void) : Void {
      assert(cont,fail(ArgumentError('continuation function should not be null')));
      function m(reta : B) { 
        withInput(after,reta, cont);
      };
      withInput(before,i, m);
    }
  }
  @doc("Takes an Arrow<A,B>, and produces one taking a Tuple2 that runs the Arrow on the left-hand side, leaving the right-handside untouched.")
  static public function first<A,B,C>(first:Arrow<A,B>):Arrow<Tuple2<A,C>,Tuple2<B,C>>{
    return pair(first, Arrow.unit());
  }
  @doc("Takes an Arrow<A,B>, and produces one taking a Tuple2 that runs the Arrow on the right-hand side, leaving the left-hand side untouched.")
  static public function second<A,B,C>(second:Arrow<A,B>):Arrow<Tuple2<C,A>,Tuple2<C,B>>{
    return pair(Arrow.unit(), second);
  }
  @doc("Takes two Arrows with the same input type, and produces one which applies each Arrow with thesame input.
  ")
  static public function split<A, B, C>(split_:Arrow<A, B>, _split:Arrow<A, C>):Arrow<A, Tuple2<B,C>> { 
    return function(i:A, cont:Tuple2<B,C>->Void) : Void{
      return withInput(pair(split_,_split),tuple2(i,i) , cont);
    };
  }
  @doc("Takes two Arrows and produces on that runs them in parallel, waiting for both responses before output.")
  static public function pair<A,B,C,D>(pair_:Arrow<A,B>,_pair:Arrow<C,D>):Arrow<Tuple2<A,C>, Tuple2<B,D>> { 
    return function(i: Tuple2<A,C>, cont: Tuple2<B,D>->Void ): Void {
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
  @doc("Changes <B,C> to <C,B> on the output of an Arrow")
  static public function swap<A,B,C>(a:Arrow<A,Tuple2<B,C>>):Arrow<A,Tuple2<C,B>>{
    return then(a,Tuples2.swap);
  }
  @doc("Produces a Tuple2 output of any Arrow.")
  static public function fan<I,O>(a:Arrow<I,O>):Arrow<I,Tuple2<O,O>>{
    return then(a,
      function(x:O):Tuple2<O,O>{
        return tuple2(x,x);
      }
    );
  }
  @doc("Pinches the input stage of an Arrow. `<I,I>` as `<I>`")
  static public function pinch<I,O1,O2>(a:Arrow<Tuple2<I,I>,Tuple2<O1,O2>>):Arrow<I,Tuple2<O1,O2>>{
    return then(fan(Arrow.unit()),a);
  }
  @doc("Produces an Arrow that runs the same Arrow on both sides of a Tuple2")
  static public function both<A,B>(a:Arrow<A,B>):Arrow<Tuple2<A,A>,Tuple2<B,B>>{
    return pair(a,a);
  }
  @doc("Casts the output of an Arrow to `type`.")
  static public function as<A,B,C>(a:Arrow<A,B>,type:Class<C>):Arrow<A,C>{
    return then(a, function(x:B):C { return cast x; } ); 
  }
  @doc("Runs the first Arrow, then the second, preserving the output of the first on the left-hand side.")
  static public function join<A,B,C>(joinl:Arrow<A,B>,joinr:Arrow<B,C>):Arrow<A,Tuple2<B,C>>{
    return then( joinl , split(Arrow.unit(),joinr) );
  }
  @doc("Runs the first Arrow and places the input of that Arrow and the output in the second Arrow.")
  static public function tie<A,B,C>(bindl:Arrow<A,B>,bindr:Arrow<Tuple2<A,B>,C>):Arrow<A,C>{
    return then( split(Arrow.unit(),bindl) , bindr );
  }
  @doc("Runs an Arrow until it returns Done(out).")
  static public function repeat<I,O> (a:Arrow<I,Free<I,O>>):Arrow<I,O>{
    return new RepeatArrow(a);
  }
  @doc("Produces an Arrow that will run `or_` if the input is Left(in), or '_or' if the input is Right(in);")
  static public function or<P1,P2,R0>(or_:Arrow<P1,R0>,_or:Arrow<P2,R0>):Arrow<Either<P1,P2>,R0>{
      return new OrArrow(or_, _or);
  }
  @doc("Produces an Arrow that will run only if the input is Left.")
  public static function left<B,C,D>(arr:Arrow<B,C>):Arrow<Either<B,D>,Either<C,D>>{
    return new LeftChoiceArrow(arr);
  }
  @doc("Produces an Arrow that returns a value from the first completing Arrow.")
  public static function either<A,B>(a:Arrow<A,B>,b:Arrow<A,B>):Arrow<A,B>{
    return new EitherArrow(a,b);
  }
  @doc("Produces an Arrow that will run only if the input is Right.")
  public static function right<B,C,D>(arr:Arrow<B,C>):Arrow<Either<D,B>,Either<D,C>>{
    return new RightChoiceArrow(arr);
  }
  @doc("Takes an Arrow that produces an Either, and produces one that will run that Arrow if the input is Right.")
  public static function fromR<A,B,C,D>(arr:Arrow<B,Either<C,D>>):Arrow<Either<C,B>,Either<C,D>>{
    return new RightSwitchArrow(arr);
  }
  @doc("Takes an Arrow that produces an Either, and produces one that will run that Arrow if the input is Left.")
  public static function fromL<A,B,C,D>(arr:Arrow<A,Either<C,D>>):Arrow<Either<A,D>,Either<C,D>>{
    return then(new LeftChoiceArrow(arr),Eithers.flattenL);
  }
  @doc("Produces an Arrow that is applied if the input is Some.")
  public static function option<I,O>(a:Arrow<I,O>):Arrow<Option<I>,Option<O>>{
    return new OptionArrow(a);
  }
  @doc("Produces an Arrow that patches the output with `n`.")
  public static function exchange<I,O,N>(a:Arrow<I,O>,n:N):Arrow<I,N>{
    return then(a,
      function(x:O):N{
        return n;
      }
    );
  }
  @doc("Flattens the output of an Arrow where it is Option<Option<O>> ")
  static public function flatten<I,O>(arw:Arrow<Option<I>,Option<Option<O>>>):ArrowOption<I,O>{
    return then(arw, Options.flatten);
  }
  @doc("Takes an Arrow that produces an Option and returns one that takes an Option also.")
  static public function fromOption<I,O>(arw:Arrow<I,Option<O>>):ArrowOption<I,O>{
    return flatten(option(arw));
  }
  @doc("Print the output of an Arrow")
  static public function printA<A,B>(a:Arrow<A,B>):Arrow<A,B>{
    var m : B->B = function(x:B):B { haxe.Log.trace(x) ; return x;};
    return new ThenArrow( a, m );
  }
  @doc("Runs a `then` operation where the creation of the second arrow requires a function call to produce it.")
  static public function invoke<A,B,C>(a:Arrow<A,B>,b:Thunk<Arrow<B,C>>){
    return then(a,
      function(x:B){
        var n = b();
        return tuple2(n,x);
      }
    );
  }
  @:noUsing static public function state<S,A>(a:Arrow<S,Tuple2<A,S>>):ArrowState<S,A>{
    return a;
  }
  @doc("Returns an ApplyArrow.")
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
  @doc("Delay an Arrow.")
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