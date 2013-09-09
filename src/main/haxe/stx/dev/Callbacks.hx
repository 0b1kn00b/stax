package stx;

import stx.Tuples;
using stx.Compose;
using stx.Functions;
using stx.Prelude;
using stx.Arrays;
using stx.Callbacks;
using stx.Tuples;
using stx.Eithers;
using stx.Continuation;

class Callbacks{
  static public function receiveOf<R,A>(v:(A -> R) -> R):RC<R,A>{
    return v;
  }
  @:noUsing
  static public function pure<A>(e:A):Callback<A>{
    return cast Continuation.pure(e);
  }
  @:noUsing
  static public function create<A>():Callback<A>{
    return function(a:A->Void){ };
  }
	static public function foreach<A>(f:Callback<A>,fn:A->Void):Callback<A>{
    return f.foreach(fn);
  }
  static public function map<A,B>(f:Callback<A>,fn:A->B):Callback<B>{
    return f.map(fn);
  }
  static public function flatMap<A,B>(f:Callback<A>,fn:A->Callback<B>):Callback<B>{
    return f.flatMap(fn);
  }
  static public function bindFold<A,B>(iter:Iterable<A>,start:Callback<B>,fm:B->A->Callback<B>):Callback<B>{
    return 
      iter.foldl(
        start ,
        function(memo : Callback<B>, next : A){
          return 
            memo.flatMap(
              function(b: B){
                return fm(b,next);
              }
            );
        }
      );
  }	
  static public function zipWith<A,B,C>(f1:Callback<A>,f2:Callback<B>,fn : A -> B -> C):Callback<C>{
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
  static public function zip<A,B,C>(f1:Callback<A>,f2:Callback<B>):Callback<Tuple2<A,B>>{
    return zipWith(f1,f2,tuple2);
  }
}