package stx.fnc;

import stx.fnc.mnd.Continuation in CContinuation;
import stx.fnc.mnd.Continuation.Continuations;

abstract Future<T>(Continuation<Void,T>) from Continuation<Void,T> to Continuation<Void,T>{
  public function new(v){
    this = v;
  }
  @:to public function toMonad():Monad<T>{
    return this;
  }
  public function flatMap<U>(fn:T->Future<U>,?self:Future<T>):Future<U>{
    return this.flatMap(fn,self);
  }
  public function map<U>(fn:T->U,?self:Future<T>):Future<U>{
    return this.map(fn,self);
  }
}
class Futures{
  static public function pure<T>(v:T):Future<T>{
    return new Future(Continuations.pure(v));
  }
}