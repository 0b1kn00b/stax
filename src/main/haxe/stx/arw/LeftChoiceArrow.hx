package stx.arw;

import stx.Prelude;
import stx.arw.Arrows;

typedef ArrowLeftChoice<B,C,D> = Arrow<Either<B,D>,Either<C,D>>
abstract LeftChoiceArrow<B,C,D>(ArrowLeftChoice<B,C,D>) from ArrowLeftChoice<B,C,D> to ArrowLeftChoice<B,C,D>{

	public function new(a:Arrow<B,C>){
		return new Arrow(
			inline function(?i:Either<B,D>, cont : Function1<Either<C,D>,Void>){
				switch (i) {
					case Left(v) 	:
						new ApplyArrow().rep().withInput( Tuples.t2(a,v) ,
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
	public function apply(?i){
    return this.apply(i);
  }
  public function rep(){
  	return this;
  }
}