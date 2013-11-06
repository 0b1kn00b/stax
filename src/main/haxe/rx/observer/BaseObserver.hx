package rx.observer;

import stx.Fail;
import Prelude;
import stx.Chunk;

import rx.ifs.Observer in IObserver;
import rx.ifs.Disposable in IDisposable;

class BaseObserver<T> implements IObserver<T> implements IDisposable{
  private var disposed     : Bool;

  public function new(){
    disposed = false;
  }
  public function dispose(){
    disposed = true;
  }
  public function apply(chk:Chunk<T>):Void{
    switch(chk){
      case Val(v) : onData(v);
      case End(e) : onFail(e);
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