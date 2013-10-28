package stx.rx.observable;

import stx.Outcome;
import stx.Contract;
import stx.Chunk;
import stx.rx.disposable.*;

import stx.rx.ifs.Observable in IObservable;

@doc("An Observable derived from a `stx.Contract` ")
class ContractObservable<T> implements IObservable<T>{
  private var contract : Contract<T>;
  public function new(contract){
    this.contract = contract;
  }
  public inline function subscribe(obs:Observer<T>):Disposable{
    var run = true;
    var val = function(v:Outcome<T>){
      if(run){
        switch (v) {
          case Success(v)   : obs.apply(Val(v));
          case Failure(f)   : obs.apply(End(f));
        }
        obs.apply(Nil);//and.. we're done
      }
    }
    contract.foreach(val);
    return function(){
      run = false;
    }
  }
}