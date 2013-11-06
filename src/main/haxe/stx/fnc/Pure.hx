package stx.fnc;

import stx.Types.*;

import stx.fnc.ifs.Pure in IPure;
import stx.fnc.ifs.Monad in IMonad;

import stx.fnc.impl.AnonymousPure;

abstract Pure<T>(IPure<T>) from IPure<T> to IPure<T> {
  public function new(v){
    this = v;
  }
  @:static public function fromT<T>(v: T): Pure<T> {
    return new AnonymousPure(function(x:T){ return construct(type(v),[x]); });
  }
  public function pure<S>(value:S):T{
    return this.pure(value);
  }
}