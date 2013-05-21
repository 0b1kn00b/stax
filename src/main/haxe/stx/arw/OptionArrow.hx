package stx.arw;

import stx.Tuples.*;
import stx.Prelude;

using stx.Options;
using stx.arw.Arrows;
using stx.Compose;
using stx.Tuples;
using stx.Functions;

typedef ArrowOption<I,O> = Arrow<Option<I>,Option<O>>

abstract OptionArrow<I,O>(ArrowOption<I,O>) from ArrowOption<I,O> to ArrowOption<I,O>{

	@:noUsing
	static public function unit<I>():OptionArrow<I,I>{
		return new OptionArrow(Arrow.unit());
	}
  @:noUsing
  static public function pure<I,O>(arw:Arrow<I,O>):OptionArrow<I,O>{
    return new OptionArrow(arw);
  }
  /*static public function maybe<I,O>(?arw:Arrow<I,O>):OptionArrow<I,O>{
		return pure( arw == null ? cast Arrow.unit(): arw);
	}*/
	public function new(a:Arrow<I,O>):OptionArrow<I,O>{
		this = new Arrow(
			inline function (?i:Option<I>,cont:Function1<Option<O>,Void>){
				switch (i) {
					case Some(v) : Arrows.application().withInput( tuple2(a,v) , Some.then(cont) );
					case None 	 : cont(None);
				}
			}
		);
	}
	public function apply(?i){
    return this.apply(i);
  }
  public function imply(?i){
    return this.apply( Options.create(i) );
  }
  public function asArrow():ArrowOption<I,O>{
  	return this;
  }
}