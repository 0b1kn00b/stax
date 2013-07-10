package stx;

import stx.Future;
import stx.Options;
import stx.Eventual;
import stx.Prelude;
using stx.Tuples;

typedef ContinuationType<R,A>   = (A -> R) -> R;
typedef Cont<R,A>               = Continuation<R,A>;

abstract Continuation<R,A>(ContinuationType<R,A>) from ContinuationType<R,A> to ContinuationType<R,A>{
  static public function cont<R,A>(def:ContinuationType<R,A>):Cont<R,A>{
    return new Continuation(def);
  }
  @:noUsing static public function pure<R,A>(r:R):Continuation<R,A>{
    return function(x:A->R){
      return r;
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
    fn = Options.orDefault(fn,function(x){ trace('continuation result dropped'); return null; });
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
  public function foreach(k:A->Void):Continuation<R,A>{
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
  public function cc<B>(f:(A->Continuation<R,B>)->Continuation<R,A>):Continuation<R,A>{
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
  static public inline function toFuture<A>(cont:ContinuationType<Void,A>):Future<A>{
    return Future.ofArrow(cont);
  }
}