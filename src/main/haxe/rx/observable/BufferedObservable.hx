package rx.observable;

import Stax.*;
import stx.Chunk;
import rx.ifs.Observable in IObservable;

using stx.Arrays;

class BufferedObservable<T> implements IObservable<T>{
  private var observable    : Observable<T>;
  private var buffer        : Array<Chunk<T>>;

  public function new(obs:Observable<T>){
    buffer              = [];
    this.observable     = obs;
    this.observable.subscribe(
      function(chk:Chunk<T>):Void{
        buffer.push(chk);
      }
    );
    this.buffer         = [];
  }
  
  public function subscribe(obs:Observer<T>):Disposable{
    buffer.each(obs.apply);
    return observable.subscribe(obs);
  }
}