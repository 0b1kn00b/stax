package stx.async.arrowlet;

import Prelude;

using stx.async.Arrowlet;

typedef ArrowletEventual<O> = Arrowlet<stx.async.Eventual<O>,O>;

abstract Eventual<O>(ArrowletEventual<O>) from ArrowletEventual<O> to ArrowletEventual<O>{
	public function new(){
    this = new Arrowlet(inline function (?i:stx.async.Eventual<O>,cont:O->Void):Void{
      i.each( cont );
    });
	}
  public function apply(?i){
    return this.apply(i);
  }
}