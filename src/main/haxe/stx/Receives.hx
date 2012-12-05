package stx;

using stx.Compose;
using stx.Functions;
using stx.Prelude;
using stx.Arrays;
using stx.Receives;
using stx.Tuples;
using stx.Eithers;
using stx.Continuations;

class Receives{
  static public function receiveOf<R,A>(v:(A -> R) -> R):RC<R,A>{
    return v;
  }
  @:noUsing
  static public function pure<A>(e:A):Receive<A>{
    return cast Continuations.pure(e);
  }
  @:noUsing
  static public function create<A>():Receive<A>{
    return function(a:A->Void){ };
  }
	static public function foreach<A>(f:Receive<A>,fn:A->Void):Receive<A>{
    return f.foreach(fn);
  }
  static public function map<A,B>(f:Receive<A>,fn:A->B):Receive<B>{
    return f.map(fn);
  }
  static public function flatMap<A,B>(f:Receive<A>,fn:A->Receive<B>):Receive<B>{
    return f.flatMap(fn);
  }
  static public function bindFold<A,B>(iter:Iterable<A>,start:Receive<B>,fm:B->A->Receive<B>):Receive<B>{
    return 
      iter.foldl(
        start ,
        function(memo : Receive<B>, next : A){
          return 
            memo.flatMap(
              function(b: B){
                return fm(b,next);
              }
            );
        }
      );
  }	
  static public function zipWith<A,B,C>(f1:Receive<A>,f2:Receive<B>,fn : A -> B -> C):Receive<C>{
    return 
      f1.flatMap(
        function(a){
          return 
          f2.flatMap(
            function(b){
              return pure(fn(a,b));
            }
          );
        }
      );
  }
  static public function zip<A,B,C>(f1:Receive<A>,f2:Receive<B>):Receive<Tuple2<A,B>>{
    return zipWith(f1,f2,Tuples.t2);
  }
}
class ReceivesE{
  @:noUsing
  static public function create<A,B>():ReceiveE<A,B>{
    return function(a:Either<A,B>->Void){ }; 
  }
  static public function receiveOf<R,A,B>(fn:(A -> B -> Void) -> Void):RC<Void,Either<A,B>>{
    return 
      function(fn0:Either<A,B>->Void):Void{
        fn(
          function(a,b){
            if(a!=null){
              fn0(Left(a));
            }else{
              fn0(Right(b));
            }
          }
        );
      }
  }
	static public function onSuccess<A,B>(ft:Receive<Either<A,B>>,fn:B->Void){
    return ft.foreachR(fn);
  }
  static public function onFailure<A,B>(ft:Receive<Either<A,B>>,fn:A->Void){
    return ft.foreachL(fn);
  }
  /**
   Does a map if the Either is Left.
  */
  static public function mapL<A,B,C>(f:Receive<Either<A,B>>,fn:A->C):Receive<Either<C,B>>{
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
  static public function mapR<A,B,C>(f:Receive<Either<A,B>>,fn:B->C):Receive<Either<A,C>>{
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
  static public function zipRWith<A,B,C,D>(f0:Receive<Either<A,B>>,f1:Receive<Either<A,C>>,fn : B -> C -> D):Receive<Either<A,D>>{
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
  static public function zipR<A,B,C>(f0:Receive<Either<A,B>>,f1:Receive<Either<A,C>>):Receive<Either<A,Tuple2<B,C>>>{
    return zipRWith(f0,f1,Tuples.t2);
  }
  /**
    flatMaps the right hand value
  */
  static public function flatMapR<A,B,C>(f0:Receive<Either<A,B>>,fn : B -> Receive<Either<A,C>>):Receive<Either<A,C>>{
    return
      f0.flatMap(
        function(x){
          return
            switch (x) {
              case Left(v1)   : Receives.pure(Left(v1));
              case Right(v2)  : fn(v2);
            }
        }
      );
  }
  /**
    Flatmaps the left hand value.
  */
  static public function flatMapL<A,B,C>(f0:Receive<Either<A,B>>,fn : A -> Receive<Either<C,B>>):Receive<Either<C,B>>{
    return
      f0.flatMap(
        function(x){
          return
            switch (x) {
              case Right(v1)   : Receives.pure(Right(v1));
              case Left(v2)    : fn(v2);
            }
        }
      );
  }
  @:noUsing
  static public function pure<A,B>(e:Either<A,B>):Receive<Either<A,B>>{
    return cast Continuations.pure(e);
  }
  /**
    Resolves as a right hand value.
  */
  static public function right<A,B>(f:Receive<Either<A,B>>,v:B->Void):Void{
    f.map( Eithers.right ).foreach( Options.foreach.p2(v).effectOf() );
  }
  /**
    Resolves as a left hand value.
  */
  static public function left<A,B>(f:Receive<Either<A,B>>,v:A->Void):Void{
    f.map( Eithers.left ).foreach( Options.foreach.p2(v).effectOf() );
  }
  /**
    Creates a pure Receive and delivers to the right hand side.
  */
  static public function success<A,B>(v:B):Receive<Either<A,B>>{
    return pure(Right(v));
  }
  /**
    Creates a pure future and delivers to the left hand side.
  */
  static public function failure<A,B>(v:A):Receive<Either<A,B>>{
    return pure(Left(v));
  }
  /**
    Use this with a flatmap fold to wait for parallel futures.
    vals.map( function_returning_future ).foldl( Receive.pure(Right([])), Promises.waitfold )
    This op stops when there is a single failure
  */
  static public function waitfold<A,B>(init:Receive<Either<A,Array<B>>>,ft:Receive<Either<A,B>>):Receive<Either<A,Array<B>>>{
    return 
      init.flatMapR(
        function(arr:Array<B>){
          return 
            ft.mapR(
              function(v:B):Array<B>{
                return arr.append(v);
              }
            );
        }
      );
  }
  /**
    Returns a single future with an Array of the results, or an Error.
  */
  static public function wait<A,B>(a:Array<Receive<Either<A,B>>>):Receive<Either<A,Array<B>>>{
    return 
      a.foldl(
          ReceivesE.pure(Right([]))
        , waitfold
      );
  }
  /**
    Applies a function if the result is right
  */
  static public function foreachR<A,B>(v:Receive<Either<A,B>>,f:B->Void){
    return 
      v.foreach(
        Eithers.right.then( Options.foreach.p2( f ) ).effectOf()
      );
  }
  /**
    Applies a function if the result is left.
  */
  static public function foreachL<A,B>(v:Receive<Either<A,B>>,f:A->Void){
    return 
      v.foreach(
        Eithers.left.then( Options.foreach.p2( f ) ).effectOf()
      );
  }
  static public function unzip<A,B,C>(tp:Tuple2<Receive<Either<A,B>>,Receive<Either<A,C>>>):Receive<Either<A,Tuple2<B,C>>>{
    return 
      tp._1.flatMapR(
        function(b:B){
          return tp._2.mapR( Tuples.t2.p1(b) );
        }
      );
  }
  static public function bindFoldR<A,B,Err>(iter:Iterable<A>,start:Receive<Either<Err,B>>,fm:B->A->Receive<Either<Err,B>>):Receive<Either<Err,B>>{
    return 
      Receives.bindFold(
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
class ReceivesEActions {
  public static function chain(a:Array<Void->Receive<Either<Error,Dynamic>>>):Receive<Outcome<Array<Dynamic>>>{
    return 
      a.foldl(
        Promises.success([])
      , function(init,fn){
          return 
            init.flatMapR(function(x) return Promises.mapR(fn(),function(y) return x.append(y)));
        }
    );
  }
}