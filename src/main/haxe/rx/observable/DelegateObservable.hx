package rx.observable;

class DelegateObservable{
  private var observable    : Observable<T>;

  public function new(obs:Observable<T>){
    this.observable = obs;
  }
  public function subscribe(obs:Observer<T>):Disposable{
    return observable.subscribe(obs);
  }
}