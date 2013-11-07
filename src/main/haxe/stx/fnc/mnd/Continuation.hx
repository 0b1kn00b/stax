package stx.fnc.mnd;

using stx.fnc.Monad;

import stx.fnc.Continuation in AContinuation;

typedef ContinuationType<R,A>   = (A->R)->R;
typedef FutureType<A>           = Continuation<Void,A>;

class Continuation<R,A> extends Base<ContinuationType<R,A>,A>{
	public function apply(fn: A->R): R {
    return this.box().unbox()(fn);
  }	
	override public function flatMap<B>(k:A -> AContinuation<R,B>,?self: AContinuation<R,A>): Monad<B> {
		self = self == null ? this : self;
    return new Continuation(
      function(cont: B->R): R {
        return Continuations.apply(self,function(a:A):R{ return Continuations.apply(k(a),cont); });
      }
    );
  }
  override public function map<B>(k: A->B, ?self: AContinuation<R,A>): Monad<B> {
    return box().box(function(cont: B->R): R {
      return Continuations.apply(self,
        function(v:A){
          return cont(k(v));
        }
      );
    });
  }
}
class Continuations{
	@:noUsing static public function pure<R,A>(a:A):AContinuation<R,A>{
    return new Continuation(function(x:A->R){
      return x(a);
    });
  }
  static public function apply<R,A,M:(Monad<A>,AContinuation<R,A>)>(m:M,fn:A->R):R{
    var v : AContinuation<R,A> = m;
    return v.box().unbox()(fn);
  }
}