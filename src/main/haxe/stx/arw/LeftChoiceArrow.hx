package stx.arw;

import stx.Prelude;
import stx.arw.Arrows;

class LeftChoiceArrow<B,C,D> extends Arrow<Either<B,D>,Either<C,D>>{
	private var a : Arrow<B,C>;

	public function new(a){
		super();
		this.a = a;
	}
	override inline public function withInput(?i:Either<B,D>, cont : Function1<Either<C,D>,Void>){
		switch (i) {
			case Left(v) 	:
				new ApplyArrow().withInput( Tuples.t2(a,v) ,
					function(x){
						cont( Left(x) );
					}
				);
			case Right(v) :
				cont( Right(v) );
		}
	}
}