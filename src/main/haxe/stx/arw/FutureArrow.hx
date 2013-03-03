package stx.arw;

import stx.Prelude;

using stx.arw.Arrows;

typedef ArrowFuture<O> = Arrow<Future<O>,O>;

abstract FutureArrow<O>(ArrowFuture<O>) from ArrowFuture<O> to ArrowFuture<O>{
	public function new(){
    this = new Arrow(inline function (?i:Future<O>,cont:Function1<O,Void>):Void{
      i.foreach( cont );  
    });
	}
  public function apply(?i){
    return this.apply(i);
  }
}