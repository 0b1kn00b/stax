package stx;


using stx.Prelude;

import stx.Tuples;
import stx.Future;

using stx.Promises;
using stx.Eithers;
using stx.Arrays;
using stx.Functions;
using stx.Compose;

typedef Promise<A> = Future<Outcome<A>>;
class Promises{
  static public function onSuccess<A,B>(ft:Future<Either<A,B>>,fn:B->Void){
    return ft.foreachR(fn);
  }
  static public function onFailure<A,B>(ft:Future<Either<A,B>>,fn:A->Void){
    return ft.foreachL(fn);
  }
  /**
   Does a map if the Either is Left.
  */
  static public function mapL<A,B,C>(f:Future<Either<A,B>>,fn:A->C):Future<Either<C,B>>{
    return 
      f.map(
        function(x:Either<A,B>):Either<C,B>{
          return 
            x.mapL(
              function(y:A){
                return fn(y);
              }
            );
        }
      );
  }
  /**
   Does a map if the Either is Right.
  */
  static public function mapR<A,B,C>(f:Future<Either<A,B>>,fn:B->C):Future<Either<A,C>>{
    return 
      f.map(
        function(x:Either<A,B>):Either<A,C>{
          return 
            x.mapR(
              function(y:B){
                return fn(y);
              }
            );
        }
      );
  }
  /**
    Zips the right hand value with function `fn`
  */
  static public function zipRWith<A,B,C,D>(f0:Future<Either<A,B>>,f1:Future<Either<A,C>>,fn : B -> C -> D):Future<Either<A,D>>{
    return 
      f0.zipWith(f1,
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
  static public function zipR<A,B,C>(f0:Future<Either<A,B>>,f1:Future<Either<A,C>>):Future<Either<A,Tuple2<B,C>>>{
    return zipRWith(f0,f1,Tuples.t2);
  }
  /**
    flatMaps the right hand value
  */
  static public function flatMapR<A,B,C>(f0:Future<Either<A,B>>,fn : B -> Future<Either<A,C>>):Future<Either<A,C>>{
    return
      f0.flatMap(
        function(x){
          return
            switch (x) {
              case Left(v1)   : new Future().deliver(Left(v1));
              case Right(v2)  : fn(v2);
            }
        }
      );
  }
  /**
    Flatmaps the left hand value.
  */
  static public function flatMapL<A,B,C>(f0:Future<Either<A,B>>,fn : A -> Future<Either<C,B>>):Future<Either<C,B>>{
    return
      f0.flatMap(
        function(x){
          return
            switch (x) {
              case Right(v1)   : new Future().deliver(Right(v1));
              case Left(v2)    : fn(v2);
            }
        }
      );
  }
  @:noUsing
  static public function pure<A,B>(e:Either<A,B>):Future<Either<A,B>>{
    return new Future().deliver(e);
  }
  /**
    Resolves as a right hand value.
  */
  static public function right<A,B>(f:Future<Either<A,B>>,v:B){
    return f.deliver(Right(v));
  }
  /**
    Resolves as a left hand value.
  */
  static public function left<A,B>(f:Future<Either<A,B>>,v:A){
    return f.deliver(Left(v));
  }
  /**
    Creates a pure Future and delivers to the right hand side.
  */
  static public function success<A,B>(v:B):Future<Either<A,B>>{
    return pure(Right(v));
  }
  static public function intact<A,B>(v:B):Future<Either<A,B>>{
    return pure(Right(v)); 
  }
  /**
    Creates a pure future and delivers to the left hand side.
  */
  static public function failure<A,B>(v:A):Future<Either<A,B>>{
    return pure(Left(v));
  }
  static public function breach<A,B>(v:A):Future<Either<A,B>>{
    return pure(Left(v));
  }
  /**
    Use this with a flatmap fold to wait for parallel futures.
    vals.map( function_returning_future ).foldl( Future.pure(Right([])), Promises.waitfold )
    This op stops when there is a single failure
  */
  static public function waitfold<A,B>(init:Future<Either<A,Array<B>>>,ft:Future<Either<A,B>>):Future<Either<A,Array<B>>>{
    return 
      init.flatMapR(
        function(arr:Array<B>){
          return 
            ft.mapR(
              function(v:B):Array<B>{
                return arr.add(v);
              }
            );
        }
      );
  }
  /**
    Returns a single future with an Array of the results, or an Error.
  */
  static public function wait<A,B>(a:Array<Future<Either<A,B>>>):Future<Either<A,Array<B>>>{
    return 
      a.foldl(
          Future.pure(Right([]))
        , waitfold
      );
  }
  /**
    Applies a function if the result is right
  */
  static public function foreachR<A,B>(v:Future<Either<A,B>>,f:B->Void){
    return 
      v.foreach(
        Eithers.right.then( Options.foreach.p2( f ) ).effectOf()
      );
  }
  /**
    Applies a function if the result is left.
  */
  static public function foreachL<A,B>(v:Future<Either<A,B>>,f:A->Void){
    return 
      v.foreach(
        Eithers.left.then( Options.foreach.p2( f ) ).effectOf()
      );
  }
  /**
    Calls callback, placing a left value in the first parameter or a right in the second.
  */
  static public function toCallback<A,B>(v:Future<Either<A,B>>,fn:A->B->Void){
    v.foreachL( fn.p2(null) );
    v.foreachR( fn.p1(null) );
    return v;
  }
  static public function unzip<A,B,C>(tp:Tuple2<Future<Either<A,B>>,Future<Either<A,C>>>):Future<Either<A,Tuple2<B,C>>>{
    return 
      tp._1.flatMapR(
        function(b:B){
          return tp._2.mapR( Tuples.t2.p1(b) );
        }
      );
  }
  static public function bindFoldR<A,B,Err>(iter:Iterable<A>,start:Future<Either<Err,B>>,fm:B->A->Future<Either<Err,B>>):Future<Either<Err,B>>{
    return 
      stx.Futures.bindFold(
        iter,
        start,
        function(memo:Either<Err,B>,next:A){
          return 
              switch (memo) {
                case Left(e)    : Promises.failure(e);
                case Right(v1)  : fm(v1,next);
              }
        }
      );
  }
}
class PromiseActions {
  public static function chain(a:Array<Void->Future<Either<Error,Dynamic>>>):Future<Outcome<Array<Dynamic>>>{
    return 
      a.foldl(
        Promises.success([])
      , function(init,fn){
          return 
            init.flatMapR(function(x) return Promises.mapR(fn(),function(y) return x.add(y)));
        }
    );
  }
}