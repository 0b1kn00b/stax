package stx.rx.observable;

import stx.rx.ifs.Observable;
import stx.Eventual;
import stx.Chunk;
import stx.rx.disposable.*;

class EventualObservable<T> implements Observable<T>{
  private var eventual : Eventual<T>;
  public function new(eventual){
    this.eventual = eventual;
  }
  public inline function subscribe(obs:Observer<T>):Disposable{
    var run = true;
    var val = function(v:T){
      if(run){
        obs.apply(Val(v));
        obs.apply(Nil);//signifying done
        run=false;
      }
    }
    eventual.foreach(val);
    
    return function(){
      run = false;
    }
  } 
}