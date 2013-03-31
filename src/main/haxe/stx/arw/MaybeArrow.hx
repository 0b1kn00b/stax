package stx.arw;

import stx.Prelude;

using stx.Maybes;
using stx.arw.Arrows;
using stx.Compose;
using stx.Tuples;

typedef ArrowMaybe<I,O> = Arrow<Maybe<I>,Maybe<O>>

abstract MaybeArrow<I,O>(ArrowMaybe<I,O>) from ArrowMaybe<I,O> to ArrowMaybe<I,O>{

	@:noUsing
	static public function unit<I>():MaybeArrow<I,I>{
		return new MaybeArrow(Arrow.unit());
	}
  @:noUsing
  static public function pure<I,O>(arw:Arrow<I,O>):MaybeArrow<I,O>{
    return new MaybeArrow(arw);
  }
	static public function maybe<I,O>(?arw):MaybeArrow<I,O>{
		return arw == null ? cast unit() : pure(arw);
	}
	public function new(a:Arrow<I,O>){
		this = new Arrow(
			inline function (?i:Maybe<I>,cont:Function1<Maybe<O>,Void>){
				switch (i) {
					case Some(v) : Arrows.apply().withInput( a.entuple(v) , Maybe.Some.then(cont));
					case None 	 : cont(None);
				}
			}
		);
	}
	public function apply(?i){
    return this.apply(i);
  }
  public function asArrow():ArrowMaybe<I,O>{
  	return this;
  }
}