package stx;

import stx.Maybes;
import stx.Future;
import stx.Prelude;
import stx.Tuples;

private typedef TCont<R,A>  = Method<A -> R, R>;
typedef Cont<R,A>           = Continuation<R,A>;

abstract Continuation<R,A>(TCont<R,A>) from TCont<R,A> to TCont<R,A>{
  @:noUsing static public function pure<R,A>(r:R):Continuation<R,A>{
    return function(x:A->R){
        return r;
      }
  }
  public function new(v){
    this = v;
  }
  public function apply(?fn:A->R):R{
    fn = Maybes.orDefault(fn,function(x){ trace('continuation result dropped'); return null; });
    return this.apply(fn);
  }
  public function map<B>(k:A->B):Continuation<R,B>{
    return new Continuation(
      function(cont:B->R):R{
        return apply(this,
          function(v:A){
            return cont(k(v));
          }
        );
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
  static public function futureOf<A>(cont:Receive<A>):Future<A>{
    var ft = Future.create();
    cont(
      function(x) ft.deliver(x)
    );
    return ft;
  }
}