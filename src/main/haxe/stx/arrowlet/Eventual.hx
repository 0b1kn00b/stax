package stx.arrowlet;

import Prelude;

using stx.Arrowlet;

typedef ArrowletEventual<O> = Arrowlet<stx.Eventual<O>,O>;

abstract Eventual<O>(ArrowletEventual<O>) from ArrowletEventual<O> to ArrowletEventual<O>{
	public function new(){
    this = new Arrowlet(inline function (?i:stx.Eventual<O>,cont:O->Void):Void{
      i.each( cont );
    });
	}
  public function apply(?i){
    return this.apply(i);
  }
}