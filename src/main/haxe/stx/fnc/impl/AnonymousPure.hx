package stx.fnc.impl;

import stx.Fail;
import Stax.*;

import Prelude;
import stx.fnc.ifs.Pure in IPure;

class AnonymousPure<T> implements IPure<T>{
  public function new<S>(pure:S->T){
    this._pure = pure;
  }
  private dynamic function _pure<S>(v:S):T{
    return except()(AbstractMethodError());
  }
  public function pure<S>(v:S):T{
    return _pure(v);
  }
}