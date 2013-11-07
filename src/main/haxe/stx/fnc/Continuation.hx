package stx.fnc;

import stx.fnc.mnd.Continuation in CContinuation;

abstract Continuation<R,A>(CContinuation<R,A>) from CContinuation<R,A> to CContinuation<R,A>{
  public function new(v){
    this = v;
  }
  public function apply(fn: A->R): R {
    return this.apply(fn);
  } 
  public function flatMap<B>(fn: A->Continuation<R,A>, ?self: Continuation<R,A>): Continuation<R,B>{
    return this.flatMap(fn,self);
  }
  public function map<B>(fn: A->B, ?self: Continuation<R,A>): Continuation<R,B>{
    return this.map(fn,self);
  }
  @:to public function toMonad():Monad<A>{
    return this;
  }
  @:from static public function fromMonad<M:(Monad<A>,CContinuation<R,A>),R,A>(m:M):Continuation<R,A>{
    return m;
  }
}