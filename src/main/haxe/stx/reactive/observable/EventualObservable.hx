package stx.reactive.observable;

import stx.reactive.ifs.Observable;
import stx.async.dissolvable.*;
import stx.async.Dissolvable;
import stx.async.Eventual;
import stx.Chunk;
import stx.reactive.dissolvable.*;

class EventualObservable<T> implements Observable<T>{
  private var eventual : Eventual<T>;
  public function new(eventual){
    this.eventual = eventual;
  }
  public function subscribe(obs:Observer<T>):Dissolvable{
    var run = true;
    var val = function(v:T){
      if(run){
        obs.apply(Val(v));
        obs.apply(Nil);//signifying done
        run=false;
      }
    }
    eventual.each(val);
    
    return new AnonymousDissolvable(function(){
      run = false;
    });
  } 
}