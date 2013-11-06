package stx;

import stx.Continuation;

using Prelude;

using stx.Iterables;
using stx.Tuples;
using stx.Functions;
using stx.Compose;

@:stability('0')
abstract Future<T>(Continuation<Void,T>) from Continuation<Void,T>{

  @:from static public function fromNativeCallback<T>(cb:(T->Void)->Void){
   return function(x:T->Void){
      var fn = function(y:T){
        x(y);
      };
      cb(fn);
    }
  }
  @:to public function toNativeCallback():(T->Void)->Void{
    return function(f0:T->Void){
      var f1 = function(x){
        f0(x);
      }
      this.apply(f1);
    }
  }
  @:noUsing static public function pure<A>(v:A):Future<A> {
    return new Future(function (callback:Callback<A>) { return callback(v); } );
  }
  public inline function apply(f:Callback<T>):Void{
    return this.apply(f);
  }
  public inline function new(f:(T->Void)->Void){
    this = f;
  }
  public function map<A>(f:T->A):Future<A> {
    return this.map(f);
  }
  public function each(f:T->Void):Future<T>{
    return this.each(f);
  }
  public function zipWith<B,C>(f2:Future<B>,fn : T -> B -> C):Future<C>{
    return flatMap(
        function(a:T){
          return f2.flatMap(
            function(b:B){
              return pure(fn(a,b));
            }
          );
        }
      );
  }
  public function zip<B,C>(f2:Future<B>):Future<Tuple2<T,B>>{
    return zipWith(f2,tuple2);
  }
  public function flatMap<B>(next:T->Future<B>):Future<B> {
    return function(cont : B -> Void):Void{
      return this.apply(function(a:T):Void{ next(a).apply(cont); });
    }
  }
  @:noUsing static public function ofArrow<A>(f:(A->Void)->Void):Future<A> {
    return new Future(f);
  }
  public function native():Continuation<Void,T>{
    return this;
  }
}