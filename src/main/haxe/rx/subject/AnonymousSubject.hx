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
}