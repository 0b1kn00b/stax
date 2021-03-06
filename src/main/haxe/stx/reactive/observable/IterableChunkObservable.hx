package stx.reactive.observable;

import stx.ioc.Inject.*;

import hx.ifs.Scheduler;

import stx.Chunk;

using stx.Iterables;

import stx.async.Dissolvable;

import stx.reactive.ifs.Observable in IObservable;

import stx.async.dissolvable.CompositeDissolvable;

class IterableChunkObservable<T> implements IObservable<T>{
  private var scheduler : Scheduler;
  private var iterable  : Iterable<Chunk<T>>;

  public function new(iterable:Iterable<Chunk<T>>,?scheduler){
    this.scheduler  = scheduler == null ? inject(Scheduler) : scheduler;
    this.iterable   = iterable;
  }
  public function subscribe(o:Observer<T>):Dissolvable{
    Iterables.each(iterable,
      function(x){
        scheduler.immediate(
          function(){
            o.apply(x);
          }
        );
      }
    );
    return Dissolvable.unit();
  }
}