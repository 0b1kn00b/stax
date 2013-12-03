package rx.observer;

import Prelude;

import stx.Chunk;
import stx.Fail;


import rx.ifs.Observer in IObserver;

class AnonymousObserver<T> implements IObserver<T> extends ObserverBase<T>{
  @:noUsing static public function create<T>(fn:Chunk<T>->Void):AnonymousObserver<T>{
    return new AnonymousObserver(fn);
  }  
  private var observe_method  : Chunk<T> -> Void;

  public function new(observe_method){
    super();
    this.observe_method = observe_method; 
    this.stopped        = false;
  }
  override public inline function apply(chk:Chunk<T>):Void{
    if(!stopped){
      observe_method(chk);
    }
    super.apply(chk);
  }
  override public inline function onData(v:T){
    observe_method(Val(v));
  }
  override public inline function onFail(e:Fail){
    observe_method(End(e));
  }
  override public inline function onDone(){
    observe_method(Nil);
  }
}