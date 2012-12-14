package stx.arw;

import stx.Prelude;
import stx.arw.Arrows;

class RightChoiceArrow<B,C,D> extends Arrow<Either<D,B>,Either<D,C>>{
	private var a : Arrow<B,C>;
	public function new(a){
		super();
		this.a = a;
	}
	override inline public function withInput(?i:Either<D,B>, cont : Function1<Either<D,C>, Void>){
		switch (i) {
			case Right(v) 	:
				new ApplyArrow().withInput( Tuples.t2(a,v) ,
					function(x){
						cont( Right(x) );
					}
				);
			case Left(v) :
				cont( Left(v) );
		}
	}
}