package stx.reactive.observable;

import Prelude;

import stx.Outcome;
import stx.async.Contract;
import stx.async.dissolvable.*;
import stx.async.Dissolvable;
import stx.Chunk;
import stx.reactive.dissolvable.*;

import stx.reactive.ifs.Observable in IObservable;

@doc("An Observable derived from a `stx.async.Contract`.")
class ContractObservable<T> implements IObservable<T>{
  private var contract : Contract<T>;
  public function new(contract){
    this.contract = contract;
  }
  public function subscribe(obs:Observer<T>):Dissolvable{
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
    contract.each(val);
    return new AnonymousDissolvable(function(){
      run = false;
    });
  }
}