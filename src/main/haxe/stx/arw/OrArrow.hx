package stx.arw;

import stx.Prelude;
import stx.arw.Arrows;

class OrArrow<L, R, R0> extends Arrow <Either<L, R>, R0> {
	var a : Arrow<L,R0>;
	var b : Arrow<R,R0>;
	
	public function new(l, r) {
		super();
		this.a = l;
		this.b = r;
	}
	override inline public function withInput(?i : Either<L,R>, cont : Function1< R0, Void > ) : Void {
		switch (i) {
			case Left(v) 	: a.withInput(v,cont);
			case Right(v)	: b.withInput(v,cont);
		}
	}
}