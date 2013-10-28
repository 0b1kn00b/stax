package rx.observer;

import stx.Prelude;
import stx.Chunk;

import rx.ifs.Observer in IObserver;

class AnonymousObserver<T> implements IObserver<T> extends BaseObserver<T>{
  @:noUsing static public function create<T>(fn:Chunk<T>->Void):AnonymousObserver<T>{
    return new AnonymousObserver(fn);
  }
  private var observe_method : Chunk<T> -> Void;

  public function new(observe_method){
    this.observe_method = observe_method; 
  }
  override public inline function apply(chk:Chunk<T>):Void{
    if(!done){
      switch(chk){
        case Val(v) : 
        case End(e) : done = true; 
        case Nil    : done = true; 
      }
      observe_method(chk);
    }
  }
}