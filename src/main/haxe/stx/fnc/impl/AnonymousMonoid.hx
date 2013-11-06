package stx.fnc.impl;

import stx.Fail;
import Stax.*;
import Prelude;
import stx.fnc.ifs.Monoid in IMonoid;

class AnonymousMonoid<T> implements IMonoid<T>{
  public function new(zero:Thunk<T>,append:Semi<T>){
    this._append  = append;
    this._zero    = zero;
  }
  private dynamic function _append(a1: T, a2: T):T{
    return except()(AbstractMethodError());
  }
  private dynamic function _zero():T{
    return except()(AbstractMethodError());
  }
  public inline function append(a1:T, a2:T):T{
    return _append(a1,a2);
  }
  public inline function zero():T{
    return _zero();
  }
}