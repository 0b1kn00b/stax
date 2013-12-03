package stx.arrowlet;

import Prelude;

using stx.Arrowlet;

abstract Or<L, R, R0>(Arrowlet<Prelude.Either<L,R>, R0>) from Arrowlet<Prelude.Either<L,R>, R0> to Arrowlet<Prelude.Either<L,R>, R0>{
	public function new(l:Arrowlet<L,R0>, r:Arrowlet<R,R0>) {
		this = new Arrowlet(
			inline function (?i: Prelude.Either<L,R>, cont: R0->Void): Void {
				switch (i) {
					case Left(v) 	: l.withInput(v,cont);
					case Right(v)	: r.withInput(v,cont);
				}
			}
		);
	}
}