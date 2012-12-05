package stx.arw;

import stx.Prelude;
import stx.arw.Arrows;

class FunctionArrow<I,O> extends Arrow<I,O> {
	var f : Function1<I,O>;
	public function new (m : Function<I,O>) { super(); this.f = m;}

	override inline public function withInput(?i : I, cont : Function1<O,Void>) : Void { cont(f(i)); }
}