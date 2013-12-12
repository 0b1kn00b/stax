package rx.observer;

import Prelude;

import stx.Chunk;
import stx.Fail;


import rx.ifs.Observer in IObserver;

class AnonymousObserver<T> implements IObserver<T> extends ObserverBase<T>{
  @:noUsing static public function create<T>(fn:Chunk<T>->Void):AnonymousObserver<T>{
    return new AnonymousObserver(fn);
  }  
  public function new(_apply){
    super();
    this._apply         = _apply; 
    this.stopped        = false;
  }
  private dynamic function _apply(chk:Chunk<T>):Void{

  }
  override public inline function apply(chk:Chunk<T>):Void{
    if(!stopped){
      _apply(chk);
    }
  }
  override public inline function onData(v:T){
    _apply(Val(v));
  }
  override public inline function onFail(e:Fail){
    _apply(End(e));
  }
  override public inline function onDone(){
    _apply(Nil);
  }
}