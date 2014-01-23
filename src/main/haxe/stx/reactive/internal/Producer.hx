package rx.internal;

class Producer<T>{
  public function subscribe(observer: Observer<T>): Dissolvable {
    return SubscribeRaw(observer, true);
  }
  private function SubscribeRaw(observer: Observer<T>, enableSafeGuard: Bool): Dissolvable{
    var state = new State(observer, new SingleAssignmentDissolvable(), new SingleAssignmentDissolvable());
    var d     = new CompositeDissolvable(state.sink,state,subscription);
  }
}
private class State<T>{
  public function new(sink,subscription,observer){
    this.sink         = sink;
    this.subscription = subscription;
    this.observer     = observer;
  }
  public var sink           : SingleAssignmentDissolvable;
  public var subscription   : SingleAssignmentDissolvable;
  public var observer       : IObserver<Source>;

  public Assign(s: IDissolvable<T>): Void{
    sink.Dissolvable = s;
  }
}