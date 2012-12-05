package stx.arw;

import stx.Prelude;

using stx.arw.Arrows;
using stx.Compose;
using stx.Tuples;

class OptionArrow<I,O> extends Arrow<Option<I>,Option<O>>{
	private var a : Arrow<I,O>;

	public function new(a:Arrow<I,O>){
		super();
		this.a = a;
	}
	override inline public function withInput(?i:Option<I>,cont:Function1<Option<O>,Void>){
		switch (i) {
			case Some(v) : Arrows.apply().withInput( a.entuple(v) , Option.Some.then(cont));
			case None 	 : cont(None);
		}
	}
}