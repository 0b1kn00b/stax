package stx.ds.iter;

import Stax.*;
import Prelude;

class AnonymousIterable<T>{
  public function new(iterator:Void->Iterator<T>){
    this._iterator = iterator;
  }   
  public dynamic function _iterator():Iterator<T>{
    return except()(NullError());
  }
  public function iterator():Iterator<T>{
    return _iterator();
  }
}