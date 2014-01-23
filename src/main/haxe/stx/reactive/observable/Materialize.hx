package stx.reactive.observable;

import stx.Chunk;

import hx.Action;

using rx.internal.SubscribeSafe;

@doc("Materializes the implicit notifications of an observable sequence as explicit notification values.")
class Materialize<T>{
  private var observable : Observable<T>;

  public function new(observable){
    this.observable = observable;
  }
  public function apply3(observer:Observer<Chunk<T>>,dissolvable:Dissolvable,setSink:Action<Dissolvable>):Dissolvable{
    var sink = new MaterializeInner();
    setSink(sink);
    return observable.subscribeSafe(sink);
  }
}
private class MaterializeInner<T> extends Sink<Chunk<T>> implements IObserver<T>{
  override public function onNext(v:T){
    observer.onData(Val(v));
  }
  override public function onFail(f:Fail){
    this.observer.onData(End(f));
    this.observer.opDone();

    this.dispose();
  }
  override public function onDone(){
    this.observer.onData(Nil);
    this.observer.onDone();

    this.dispose();
  }
}