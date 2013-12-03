package rx.observable;


using hx.Reactor;

import stx.Chunk;

import rx.ifs.Observable;
import rx.disposable.*;


class ReactorChunkObservable<T> implements Observable<T>{
  private var reactor : Reactor<Chunk<T>>;
  public function new(reactor){
    this.reactor = reactor;
  }
  public function subscribe(obs:Observer<T>):Disposable{
    var key = Reactors.any();
    var val = function(chk:Chunk<T>){
      switch (chk) {
        case Val(v)     : obs.apply(Val(v));
        case Nil        : obs.apply(Nil);
        case End(e)     : e == null ? obs.apply(Nil) : obs.apply(End(e));
      }
    }
    reactor.on(key,val);
    return function(){
      reactor.rem(key,val);
      reactor = null;//?;
    }
  }
}