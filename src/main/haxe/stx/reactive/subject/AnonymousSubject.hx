package rx.subject;

import rx.ifs.Subject in ISubject;

import stx.ds.List;

class AnonymousSubject<T> implements ISubject<T>{
  private var observer    : Observer<T>;
  private var observable  : observable<T>;

  public function subject(observer, observable){
    this.observer     = observer;
    this.observable   = observable;
  }
  public function onData(d:T):Void{
    this.observer.onData(d);
  }
  public function onFail(f:Fail):Void{
    this.observer.onFail(f);
  }
  public function onDone():Void{
    this.observer.onDone();
  }
  public function subscribe(obs:Observer<T>):Dissolvable{
    return obs.subscribe(obs);
  }
}