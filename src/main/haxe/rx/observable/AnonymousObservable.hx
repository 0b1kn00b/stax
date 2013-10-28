package rx.observable;


import rx.ifs.Observable in IObservable;

class AnonymousObservable<T> implements IObservable<T>{
  static public inline function create<T>(__underlying__:Observer<T>->Disposable):AnonymousObservable<T>{
    return new AnonymousObservable(__underlying__);
  }
  var __underlying__ : Observer<T> -> Disposable;

  public function new(__underlying__){
    this.__underlying__ = __underlying__;
  }
  public inline function subscribe(obs:Observer<T>):Disposable{
    return this.__underlying__(obs);
  }
}