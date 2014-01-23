package rx.internal;

import Stax.*;
import stx.io.Log.*;

import rx.ifs.Observer in IObserver;

class SafeObserver<T> implements IObserver{
  private var observer    : Observer<T>;
  private var dissolvable  : Dissolvable;

  public function (observer, dissolvable){
    this.observer     = observer;
    this.dissolvable   = dissolvable;
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
      dissolvable.dispose();
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