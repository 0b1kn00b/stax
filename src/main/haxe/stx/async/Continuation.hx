package stx.async;

import Prelude;
import stx.Option;

import stx.async.Eventual;

using stx.Option;
using stx.Tuples;

typedef ContinuationType<R,A>   = (A -> R) -> R;

@doc("The mother of all Monads. Rumour has it that only a handful of acolytes understand the true functioning of `cc`")
abstract Continuation<R,A>(ContinuationType<R,A>) from ContinuationType<R,A> to ContinuationType<R,A>{
  @:noUsing static public function pure<R,A>(a:A):Continuation<R,A>{
    return function(x:A->R){
      return x(a);
    }
  }
  @:noUsing static public function unit<R,A>():Continuation<R,A>{
    return function(x:A->R):R{
      return null;
    } 
  }
  public function new(v){
    this = v;
  }
  public function apply(fn:A->R):R{
    return (this)(fn);
  }
  public function map<B>(k:A->B):Continuation<R,B>{
    return Continuations.map(this,k);
  }
  public function each(k:A->Void):Continuation<R,A>{
    return Continuations.each(this,k);
  }
  public function flatMap<B>(k:A -> Continuation<R,B>):Continuation<R,B>{
    return Continuations.flatMap(this,k);
  }
  public function zipWith<B,C>(cnt0:Continuation<R,B>,fn:A->B->C):Continuation<R,C>{
    return Continuations.zipWith(this,cnt0,fn);
  }
  static public function bindFold<R,A,B>(arr:Array<A>,init:B,fold:B->A->Continuation<R,B>){
    return stx.Arrays.foldLeft(arr,
      pure(init),
      function(memo:Continuation<R,B>,next:A){
        return memo.flatMap(
          function(b:B){
            return fold(b,next);
          }
        );
      }
    );
  }
  static public function callcc<R,A,B>(f:(A->Continuation<R,B>)->Continuation<R,A>):Continuation<R,A>{
    return new Continuation(
      function(k:A->R):R{
        return f(
          function(a){
            return new Continuation(
              function(x){
                return k(a);
              }
            );
          }
        ).apply(k);
      }
    );
  }
  public function asFunction():ContinuationType<R,A>{
    return this;
  }
  static public inline function toEventual<A>(cont:ContinuationType<Void,A>):Eventual<A>{
    var ft = Eventual.unit();
    cont(
      ft.deliver
    );
    return ft;
  }
}
class Continuations{
  static public function apply<R,A>(cnt:Continuation<R,A>,fn:A->R):R{
    return cnt.apply(fn);
  }
  static public function map<R,A,B>(cnt:Continuation<R,A>,k:A->B):Continuation<R,B>{
    return function(cont:B->R):R{
      return apply(cnt,
        function(v:A){
          return cont(k(v));
        }
      );
    }
  }
  static public function each<R,A>(cnt:Continuation<R,A>,k:A->Void):Continuation<R,A>{
    return map(
      cnt,
      function(x:A):A{
        k(x);
        return x;
      }
    );
  }
  static public function flatMap<R,A,B>(cnt:Continuation<R,A>,k:A -> Continuation<R,B>):Continuation<R,B>{
    return new Continuation(
      function(cont : B -> R):R{
        return apply(cnt, function(a:A):R{ return k(a).apply(cont); });
      }
    );
  }
  static public function zipWith<R,A,B,C>(cnt:Continuation<R,A>,cnt0:Continuation<R,B>,fn:A->B->C):Continuation<R,C>{
    return new Continuation(
      function(cont:C->R){
        return cnt.apply(function(a){
          return cnt0.apply(function(b){
            return cont(fn(a,b));
          });
        });
      }
    );
  }
}