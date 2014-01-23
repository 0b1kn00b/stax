package stx.reactive.observable;


import hx.reactive.Dispatcher;

import stx.Chunk;

import stx.async.dissolvable.*;
import stx.async.Dissolvable;

import stx.reactive.ifs.Observable;
import stx.reactive.dissolvable.*;

class DispatcherChunkObservable<T> implements Observable<T>{
  private var dispatcher  : Dispatcher<Chunk<T>>;

  public function new(dispatcher){
    this.dispatcher = dispatcher;
  }
  public function subscribe(obs:Observer<T>):Dissolvable{
    var handler = function(chk:Chunk<T>){
      switch (chk) {
        case Val(v)     : obs.apply(Val(v));
        case Nil        : obs.apply(Nil);
        case End(e)     : e == null ? obs.apply(Nil) : obs.apply(End(e));
      }
    }
    dispatcher.add(handler);
    return new AnonymousDissolvable(function(){
      dispatcher.rem(handler);
    });
  }
}