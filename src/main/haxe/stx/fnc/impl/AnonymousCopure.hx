package stx.fnc.impl;

import stx.Fail;
import Stax.*;

import Prelude;
import stx.fnc.ifs.Copure in ICopure;

class AnonymousCopure<T> implements ICopure<T>{
  public function new<S>(copure:S->T){
    this._copure = copure;
  }
  private dynamic function _copure<S>(v:S):T{
    return except()(AbstractMethodError());
  }
  public function copure<S>(v:S):T{
    return _copure(v);
  }
}