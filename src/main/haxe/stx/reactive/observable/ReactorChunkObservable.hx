package stx.reactive.observable;

using hx.Reactor;

import stx.Chunk;


import stx.async.Dissolvable;
import stx.reactive.ifs.Observable in IObservable;
import stx.async.dissolvable.*;

class ReactorChunkObservable<T> implements IObservable<T>{
  private var reactor : Reactor<Chunk<T>>;
  public function new(reactor){
    this.reactor = reactor;
  }
  public function subscribe(obs:Observer<T>):Dissolvable{
    var key = Reactors.any();
    var val = function(chk:Chunk<T>){
      switch (chk) {
        case Val(v)     : obs.apply(Val(v));
        case Nil        : obs.apply(Nil);
        case End(e)     : e == null ? obs.apply(Nil) : obs.apply(End(e));
      }
    }
    reactor.on(key,val);
    return new AnonymousDissolvable(function(){
      reactor.rem(key,val);
    });
  }
}