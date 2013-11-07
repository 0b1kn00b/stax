package stx;

import stx.Option;
import stx.Eventual;
import Prelude;

using stx.Option;
using stx.Tuples;

typedef ContinuationType<R,A>   = (A -> R) -> R;
typedef Cont<R,A>               = Continuation<R,A>;
typedef FutureType<A>           = Cont<Void,A>;

@doc("
  The mother of all Monads. Rumour has it that only a handful of acolytes understand the true functioning of `cc`.
")
abstract Continuation<R,A>(ContinuationType<R,A>) from ContinuationType<R,A> to ContinuationType<R,A>{
  static public function cont<R,A>(def:ContinuationType<R,A>):Cont<R,A>{
    return new Continuation(def);
  }
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
    return function(cont:B->R):R{
      return apply(this,
        function(v:A){
          return cont(k(v));
        }
      );
    }
  }
  public function each(k:A->Void):Continuation<R,A>{
    return map(
      function(x){
        k(x);
        return x;
      }
    );
  }
  public function flatMap<B>(k:A -> Continuation<R,B>):Continuation<R,B>{
    return new Continuation(
      function(cont : B -> R):R{
        return apply(this, function(a:A):R{ return k(a).apply(cont); });
      }
    );
  }
  public function zipWith<B,C>(cnt0:Continuation<R,B>,fn:A->B->C):Continuation<R,C>{
    return new Continuation(
      function(cont:C->R){
        return this(function(a){
          return cnt0.apply(function(b){
            return cont(fn(a,b));
          });
        });
      }
    );
  }
  static public function bindFold<R,A,B>(arr:Array<A>,init:B,fold:B->A->Cont<R,B>){
    return stx.Arrays.foldLeft(arr,
      pure(init),
      function(memo:Cont<R,B>,next:A){
        return memo.flatMap(
          function(b:B){
            return fold(b,next);
          }
        );
      }
    );
  }
  // ((A->((B->R)->R))->((A->R)->R)) -> ((A->R)->R)
  // ((A->((B->Void)->Void))->((A->Void)->Void)) ((A->R)->R)
  // (Arrow<A,B>->Future<A>)->Future<A>

  static public function cc<R,A,B>(f:(A->Continuation<R,B>)->Continuation<R,A>):Continuation<R,A>{
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
    var ft = Eventual.create();
    cont(
      ft.deliver
    );
    return ft;
  }
}