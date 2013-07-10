package stx.arw;

import stx.Prelude;

using stx.arw.Arrows;

typedef ArrowEventual<O> = Arrow<Eventual<O>,O>;

abstract EventualArrow<O>(ArrowEventual<O>) from ArrowEventual<O> to ArrowEventual<O>{
	public function new(){
    this = new Arrow(inline function (?i:Eventual<O>,cont:Function1<O,Void>):Void{
      i.foreach( cont );  
    });
	}
  public function apply(?i){
    return this.apply(i);
  }
}