package stx;

import stx.Errors;
import stx.Error.*;
import stx.Tuples;

using stx.Prelude;
using stx.Tuples;
using stx.Eventual;
using stx.Promise;
using stx.Options;
using stx.Eithers;
using stx.Arrays;
using stx.Functions;
using stx.Compose;

abstract Promise<A>(Eventual<Outcome<A>>) from Eventual<Outcome<A>> to Eventual<Outcome<A>>{
  @:noUsing
  static public function pure<A>(e:Outcome<A>):Promise<A>{
    return new Promise().deliver(e);
  }
  @:noUsing
  static public function unit<A>():Promise<A>{
    return new Promise();
  }
  public function deliver<A>(v:Outcome<A>):Promise<A>{
    return this.deliver(v);
  }
  public function ok(val:A):Promise<A>{
    return this.deliver(Right(val));
  }
  public function no(err:Error):Promise<A>{
    return this.deliver(Left(err));
  }
  public function new(?p){
    this = Options.orDefault(p,Eventual.unit());
  }
  public function recover<B>(fn:Error->Outcome<A>):Promise<A>{
    return this.map(
      function(e:Outcome<A>):Outcome<A>{
        return switch (e){
          case    Right(r)     : Right(r);
          case    Left(l)      : fn(l);
        }
      }
    );
  }
  public function verify<B>(fn:A->Outcome<B>):Promise<B>{
    return this.map(
      function(e){
        return switch (e){
          case    Left(l)      : Left(l);
          case    Right(r)     : fn(r);
        }
      }
    );
  }
  public function success(fn:A->Void):Promise<A>{
    return this.foreach(fn.right().effectOf());
  }
  public function failure(fn:Error->Void):Promise<A>{
    return this.foreach(fn.left().effectOf());
  }
  public function value(){
    return this.value;
  }
  public function valueO(){
    return this.valueO();
  }
  /**
    Calls callback, placing a left value in the first parameter or a right in the second.
  */
  public function callback(fn:Error->A->Void):Promise<A>{
    return this.foreach(
      function(x){
        switch (x){
          case      Left(l)      : fn(l,null);
          case      Right(r)     : fn(null,r);
        }
      }
    );
  }
  /**
   Does a map if the Either is Right.
  */
  public function map<A,B>(fn:A->B):Promise<B>{
    return this.map(
      function(x){
        return 
          x.mapR(
            function(y:A){
              return fn(y);
            }
          );
      }
    );
  }
  public function mapLeft<C>(fn:Error->C):Eventual<Either<C,A>>{
    return this.mapLeft(fn);
  }
  /**
    Zips the right hand value with function `fn`
  */
  public function zipWith<A,B,C>(f1:Promise<B>,fn : A -> B -> C):Promise<C>{
    return this.zipWith(f1,
        function(a,b){
          return 
            switch (a) {
              case Left(v1)       : Left(v1);
              case Right(v1)      :
                switch (b) {
                  case Left(v2)   : Left(v2);
                  case Right(v2)  : Right(fn(v1,v2));
                }
              }
          }
      );
  }
  /**
    Zips the right hand value.
  */
  public function zip<A,B>(f1:Promise<B>):Promise<Tuple2<A,B>>{
    return zipWith(f1,tuple2);
  }
  /**
    flatMaps the right hand value
  */
  public function flatMap<B>(fn : A -> Promise<B>):Promise<B>{
    return
      this.flatMap(
        function(x){
          return
            switch (x) {
              case Left(v1)   : new Promise().deliver(Left(v1));
              case Right(v2)  : fn(v2);
            }
        }
      );
  }
  /**
    Applies a function if the result is right
  */
  public function foreach(f:Outcome<A>->Void):Promise<A>{
    return this.foreach(f);
  }
  public function asEventual():Eventual<Outcome<A>>{
    return this;
  }
  public function isDelivered(){
    return this.isDelivered();
  }
}
class Promises{
  static public function intact<A>(v:A):Promise<A>{
    return Promise.pure(Right(v)); 
  }
  static public function breach<A>(v:Error):Promise<A>{
    return Promise.pure(Left(v));
  }
    /**
    Use this with a flatmap fold to wait for parallel futures.
    vals.map( function_returning_future ).foldl( Eventual.pure(Right([])), Promises.waitfold )
    This op stops when there is a single failure
  */
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
  /**
    Returns a single future with an Array of the results, or an Error.
  */
  static public function wait<A>(a:Array<Promise<A>>):Promise<Array<A>>{
    return a.foldl(
        [].intact()
      , waitfold
    );
  }
  static public function bindFold<A,B>(iter:Iterable<A>,start:B,fm:B->A->Promise<B>):Promise<B>{
    return stx.Eventuals.bindFold(
      iter,
      Right(start),
      function(memo:Outcome<B>,next:A){
        //trace('$memo $next');
        return 
            switch (memo) {
              case Left(e)    : e.breach();
              case Right(v1)  : fm(v1,next);
            }
      }
    );
  }
  static public function unzip<A,B,C>(tp:Tuple2<Promise<A>,Promise<B>>):Promise<Tuple2<A,B>>{
    return 
      tp.fst().flatMap(
        function(b:A){
          return tp.snd().map( tuple2.p1(b) );
        }
      );
  }
  public static function chain<A>(a:Array<Thunk<Promise<A>>>):Promise<Array<A>>{
    return 
      a.foldl(
        [].intact()
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
class Promises1{
  /**
    Returns a Promise where the only result of a function may be an Error, returning the result of ´success´
    where no Error is found.
  */
  static public function promiseOf<A>(f:(String->Void)->Void,success:Void->A):Promise<A>{
    var fut = Eventual.unit();
    f(
      function(er){
        if(er!=null){
          fut.deliver(Left(err(NativeError(er))));
        }else{
          fut.deliver(Right(success()));
        }
      }
    );
    return fut;
  }
  /**
    As with ´promiseOf´ but using a constant rather than a Thunk.
  */
  static public function promiseOfC<A>(f:(String->Void)->Void,success:A):Promise<A>{
    return promiseOf(f,Anys.toThunk(success));
  }
}
class Promises2{
  /**
    Creates a Promise from a callback of function (err,res).
  */  
  static public function promiseOf<A>(f:(Dynamic->A->Void)->Void):Promise<A>{
    var ft = new Promise();
    f( 
      function(a,b){
        if(a!=null){
          ft.deliver(Left(err(NativeError(a))));
        }else{
          ft.deliver(Right(b));
        }
      }
     );
    return ft;
  }
}
class Promises3{
  static public function promiseOf<A,B>(f:(String->A->B->Void)->Void):Promise<Tuple2<A,B>>{
    var ft = new Promise();
    f(
      function(a,b,c){
        if(a!=null){
          ft.deliver(Left(err(NativeError(a))));
        }else{
          ft.deliver(Right(tuple2(b,c)));
        }
      }
    );
    return ft;
  }
}
class Promises4{
  static public function promiseOf<A,B,C>(f:(String->A->B->C->Void)->Void):Promise<Tuple3<A,B,C>>{
    var ft = new Eventual();
    f(
      function(e,a,b,c){
        if(e!=null){
          ft.deliver(Left(err(NativeError(e))));
        }else{
          ft.deliver(Right(tuple3(a,b,c)));
        }
      }
    );
    return ft;
  }
}