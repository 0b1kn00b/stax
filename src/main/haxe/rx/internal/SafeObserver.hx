package rx.internal;

import Stax.*;
import stx.Log.*;

import rx.ifs.Observer in IObserver;

class SafeObserver<T> implements IObserver{
  private var observer    : Observer<T>;
  private var disposable  : Disposable;

  public function (observer, disposable){
    this.observer     = observer;
    this.disposable   = disposable;
  }
  public function onData(v:T){
    var noError = false;
    try{
      observer.onData(v);
      noError = true;
    }catch (e:Dynamic){
      trace(error(e));
    }
    if(noError){
      disposable.dispose();
    }
  }
  public function onFail(f:Fail){
    try{
      observer.onFail(f);
    }catch(e:Dynamic){
      trace(error(e));
    }
  }
  public function onDone(){
    try{
      
    }
  }
}