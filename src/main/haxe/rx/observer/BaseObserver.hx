package rx.observer;

import stx.Prelude;
import stx.Chunk;

import rx.ifs.Observer in IObserver;

class BaseObserver<T> implements IObserver<T> implements Disposable{
  private var done     : Bool;

  public function new(){
    done = false;
  }
  public function dispose(){
    done = true;
  }
  public function apply(chk:Chunk<T>):Void{
    switch(chk){
      case Val(v) : onData(v);
      case End(e) : onFail(f);
      case Nil    : onDone();
    }
  }
  public function onDone():Void{
    
  }
  public function onFail(f:Fail):Void{

  }
  public function onData(d:T):Void{

  }
}