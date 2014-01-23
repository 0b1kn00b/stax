package stx.reactive.observable;

import stx.async.Dissolvable;

import Stax.*;
import stx.Chunk;
import stx.reactive.ifs.Observable in IObservable;

using stx.Arrays;

class BufferedObservable<T> implements IObservable<T>{
  private var observable    : Observable<T>;
  private var buffer        : Array<Chunk<T>>;

  public function new(obs:Observable<T>){
    this.buffer         = [];
    this.observable     = obs;
    this.observable.subscribe(
      function(chk:Chunk<T>):Void{
        buffer.push(chk);
      }
    );
  }
  
  public function subscribe(obs:Observer<T>):Dissolvable{
    buffer.each(obs.apply);
    return observable.subscribe(obs);
  }
}