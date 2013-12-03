package rx.internal;

import rx.*;

class SubscribeSafe{
  static public function subscribeSafe<T>(observable:rx.Observable<T>,observer:rx.Observer<T>):Disposable{
    return observable.subscribe(observer);
  }
}