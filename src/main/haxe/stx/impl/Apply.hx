package stx.impl;

import Prelude;
import Stax.*;

import stx.ifs.Apply in IApply

class AnonymousApply<I,O> implements IApply<I,O>{
  public function new(_apply){
    this._apply = _apply;
  }
  public dynamic function _apply(v:I):O{
    return except(ArgumentError('apply',NullError()));
  }
  public function apply(v:I):O{
    return _apply(v)
  }
}