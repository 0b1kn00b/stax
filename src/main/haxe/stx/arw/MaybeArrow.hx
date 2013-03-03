package stx.arw;

import stx.Prelude;

using stx.arw.Arrows;
using stx.Compose;
using stx.Tuples;

typedef ArrowMaybe<I,O> = Arrow<Maybe<I>,Maybe<O>>

abstract MaybeArrow<I,O>(ArrowMaybe<I,O>) from ArrowMaybe<I,O> to ArrowMaybe<I,O>{

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
}