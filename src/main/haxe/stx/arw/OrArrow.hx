package stx.arw;

import stx.Prelude;
using stx.arw.Arrows;

abstract OrArrow<L, R, R0>(Arrow<Either<L,R>, R0>) from Arrow<Either<L,R>, R0> to Arrow<Either<L,R>, R0>{
	public function new(l:Arrow<L,R0>, r:Arrow<R,R0>) {
		this = new Arrow(
			inline function (?i : Either<L,R>, cont : Function1< R0, Void > ) : Void {
				switch (i) {
					case Left(v) 	: l.withInput(v,cont);
					case Right(v)	: r.withInput(v,cont);
				}
			}
		);
	}
}