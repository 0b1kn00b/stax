package stx.rx.observable;

import stx.rx.ifs.Observable;
import stx.rct.Reactor;
import stx.rct.Reactors;
import stx.Chunk;
import stx.rx.disposable.*;


class ReactorObservable<T> implements Observable<T>{
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