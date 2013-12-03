package rx.internal;

class Producer<T>{
  public function subscribe(observer: Observer<T>): Disposable {
    return SubscribeRaw(observer, true);
  }
  private function SubscribeRaw(observer: Observer<T>, enableSafeGuard: Bool): Disposable{
    var state = new State(observer, new SingleAssignmentDisposable(), new SingleAssignmentDisposable());
    var d     = new CompositeDisposable(state.sink,state,subscription);
  }
}
private class State<T>{
  public function new(sink,subscription,observer){
    this.sink         = sink;
    this.subscription = subscription;
    this.observer     = observer;
  }
  public var sink           : SingleAssignmentDisposable;
  public var subscription   : SingleAssignmentDisposable;
  public var observer       : IObserver<Source>;

  public Assign(s: IDisposable<T>): Void{
    sink.Disposable = s;
  }
}