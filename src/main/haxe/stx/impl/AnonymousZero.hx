package stx.impl;

using Stax.*;

import Prelude;
import stx.ifs.Zero;

class AnonymousZero<T> implements Zero<T>{
  public function new(zero:Thunk<T>){
    this._zero = zero;
  }
  public function zero():T{
    return _zero();
  }
  private dynamic function _zero():T{
    return fail(AbstractMethodError());
  }
}