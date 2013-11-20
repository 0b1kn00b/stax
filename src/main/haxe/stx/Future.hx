package stx;

import stx.Continuation;
import stx.Promise;

using Prelude;

using stx.Iterables;
using stx.Tuples;
using stx.Functions;
using stx.Compose;

typedef FutureType<A>           = ContinuationType<Void,A>;

abstract Future<T>(FutureType<T>) from FutureType<T> to FutureType<T>{
  public inline function new(f:(T->Void)->Void){
    this = f;
  }
  @:from static public inline function fromPromise<A>(prm:Promise<A>):Future<stx.Outcome<A>>{
    return new Future(prm);
  }
  @:from static public function fromContinuation<T>(cnt:Continuation<Void,T>){
    return new Future(cnt);
  }
  @:from static public function fromNativeCallback<T>(cb:(T->Void)->Void){
   return function(x:T->Void){
      var fn = function(y:T){
        x(y);
      };
      cb(fn);
    }
  }
  public inline function apply(fn:T->Void){
    this(fn);
  }

  @:to public inline function toContinuation():Continuation<Void,T>{
    return new Continuation(this);
  }
  @:to public function toNativeCallback():(T->Void)->Void{
    return function(f0:T->Void){
      var f1 = function(x){
        f0(x);
      }
      apply(this,f1);
    }
  }
  @:noUsing static public function pure<A>(v:A):Future<A> {
    return new Future(function (callback:Callback<A>) { return callback(v); } );
  }
  public function map<A>(f:T->A):Future<A> {
    return Futures.map(this,f);
  }
  public function each(f:T->Void):Future<T>{
    return Futures.each(this,f);
  }
  public function zipWith<B,C>(f2:Future<B>,fn : T -> B -> C):Future<C>{
    return Futures.zipWith(this,f2,fn);
  }
  public function zip<B,C>(f2:Future<B>):Future<Tuple2<T,B>>{
    return Futures.zip(this,f2);
  }
  public function flatMap<B>(next:T->Future<B>):Future<B> {
    return Futures.flatMap(this,next);
  }
  @:noUsing static public function ofArrow<A>(f:(A->Void)->Void):Future<A> {
    return new Future(f);
  }
}
class Futures{
  static public inline function apply<A>(ft:Future<A>,fn:A->Void){
    return ft.apply(fn);
  }
  static public inline function map<T,A>(ft:Future<T>,f:T->A):Future<A> {
    return Continuations.map(ft,f);
  }
  static public inline function each<T>(ft:Future<T>,f:T->Void):Future<T>{
    return Continuations.each(ft,f);
  }
  static public inline function zipWith<T,B,C>(f1:Future<T>,f2:Future<B>,fn : T -> B -> C):Future<C>{
    return Continuations.zipWith(f1,f2,fn);
  }
  static public inline function zip<T,B,C>(f1:Future<T>,f2:Future<B>):Future<Tuple2<T,B>>{
    return zipWith(f1,f2,tuple2);
  }
  static public inline function flatMap<T,B>(ft:Future<T>,next:T->Future<B>):Future<B> {
    return function(cont : B -> Void):Void{
      return apply(ft,function(a:T):Void{ next(a).apply(cont); });
    }
  }
  static public function bindFold<A,B>(arr:Array<A>,init:B,fold:B->A->Future<B>){
    return stx.Arrays.foldLeft(arr,
      Future.pure(init),
      function(memo:Future<B>,next:A){
        return memo.flatMap(
          function(b:B){
            return fold(b,next);
          }
        );
      }
    );
  }
}
