package rx.internal;

import rx.ifs.Observer in IObserver;

@doc("Base class for implementation of query operators, providing a lightweight sink that can be disposed to mute the outgoing observer.")
@:note("
  Implementations of sinks are responsible to enforce the message grammar on the associated observer. Upon sending a terminal message, 
  a pairing Dispose call should be made to trigger cancellation of related resources and to mute the outgoing observer."
)
class Sink<T> implements Dissolvable{
  private var observer        : Observer<T>
  private var dissolvable      : Dissolvable;

  public function new(observer,dissolvable){
    this.observer     = observer;
    this.dissolvable   = dissolvable;
  }
  public function dispose(){
    observer = Observer.unit();
    if(dissolvable!=null){
      dissolvable.dispose();
    }
  }
  public function forward(){
    return new SinkInner(this);
  }
}
private class SinkInner<T> implements IObserver{
  private var sink : Sink<T>;
  public function new(sink){
    this.sink = sink;
  }
  public function onData(v:T){
    sink.observer.onData(v);
  }
  public function onFail(f:Fail){
    sink.observer.onFail(f);
    sink.dispose();
  }
  public function onDone(){
    sink.observer.onDone();
    sink.dispose();
  }
}