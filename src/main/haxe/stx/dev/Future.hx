package stx;

import stx.Continuation;

using stx.Prelude;
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
      return Niladic.unit();
    }
  }
  @:to public function toNativeCallback():(T->Void)->Void{
    return function(f0:T->Void){
      var f1 = function(x){
        f0(x);
        return Niladic.unit();
      }
      this.apply(f1);
    }
  }
  @:noUsing static public function pure<A>(v:A):Future<A> {
    return new Future(function (callback:Callback<A>) { return callback.invoke(v); } );
  }
  public inline function apply(f:Callback<T>):Void{
    return this.apply(f);
  }
  public inline function new(f:(T->Void)->Void){
    this = f;
  }
  public function orDefault(v:T){
    return flatMap(
      function(x:T){
        return  x == null ? pure(v) : pure(x);
      }
    );
  };
  public function map<A>(f:T->A):Future<A> {
    return this.map(f);
  }
  public function foreach(f:T->Void):Future<T>{
    return this.foreach(f);
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
class Futures{
  static public function foreach<A>(f:Future<A>,fn:A->Void):Future<A>{
    return f.foreach(fn);
  }
  static public function mapL<A,B,C>(f:Future<Either<A,B>>,fn:A->C):Future<Either<C,B>>{
    return f.map(
      function(x){
        return switch (x){
          case      Left(l)      : Left(fn(l));
          case      Right(r)     : Right(r);
        };
      }
    );
  }
  static public function mapR<A,B,C>(f:Future<Either<A,B>>,fn:B->C):Future<Either<A,C>>{
    return f.map(
      function(x){
        return switch (x){
          case      Left(l)      : Left(l);
          case      Right(r)     : Right(fn(r));
        }
      }
    );
  }
  static public function map<A,B>(f:Future<A>,fn:A->B):Future<B>{
    return f.map(fn);
  }
  static public function flatMap<A,B>(f:Future<A>,fn:A->Future<B>):Future<B>{
    return f.flatMap(fn);
  }
  static public function flatMapR<A,B>(f:Future<Outcome<A>>,fn:A->Future<Outcome<B>>):Future<Outcome<B>>{
    return flatMap(f,
      function(x){
        return switch (x){
          case Left(l)      : Future.pure(Left(l));
          case Right(r)     : fn(r);
        }
      }
    );
  }
  static public function zip<A,B>(f:Future<A>,f2:Future<B>):Future<Tuple2<A,B>>{
    return f.zip(f2);
  }
  static public function bindFold<A,B>(iter:Iterable<A>,start:B,fm:B->A->Future<B>):Future<B>{
    return iter.foldl(
      Future.pure(start),
      function(memo : Future<B>, next : A){
        return memo.flatMap(
          function(b: B){
            return fm(b,next);
          }
        );
      }
    );
  }

  /*#if (js || flash)
  static public function delayC<A>(cb:Callback<A>,s:Int):Future<A>{
    var ft = Future.unit();
    haxe.Timer.delay(
      function(){
        ft.apply(cb);
      },s
    );
    return ft;
  }
 #end*/ 
}
class Futures1{
  /**
    One parameter callback handler, where callback is called exactly once.
  */
  static public function futureOf<A>(f:(A->Void)->Void):Future<A>{
    var ft = Future.fromNativeCallback(f);
    return ft;
  }
}
class Futures2{
  /**
    Creates a Future of Tuple2<A,B> from a callback function(a:A,b:B)
  */
  static public function futureOf<A,B>(f:(A->B->Void)->Void):Future<Tuple2<A,B>>{
    return function(x:Tuple2<A,B>->Void){
      var fn = function(l:A,r:B){
        x(tuple2(l,r));
      };
      f(fn);
      return Niladic.unit();
    }
  }
}
class Futures3{
  /**
    Creates a Future of Tuple2<A,B,C> from a callback function(a:A,b:B,c:C)
  */
  static public function futureOf<A,B,C>(f:(A->B->C->Void)->Void):Future<Tuple3<A,B,C>>{
    return function(x:Tuple3<A,B,C>->Void){
      var fn = function(a:A,b:B,c:C){
        x(tuple3(a,b,c));
      };
      f(fn);
      return Niladic.unit();
    }
  }
}