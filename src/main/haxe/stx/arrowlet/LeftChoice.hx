package stx.arrowlet;

import stx.Tuples;
import Prelude;
using stx.Arrowlet;

typedef ArrowletLeftChoice<B,C,D> = Arrowlet<Either<B,D>,Either<C,D>>
abstract LeftChoice<B,C,D>(ArrowletLeftChoice<B,C,D>) from ArrowletLeftChoice<B,C,D> to ArrowletLeftChoice<B,C,D>{

	public function new(a:Arrowlet<B,C>){
		return new Arrowlet(
			inline function(?i: Prelude.Either<B,D>, cont: Prelude.Either<C,D>->Void){
				switch (i) {
					case Left(v) 	:
						new Apply().withInput( tuple2(a,v) ,
							function(x){
								cont( Left(x) );
							}
						);
					case Right(v) :
						cont( Right(v) );
				}
			}
		);
	}
}