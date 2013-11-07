package stx;

import Prelude;
import Stax.*;

import stx.fnc.Future;

import stx.Compare.*;
import stx.fnc.mnd.Continuation;

using stx.fnc.Monad;
using stx.Arrays;
using stx.Tuples;

typedef PromiseType<A>            = Future<Outcome<A>>;

abstract Promise<A>(PromiseType<A>) from PromiseType<A> to PromiseType<A>{
  @:noUsing static public function pure<A>(e:Outcome<A>):Promise<A>{
    return Futures.pure(e);
  }
  public function new(p){
    this = p;
  }
  public function retry<B>(fn:Fail->Outcome<A>):Promise<A>{
    return this.map(
      function(e){
        return switch (e){
          case   Success(r)     : Success(r);
          case   Failure(l)     : fn(l);
        }
      }
    );
  }
  public function verify<B>(fn:A->Outcome<B>):Promise<B>{
    return this.map(
      function(e:Outcome<A>):Outcome<B>{
        return switch (e){
          case    Failure(l)     : Failure(l);
          case    Success(r)     : fn(r);
        }
      }
    );
  }
  public function success(fn:A->Void):Promise<A>{
    return this.each(
      function(x){
        switch (x) {
          case Success(success) : fn(success);
          default               : 
        }
      }
    );
  }
  public function failure(fn:Fail->Void):Promise<A>{
    return this.each(
      function(x){
        switch (x) {
          case Failure(failure) : fn(failure);
          default               : 
        }
      }
    );
  }
  public function complete(fn:Void->Void):Promise<A>{
    return this.each(
      function(x){
        fn();
      }
    );
  }
  @doc("
    Calls callback, placing a left value in the first parameter or a right in the second.
  ")
  public function callback(fn:Fail->A->Void):Promise<A>{
    return this.each(
      function(x){
        switch (x){
          case      Failure(l)     : fn(l,null);
          case      Success(r)     : fn(null,r);
        }
      }
    );
  }
  @doc("Does a map if the Either is Failure.")
  public function map<B>(fn:A->B):Promise<B>{
    return this.map(
      function(x){
        return x.map(
            function(y:A){
              return fn(y);
            }
          );
      }
    );
  }
  public function transform<B>(fn:Outcome<A>->Outcome<B>):Promise<B>{
    return this.map(fn);
  }
  @doc("
    Zips the right hand value with function `fn`
  ")
  public function zipWith<B,C>(f1:Promise<B>,fn : A -> B -> C):Promise<C>{
    return this.zipWith(f1,
        function(a,b):Outcome<C>{
          return 
            switch (a) {
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
  public function zip<A,B>(f1:Promise<B>):Promise<Tuple2<A,B>>{
    return zipWith(f1,tuple2);
  }
  @doc("flatMaps the right hand value")
  public function flatMap<B>(fn : A -> Promise<B>):Promise<B>{
    return this.flatMap(
        function(x){
          return switch (x) {
              case Failure(v1)  : new Promise().deliver(Failure(v1));
              case Success(v2)  : fn(v2);
            }
        }
      );
  }
  public function each(f:Outcome<A>->Void):Promise<A>{
    return this.each(f);
  }
}
class Promises{
  static public function toPromise<A>(e:Eventual<Outcome<A>>):Promise<A>{
    var o : Promise<A> = e.map(
      function(o:Outcome<A>):Outcome<A>{
        var o2 : Outcome<A> = o;
        return o2;
      }
    );
    return o;
  }
  static public function intact<A>(v:A):Promise<A>{
    return Promise.pure(Success(v)); 
  }
  static public function breach<A>(v:Fail):Promise<A>{
    return Promise.pure(Failure(v));
  }
  @doc("
    Use this with a flatmap fold to wait for parallel futures.
    vals.map( function_returning_future ).foldLeft( Eventual.pure(Failure([])), Promises.waitfold )
    This op stops when there is a single failure
  ")
  static public function waitfold<A>(init:Promise<Array<A>>,ft:Promise<A>):Promise<Array<A>>{
    return 
      init.flatMap(
        function(arr:Array<A>){
          return 
            ft.map(
              function(v:A):Array<A>{
                return arr.add(v);
              }
            );
        }
      );
  }
  @doc("
    Returns a single future with an Array of the results, or an Fail.
  ")
  static public function wait<A>(a:Array<Promise<A>>):Promise<Array<A>>{
    return a.foldLeft(
        intact([])
      , waitfold
    );
  }
  static public function bindFold<A,B>(iter:Iterable<A>,start:B,fm:B->A->Promise<B>):Promise<B>{
    return iter.foldLeft(
      Promise.pure(Success(start)),
      function(memo : Promise<B>, next : A){
        return memo.flatMap(
            function(b: B){
              return fm(b,next);
            }
          );
      }
    );
  }
  static public function unzip<A,B,C>(tp:Tuple2<Promise<A>,Promise<B>>):Promise<Tuple2<A,B>>{
    return 
      tp.fst().flatMap(
        function(b:A){
          return tp.snd().map( tuple2.bind(b) );
        }
      );
  }
  public static function chain<A>(a:Array<Thunk<Promise<A>>>):Promise<Array<A>>{
    return 
      a.foldLeft(
        intact([])
      , function(init,fn){
          return 
            init.flatMap(function(x) return fn().map(function(y) return x.add(y)));
        }
    );
  }
  static public function asPromise<T>(evt:Eventual<Outcome<T>>):Promise<T>{
    return evt;
  }
}
class Promises2{
  @doc("
    Creates a Promise from a callback of function (err,res).
  ")
  static public function toPromise<A>(f:(Dynamic->A->Void)->Void):Promise<A>{
    var ft = new Promise();
    f( 
      function(a,b){
        if(a!=null){
          ft.deliver(Failure(fail(NativeError(a))));
        }else{
          ft.deliver(Success(b));
        }
      }
     );
    return ft;
  }
}
class Promises3{
  static public function toPromise<A,B>(f:(String->A->B->Void)->Void):Promise<Tuple2<A,B>>{
    var ft = new Promise();
    f(
      function(a,b,c){
        if(a!=null){
          ft.deliver(Failure(fail(NativeError(a))));
        }else{
          ft.deliver(Success(tuple2(b,c)));
        }
      }
    );
    return ft;
  }
}
class Promises4{
  static public function toPromise<A,B,C>(f:(String->A->B->C->Void)->Void):Promise<Tuple3<A,B,C>>{
    var ft = Promise.unit();
    f(
      function(e,a,b,c){
        if(e!=null){
          ft.deliver(Failure(fail(NativeError(e))));
        }else{
          ft.deliver(Success(tuple3(a,b,c)));
        }
      }
    );
    return ft;
  }
}