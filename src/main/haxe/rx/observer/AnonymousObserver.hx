package rx.observer;

import stx.Fail;
import Prelude;
import stx.Chunk;

import rx.ifs.Observer in IObserver;

class AnonymousObserver<T> implements IObserver<T> extends BaseObserver<T>{
  @:noUsing static public function create<T>(fn:Chunk<T>->Void):AnonymousObserver<T>{
    return new AnonymousObserver(fn);
  }
  private var observe_method : Chunk<T> -> Void;

  public function new(observe_method){
    super();
    this.observe_method = observe_method; 
  }
  override public inline function apply(chk:Chunk<T>):Void{
    if(!disposed){
      switch(chk){
        case Val(v) : 
        case End(e) : disposed = true; 
        case Nil    : disposed = true; 
      }
      observe_method(chk);
    }
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