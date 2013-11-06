package stx.arw;

import stx.Tuples;
import Prelude;

using stx.Option;
using stx.Arrow;
using stx.Compose;
using stx.Tuples;
using stx.Functions;

typedef ArrowOption<I,O> = Arrow<Option<I>,Option<O>>

abstract OptionArrow<I,O>(ArrowOption<I,O>) from ArrowOption<I,O> to ArrowOption<I,O>{

	@:noUsing static public function unit<I>():OptionArrow<I,I>{
		return new OptionArrow(Arrow.unit());
	}
  @:noUsing static public function pure<I,O>(arw:Arrow<I,O>):OptionArrow<I,O>{
    return new OptionArrow(arw);
  }
  @:to public function toArrowType():ArrowType<Option<I>,Option<O>>{
    return this.asFunction();
  }
  /*static public function maybe<I,O>(?arw:Arrow<I,O>):OptionArrow<I,O>{
		return pure( arw == null ? cast Arrow.unit(): arw);
	}*/
	public function new(a:Arrow<I,O>):OptionArrow<I,O>{
		this = new Arrow(
			inline function (?i:Option<I>,cont:Option<O>->Void){
				switch (i) {
					case Some(v) : a.withInput(v,Some.then(cont));
					case None 	 : cont(None);
				}
			}
		);
	}
}