package rx.observable;

import Stax.*;

import rx.ifs.Observable in IObservable;

class AnonymousObservable<T> implements IObservable<T>{
  public function new(subscribe){
    this._subscribe = subscribe;
  }
  public inline function subscribe(obs:Observer<T>):Disposable{
    return this._subscribe(obs);
  }
  private dynamic function _subscribe(obs:Observer<T>):Disposable{
    return noop;    
  }
}