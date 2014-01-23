package stx.async;

import Prelude;

import stx.type.*;
import Stax.*;
import haxe.Constraints;


import stx.ifs.Reply;

import stx.Compare.*;

import stx.test.Assert.*;

import stx.Fail;
import stx.io.Log.*;
import stx.Tuples;

import stx.Either;
import stx.Option;

import stx.async.arrowlet.*;
import stx.async.arrowlet.Option;
import stx.async.arrowlet.State;
import stx.async.arrowlet.Either;

import stx.reactive.Handler;

using stx.Tuples;

typedef ArrowletType<A,B>  = A -> (B->Void) -> Void;

abstract Arrowlet<I,O>(ArrowletType<I,O>) from ArrowletType<I,O>{
  @doc("Externally accessible constructor.")
  static public inline function arw<A>():Arrowlet<A,A>{
    return unit();
  }
  @doc("Simple case, return the input.")
  @:noUsing static public function unit<A>():Arrowlet<A,A>{
    return function(a:A,cont:A->Void):Void{
      cont(a);
    }
  }
  @doc("Produces an arrow returning `v`.")
  @:noUsing static public function pure<A,B>(v:B):Arrowlet<A,B>{
    return function(a:A,cont:B->Void):Void{
      cont(v);
    }
  }
  public function new(v:I -> (O->Void) -> Void){
    this  = v;
  }
  @:from static inline public function fromFn<A,B,C,D:(ArrowletType<B,C>,Function)>(fn:A -> Tuple2<D,B>):Arrowlet<A,C>{
    return new Arrowlet(function(a:A,cont:C->Void):Void{
      var cont0 : Tuple2<D,B> -> Void 
      =  function(next:Tuple2<D,B>){
        Arrowlets.withInput(next.fst(),next.snd(),cont);
      }
      cont0(fn(a));
    });
  }
  @:from static inline public function fromFunction<A,B>(fn:A->B):Arrowlet<A,B>{
    //trace('fromFunction');
    return inline function(a:A,b:B->Void):Void{
      //trace('called fromFunction');
      b(fn(a));
    }
  }
  @:from static inline public function fromEndo<A>(fn:A->A):Arrowlet<A,A>{
    return fromFunction(fn);
  }
  @:from static inline public function fromFunction2<A,B,C>(fn:A->B->C):Arrowlet<Tuple2<A,B>,C>{
    //trace('fromFunction2');
    return inline function(a:Tuple2<A,B>,b:C->Void):Void{
      b(fn.tupled()(a));
    }
  }
  @:from static inline public function fromFunction3<A,B,C,D>(fn:A->B->C->D):Arrowlet<Tuple3<A,B,C>,D>{
    //trace('fromFunction3');
    return inline function(a:Tuple3<A,B,C>,b:D->Void):Void{
      b(fn.tupled()(a));
    }
  }
  @:from static inline public function fromFunction4<A,B,C,D,E>(fn:A->B->C->D->E):Arrowlet<Tuple4<A,B,C,D>,E>{
    //trace('fromFunction4');
    return inline function(a:Tuple4<A,B,C,D>,b:E->Void):Void{
      b(fn.tupled()(a));
    }
  }
  @:from static inline public function fromFunction5<A,B,C,D,E,F>(fn:A->B->C->D->E->F):Arrowlet<Tuple5<A,B,C,D,E>,F>{
    //trace('fromFunction5');
    return inline function(a:Tuple5<A,B,C,D,E>,b:F->Void):Void{
      b(fn.tupled()(a));
    }
  }
  @:from static inline public function fromStateFunction<A,B>(fn:A->Tuple2<B,A>):Arrowlet<A,Tuple2<B,A>>{
    //trace('fromStateFunction');
    return inline function(a:A,b:Tuple2<B,A>->Void):Void{
      b(fn(a));
    }
  }
  public inline function asFunction():ArrowletType<I,O>{
    return this;
  }
}
class Arrowlets{
  @doc("Arrowlet application primitive. Calls Arrowlet with `i` and places result in `cont`.")
  static public inline function withInput<I,O>(arw:Arrowlet<I,O>,i:I,cont:O->Void):Void{
    arw.asFunction()(i,cont);
  }
  static public inline function proceed<I,O>(arw:Arrowlet<I,O>,i:I):stx.async.Continuation<Void,O>{
    return withInput.bind(arw,i);
  }
  static public inline function augure<I,O>(arw:Arrowlet<I,O>,i:I):Future<O>{
    return withInput.bind(arw,i);
  }
  static public inline function apply<I,O>(arw:Arrowlet<I,O>,i:I):stx.async.Eventual<O>{
    var evt : stx.async.Eventual<O> = stx.async.Eventual.unit();
    proceed(arw,i).apply(evt.deliver);
    return evt;
  }
  @doc("left to right composition of Arrowlets. Produces an Arrowlet running `before` and placing it's value in `after`.")
  static public function then<A,B,C>(before:Arrowlet<A,B>, after:Arrowlet<B,C>):Arrowlet<A,C> { 
    /*assert(before);
    assert(after);*/
    return function(i : A, cont : C->Void) : Void {
      assert(cont,fail(IllegalOperationError('continuation function should not be null')));
      function m(reta : B) { 
        withInput(after,reta, cont);
      };
      withInput(before,i, m);
    }
  }
  @doc("Takes an Arrowlet<A,B>, and produces one taking a Tuple2 that runs the Arrowlet on the left-hand side, leaving the right-handside untouched.")
  static public function first<A,B,C>(first:Arrowlet<A,B>):Arrowlet<Tuple2<A,C>,Tuple2<B,C>>{
    return pair(first, Arrowlet.unit());
  }
  @doc("Takes an Arrowlet<A,B>, and produces one taking a Tuple2 that runs the Arrowlet on the right-hand side, leaving the left-hand side untouched.")
  static public function second<A,B,C>(second:Arrowlet<A,B>):Arrowlet<Tuple2<C,A>,Tuple2<C,B>>{
    return pair(Arrowlet.unit(), second);
  }
  @doc("Takes two Arrowlets with the same input type, and produces one which applies each Arrowlet with thesame input.
  ")
  static public function split<A, B, C>(split_:Arrowlet<A, B>, _split:Arrowlet<A, C>):Arrowlet<A, Tuple2<B,C>> { 
    return function(i:A, cont:Tuple2<B,C>->Void) : Void{
      return withInput(pair(split_,_split),tuple2(i,i) , cont);
    };
  }
  @doc("Takes two Arrowlets and produces on that runs them in parallel, waiting for both responses before output.")
  static public function pair<A,B,C,D>(pair_:Arrowlet<A,B>,_pair:Arrowlet<C,D>):Arrowlet<Tuple2<A,C>, Tuple2<B,D>> { 
    return function(i: Tuple2<A,C>, cont: Tuple2<B,D>->Void ): Void {
        var ol : Prelude.Option<B>   = null;
        var or : Prelude.Option<D>   = null;

        var merge   =
          function(l:B,r:D){
            cont( tuple2(l,r) );
          }
        var check   =
          function(){
            if (((ol!=null) && (or!=null))){
              merge(Options.valOrC(ol,null),Options.valOrC(or,null));
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
  @doc("Changes <B,C> to <C,B> on the output of an Arrowlet")
  static public function swap<A,B,C>(a:Arrowlet<A,Tuple2<B,C>>):Arrowlet<A,Tuple2<C,B>>{
    return then(a,Tuples2.swap);
  }
  @doc("Produces a Tuple2 output of any Arrowlet.")
  static public function fan<I,O>(a:Arrowlet<I,O>):Arrowlet<I,Tuple2<O,O>>{
    return then(a,
      function(x:O):Tuple2<O,O>{
        return tuple2(x,x);
      }
    );
  }
  @doc("Pinches the input stage of an Arrowlet. `<I,I>` as `<I>`")
  static public function pinch<I,O1,O2>(a:Arrowlet<Tuple2<I,I>,Tuple2<O1,O2>>):Arrowlet<I,Tuple2<O1,O2>>{
    return then(fan(Arrowlet.unit()),a);
  }
  @doc("Produces an Arrowlet that runs the same Arrowlet on both sides of a Tuple2")
  static public function both<A,B>(a:Arrowlet<A,B>):Arrowlet<Tuple2<A,A>,Tuple2<B,B>>{
    return pair(a,a);
  }
  @doc("Casts the output of an Arrowlet to `type`.")
  static public function as<A,B,C>(a:Arrowlet<A,B>,type:Class<C>):Arrowlet<A,C>{
    return then(a, function(x:B):C { return cast x; } ); 
  }
  @doc("Runs the first Arrowlet, then the second, preserving the output of the first on the left-hand side.")
  static public function join<A,B,C>(joinl:Arrowlet<A,B>,joinr:Arrowlet<B,C>):Arrowlet<A,Tuple2<B,C>>{
    return then( joinl , split(Arrowlet.unit(),joinr) );
  }
  @doc("Runs the first Arrowlet and places the input of that Arrowlet and the output in the second Arrowlet.")
  static public function tie<A,B,C>(bindl:Arrowlet<A,B>,bindr:Arrowlet<Tuple2<A,B>,C>):Arrowlet<A,C>{
    return then( split(Arrowlet.unit(),bindl) , bindr );
  }
  @doc("Runs an Arrowlet until it returns Done(out).")
  static public function repeat<I,O>(a:Arrowlet<I,Free<I,O>>):Arrowlet<I,O>{
    return new Repeat(a);
  }
  @doc("Produces an Arrowlet that will run `or_` if the input is Left(in), or '_or' if the input is Right(in);")
  static public function or<P1,P2,R0>(or_:Arrowlet<P1,R0>,_or:Arrowlet<P2,R0>):Arrowlet<Prelude.Either<P1,P2>,R0>{
    return new Or(or_, _or);
  }
  @doc("Produces an Arrowlet that will run only if the input is Left.")
  public static function left<B,C,D>(arr:Arrowlet<B,C>):Arrowlet<Prelude.Either<B,D>,Prelude.Either<C,D>>{
    return new LeftChoice(arr);
  }
  @doc("Produces an Arrowlet that returns a value from the first completing Arrowlet.")
  public static function either<A,B>(a:Arrowlet<A,B>,b:Arrowlet<A,B>):Arrowlet<A,B>{
    return new Either(a,b);
  }
  @doc("Produces an Arrowlet that will run only if the input is Right.")
  public static function right<B,C,D>(arr:Arrowlet<B,C>):Arrowlet<Prelude.Either<D,B>,Prelude.Either<D,C>>{
    return new RightChoice(arr);
  }
  @doc("Takes an Arrowlet that produces an Either, and produces one that will run that Arrowlet if the input is Right.")
  public static function fromRight<A,B,C,D>(arr:Arrowlet<B,Prelude.Either<C,D>>):Arrowlet<Prelude.Either<C,B>,Prelude.Either<C,D>>{
    return new RightSwitch(arr);
  }
  @doc("Takes an Arrowlet that produces an Either, and produces one that will run that Arrowlet if the input is Left.")
  public static function fromLeft<A,B,C,D>(arr:Arrowlet<A,Prelude.Either<C,D>>):Arrowlet<Prelude.Either<A,D>,Prelude.Either<C,D>>{
    return then(new LeftChoice(arr),Eithers.flattenL);
  }
  @doc("Produces an Arrowlet that is applied if the input is Some.")
  public static function option<I,O>(a:Arrowlet<I,O>):Arrowlet<Prelude.Option<I>,Prelude.Option<O>>{
    return new Option(a);
  }
  @doc("Produces an Arrowlet that patches the output with `n`.")
  public static function exchange<I,O,N>(a:Arrowlet<I,O>,n:N):Arrowlet<I,N>{
    return then(a,
      function(x:O):N{
        return n;
      }
    );
  }
  @doc("Flattens the output of an Arrowlet where it is Option<Option<O>> ")
  static public function flatten<I,O>(arw:Arrowlet<Prelude.Option<I>,Prelude.Option<Prelude.Option<O>>>):Option<I,O>{
    return then(arw, Options.flatten);
  }
  @doc("Takes an Arrowlet that produces an Option and returns one that takes an Option also.")
  static public function fromOption<I,O>(arw:Arrowlet<I,Prelude.Option<O>>):Option<I,O>{
    return flatten(option(arw));
  }
  @doc("Print the output of an Arrowlet")
  static public function printA<A,B>(a:Arrowlet<A,B>):Arrowlet<A,B>{
    var m : B->B = function(x:B):B { haxe.Log.trace(x) ; return x;};
    return new Then( a, m );
  }
  @doc("Runs a `then` operation where the creation of the second arrow requires a function call to produce it.")
  static public function invoke<A,B,C>(a:Arrowlet<A,B>,b:Thunk<Arrowlet<B,C>>){
    return then(a,
      function(x:B){
        var n = b();
        return tuple2(n,x);
      }
    );
  }
  @:noUsing static public function state<S,A>(a:Arrowlet<S,Tuple2<A,S>>):ArrowletState<S,A>{
    return a;
  }
  @doc("Returns an ApplyArrowlet.")
  @:noUsing static public function application<I,O>():Apply<I,O>{
    return inline function(i:Tuple2<Arrowlet<I,O>,I>,cont : O->Void){
        Arrowlets.withInput(i.fst(),
          i.snd(),
            function(x:O):Void{
              cont(x);
            }
        );
      }
  }
  static public function delay<A>(ms:Int):Arrowlet<A,A>{
    var out = function(i,cont){
    hx.Timer.wait(
        function(){
          cont(i);
        },ms);
    }     
    return out;
  }
}