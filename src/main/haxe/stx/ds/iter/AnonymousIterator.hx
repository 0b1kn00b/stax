package stx.ds.iter;

import Stax.*;
import Prelude;

class AnonymousIterator<T>{
  public function new(next:Void->T,hasNext:Void->Bool){
    this._next    = next;
    this._hasNext = hasNext;
  }
  public function next():T{
    return _next();
  }
  public dynamic function _next():T{
    return except()(NullError());
  }
  public function hasNext():Bool{
    return _hasNext();
  }
  public dynamic function _hasNext():Bool{
    return except()(NullError());
  }
}