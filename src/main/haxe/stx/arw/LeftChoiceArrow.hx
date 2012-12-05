class LeftChoice<B,C,D> implements Arrow<Either<B,D>,Either<C,D>>{
	private var a : Arrow<B,C>;

	public function new(a){
		this.a = a;
	}
	inline public function withInput(?i:Either<B,D>, cont : Function1<Either<C,D>,Void>){
		switch (i) {
			case Left(v) 	:
				new ArrowApply().withInput( Tuples.t2(a,v) ,
					function(x){
						cont( Left(x) );
					}
				);
			case Right(v) :
				cont( Right(v) );
		}
	}
/*	public static function lout<A,B,C,D>(arr:Arrow<A,Either<C,D>>):Arrow<Either<A,B>,Either<C,D>>{
		return new LeftChoice(arr).then(Eithers.flattenL.lift());
	}*/
}