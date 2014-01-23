package stx.async.arrowlet;

import stx.Tuples;
import Prelude;
using stx.async.Arrowlet;

typedef ArrowletRightChoice<B,C,D> = Arrowlet<Prelude.Either<D,B>,Prelude.Either<D,C>>;

abstract RightChoice<B,C,D>(ArrowletRightChoice<B,C,D>) from ArrowletRightChoice<B,C,D> to ArrowletRightChoice<B,C,D>{
	public function new(a:Arrowlet<B,C>){
		this = new Arrowlet(
			function (?i:Prelude.Either<D,B>, cont: Prelude.Either<D,C>->Void){
				switch (i) {
					case Right(v) 	:
						new Apply().withInput( tuple2(a,v) ,
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
	@:to public inline function asArrowlet():Arrowlet<Either<D,B>,Either<D,C>>{
		return this;
	}
}