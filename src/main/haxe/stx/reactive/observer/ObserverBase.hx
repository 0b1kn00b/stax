package stx.reactive.observer;

import stx.Chunk;

import stx.Fail;
import Stax.*;
import Prelude;

import stx.reactive.ifs.Observer;

@doc("Abstract base class for implementations of the IObserver<T> interface.")
@remark("This base class enforces the grammar of observers where OnError and OnCompleted are terminal messages")
@typeparam({name:"T"},"The type of the elements in the sequence.")
class ObserverBase<T> implements Observer<T>{
  private var stopped : Bool;
  public function new(){
    stopped = false;
  }
  public function apply(chk:Chunk<T>):Void{
    switch(chk){
      case Val(v) : onData(v);
      case End(e) : onFail(e);
      case Nil    : onDone();
    }
  }
  public function onData(v:T){
    if(!stopped){
      onDataCore(v);
    }
  }
  @doc("Implement this method to react to the receival of a new element in the sequence.")
  @remark("This method only gets called when the observer hasn't stopped yet.")
  @:unimplemented
  private function onDataCore(v:T){
    except()(ArgumentError('onDataCore',NullError()));
  }
  public function onFail(f:Fail){
    assert(f);
    onFailCore(f);
  }
  @doc("Implement this method to react to the receival of a new element in the sequence.")
  @remark("This method only gets called when the observer hasn't stopped yet.")
  @:unimplemented
  private function onFailCore(f:Fail){
    except()(ArgumentError('onFailCore',NullError())); 
  }
  public function onDone(){
    onDoneCore();
  }
  @doc("Implement this method to react to the end of the sequence.")
  @remark("This method only gets called when the observer hasn't stopped yet, and causes the observer to stop.")
  @:unimplemented
  private function onDoneCore(){
    except()(ArgumentError('onDoneCore',NullError()));  
  }

  @doc("Core implementation of IDissolvable.")
  @params(["disposing","true if the Dispose call was triggered by the IDissolvable.Dispose method; false if it was triggered by the finalizer"])
  private function disposal(disposing:Bool){
    if (disposing){
      stopped = true;
    }
  }
  public function dispose(){
    disposal(true);
  }
}