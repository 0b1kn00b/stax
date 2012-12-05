package stx.arw;
class RightChoiceArrow<B,C,D> implements Arrow<Either<D,B>,Either<D,C>>{
	private var a : Arrow<B,C>;
	public function new(a){
		this.a = a;
	}
	inline public function withInput(?i:Either<D,B>, cont : Function1<Either<D,C>, Void>){
		switch (i) {
			case Right(v) 	:
				new ArrowApply().withInput( Tuples.t2(a,v) ,
					function(x){
						cont( Right(x) );
					}
				);
			case Left(v) :
				cont( Left(v) );
		}
	}
	public static function right<B,C,D>(arr:Arrow<B,C>):Arrow<Either<D,B>,Either<D,C>>{
		return new RightChoice(arr);
	}
	static public function rightF<B,C,D>(fn:B->C):Arrow<Either<D,B>,Either<D,C>>{
		return right(fn.lift());
	}
	public static function rout<A,B,C,D>(arr:Arrow<B,Either<C,D>>):Arrow<Either<C,B>,Either<C,D>>{
		return new RightChoice(arr).then(Eithers.flattenR.lift());
	}
}