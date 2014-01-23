package stx.async.callback;

import stx.async.ifs.Callback;

class AnonymousCallback<T> implements Callback<T>{
  public function new(apply){
    this._apply = apply;
  }
  public function apply(v:T):Void{
    _apply(v);
  }
  private dynamic function _apply(v:T):Void{

  }
}