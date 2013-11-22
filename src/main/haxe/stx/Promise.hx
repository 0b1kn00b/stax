package stx;

import Prelude;
import Stax.*;

using stx.Outcome;
import stx.Compare.*;
import stx.Continuation;
import stx.Future;

using stx.Iterables;
using stx.Functions;
using stx.Arrays;
using stx.Tuples;

typedef PromiseType<A>            = FutureType<Outcome<A>>;

abstract Promise<A>(PromiseType<A>) from PromiseType<A> to PromiseType<A>{
  @:noUsing static public function pure<A>(e:Outcome<A>):Promise<A>{
    return Future.pure(e);
  }
  @:from static public inline function fromFuture(cnt:Future<Outcome<A>>):Promise<A>{
    return new Promise(cnt);
  }
  @:from static public inline function fromContinuation<A>(cnt:ContinuationType<Void,Outcome<A>>):Promise<A>{
    return new Promise(cnt);
  }
  public function new(p:PromiseType<A>){
    this = p;
  }
  public function apply(fn:Outcome<A>->Void){
    Futures.apply(this,fn);
  }
  public function reply():Contract<A>{
    var a = Contract.unit();
    this(a.deliver);
    return a;
  }
  public function retry<B>(fn:Fail->Outcome<A>):Promise<A>{
    return Promises.retry(this,fn);
  }
  public function verify<B>(fn:A->Outcome<B>):Promise<B>{
    return Promises.verify(this,fn);
  }
  public function onSuccess(fn:A->Void):Promise<A>{
    return Promises.each(this,Outcomes.onSuccess.bind(_,fn));
  }
  public function onFailure(fn:Fail->Void):Promise<A>{
    return Promises.each(this,Outcomes.onFailure.bind(_,fn));
  }
  public function onComplete(fn:Void->Void):Promise<A>{
    return Promises.each(this,fn.promote());
  }
  @doc("Does a map if the Outcome is Success.")
  public function map<B>(fn:A->B):Promise<B>{
    return Promises.map(this,fn);
  }
  public function transform<B>(fn:Outcome<A>->Outcome<B>):Promise<B>{
    return Promises.transform(this,fn);
  }
  @doc("Zips the right hand value with function `fn`")
  public function zipWith<A,B,C>(prm1:Promise<B>,fn : A -> B -> C):Promise<C>{
    return Promises.zipWith(this,prm1,fn);
  }
  @doc("Zips the right hand value.")
  public function zip<A,B>(f1:Promise<B>):Promise<Tuple2<A,B>>{
    return zipWith(f1,tuple2);
  }
  @doc("flatMaps the right hand value")
  public function flatMap<B>(fn : A -> Promise<B>):Promise<B>{
    return Promises.flatMap(this,fn);
  }
  public function each(f:Outcome<A>->Void):Promise<A>{
    return Promises.each(this,f);
  }
  static public function intact<A>(v:A){
    return pure(Success(v));
  }
  static public function breach(f:Fail){
    return pure(Failure(f));
  }
}

class Promises{
  static public function each<A>(prm:Promise<A>,f:Outcome<A>->Void):Promise<A>{
    return Futures.each(prm,f);
  }
  @doc("Does a map if the Outcome is Success.")
  static public function map<A,B>(prm:Promise<A>,fn:A->B):Promise<B>{
    return Futures.map(prm,
      function(x:Outcome<A>){
        return x.map(
            function(y:A){
              return fn(y);
            }
          );
      }
    );
  }
  static public function transform<A,B>(prm:Promise<A>,fn:Outcome<A>->Outcome<B>):Promise<B>{
    return Futures.map(prm,fn);
  }
  @doc("Zips the right hand value with function `fn`")
  static public function zipWith<A,B,C>(prm:Promise<A>,f1:Promise<B>,fn : A -> B -> C):Promise<C>{
    return Futures.zipWith(prm,f1,
        function(a,b):Outcome<C>{
          return switch (a) {
              case Failure(v1)       : Failure(v1);
              case Success(v1)       :
                switch (b) {
                  case Failure(v2)   : Failure(v2);
                  case Success(v2)   : Success(fn(v1,v2));
                }
              }
          }
      );
  }
  @doc("Zips the right hand value.")
  static public function zip<A,B>(prm0:Promise<A>,prm1:Promise<B>):Promise<Tuple2<A,B>>{
    return zipWith(prm0,prm1,tuple2);
  }
  @doc("flatMaps the right hand value")
  static public function flatMap<A,B>(prm:Promise<A>,fn : A -> Promise<B>):Promise<B>{
    return Futures.flatMap(prm,
        function(x){
          return switch (x) {
              case Failure(v1)  : Promise.pure(Failure(v1));
              case Success(v2)  : fn(v2);
            }
        }
      );
  }
  static public function retry<A,B>(prm:Promise<A>,fn:Fail->Outcome<A>):Promise<A>{
    return Futures.map(prm,
      function(o){
        return switch (o) {
          case Failure(e) : fn(e);
          default         : o;
        }
      }
    );
  }
  static public function verify<A,B>(prm:Promise<A>,fn:A->Outcome<B>):Promise<B>{
    return Futures.map(prm,Outcomes.fold.bind(_,fn,Failure));
  }
  @doc("
    Use this with a flatmap fold to wait for parallel futures.
    vals.map( function_returning_future ).foldLeft( Eventual.pure(Failure([])), Promises.waitfold )
    This op stops when there is a single failure
  ")
  static public function waitfold<A>(init:Promise<Array<A>>,ft:Promise<A>):Promise<Array<A>>{
    return init.flatMap(
        function(arr:Array<A>){
          return ft.map(arr.add);
        }
      );
  }
  @doc("Returns a single future with an Array of the results, or a Fail.")
  static public function wait<A>(a:Array<Promise<A>>):Promise<Array<A>>{
    return a.foldLeft(
        Promise.intact([])
      , waitfold
    );
  }
  static public function bindFold<A,B>(iter:Iterable<A>,start:B,fm:B->A->Promise<B>):Promise<B>{
    return iter.foldLeft(
      Promise.pure(Success(start)),
      function(memo : Promise<B>, next : A){
        return memo.flatMap(
          function(x){
            return fm(x,next);
          }
        );
      }
    );
  }
  static public function unzip<A,B,C>(tp:Tuple2<Promise<A>,Promise<B>>):Promise<Tuple2<A,B>>{
    return tp.fst().flatMap(
      function(b:A){
        return tp.snd().map( tuple2.bind(b) );
      }
    );
  }
  public static function chain<A>(a:Array<Thunk<Promise<A>>>):Promise<Array<A>>{
    return a.foldLeft(
        Promise.intact([])
      , function(init,fn){
          return 
            init.flatMap(function(x) return fn().map(function(y) return x.add(y)));
        }
    );
  }
  static public function asPromise<T>(evt:Eventual<Outcome<T>>):Promise<T>{
    return new Promise(evt.each);
  }
}