package stx.arw;

import stx.Prelude;
import stx.arw.Arrows;

typedef ArrowRightChoice<B,C,D> = Arrow<Either<D,B>,Either<D,C>>;

abstract RightChoiceArrow<B,C,D>(ArrowRightChoice<B,C,D>) from ArrowRightChoice<B,C,D> to ArrowRightChoice<B,C,D>{
	public function new(a){
		this = new Arrow(
			inline function (?i:Either<D,B>, cont : Function1<Either<D,C>, Void>){
				switch (i) {
					case Right(v) 	:
						new ApplyArrow().rep().withInput( Tuples.t2(a,v) ,
							function(x){
								cont( Right(x) );
							}
						);
					case Left(v) :
						cont( Left(v) );
				}
			}
		);
	}
}