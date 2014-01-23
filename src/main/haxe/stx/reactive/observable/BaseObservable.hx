package stx.reactive.observable;

import stx.async.NullDissolvable;

import Stax.*;

import stx.reactive.ifs.Observable in IObservable;

class AnonymousObservable<T> implements IObservable<T>{

  public var type(get) : String;
  private function get_type():String{
    return definition(this);
  }
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