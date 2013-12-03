package hx.action;

import Prelude;
import Stax.*;

import hx.ifs.Action in IAction;

class AnonymousAction<T> implements IAction<T>{
  public function new(_apply){
    this._apply = _apply;
  }
  private dynamic function _apply(v:T){
    except()(ArgumentError('apply',NullError()));
  }
  public function apply(v:T){
    this._apply(v);
  }
}