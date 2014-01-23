package stx.reactive.observable;

import Stax.*;

import stx.async.Dissolvable;
import stx.async.dissolvable.*;

import stx.reactive.ifs.Observable in IObservable;

class AnonymousObservable<T> implements IObservable<T>{
  public function new(_subscribe){
    this._subscribe = _subscribe;
  }
  public function subscribe(obs:Observer<T>):Dissolvable{
    return this._subscribe(obs);
  }
  private dynamic function _subscribe(obs:Observer<T>):Dissolvable{
    return new NullDissolvable();
  }
}