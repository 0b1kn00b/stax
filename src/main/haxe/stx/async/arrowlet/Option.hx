package stx.async.arrowlet;

import stx.Tuples;
import Prelude;

using stx.Option;
using stx.async.Arrowlet;
using stx.Compose;
using stx.Tuples;
using stx.Functions;

typedef ArrowletOption<I,O> = Arrowlet<Prelude.Option<I>,Prelude.Option<O>>

abstract Option<I,O>(ArrowletOption<I,O>) from ArrowletOption<I,O> to ArrowletOption<I,O>{

	@:noUsing static public function unit<I>():Option<I,I>{
		return new Option(Arrowlet.unit());
	}
  @:noUsing static public function pure<I,O>(arw:Arrowlet<I,O>):Option<I,O>{
    return new Option(arw);
  }
  @:to public function toArrowletType():ArrowletType<Prelude.Option<I>,Prelude.Option<O>>{
    return this.asFunction();
  }
  /*static public function maybe<I,O>(?arw:Arrowlet<I,O>):Option<I,O>{
		return pure( arw == null ? cast Arrowlet.unit(): arw);
	}*/
	public function new(a:Arrowlet<I,O>):Option<I,O>{
		this = new Arrowlet(
			inline function (?i:Prelude.Option<I>,cont:Prelude.Option<O>->Void){
				switch (i) {
					case Some(v) : a.withInput(v,Some.then(cont));
					case None 	 : cont(None);
				}
			}
		);
	}
}