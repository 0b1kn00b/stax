package stx.reactive.observable;

import stx.reactive.ifs.Observable in IObservable;

class DelegateObservable implements IObservable{
  private var observable    : Observable<T>;

  public function new(obs:Observable<T>){
    this.observable = obs;
  }
  public function subscribe(obs:Observer<T>):Dissolvable{
    return observable.subscribe(obs);
  }
}