package stx.fnc;

import stx.ifs.Container;
import stx.Types.*;

import stx.fnc.ifs.Copure in ICopure;

abstract Copure<T>(ICopure<T>) from ICopure<T> to ICopure<T> {
  public function new(v){
    this = v;
  }
  public function copure<S>(v:S):T{
    return this.copure(v);
  }
}