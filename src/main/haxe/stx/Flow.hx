package stx;

import stx.Prelude;

typedef Flow<B,C,D> = B -> Either<C,D>;

class Flows{
	static public function flow<A,B,C,D>(f:Flow<B,C,D>):Either<A,B> -> Either<C,D>{
		return 
			function(e:Either<A,B>):Either<C,D>{
				return 
					switch (e) {
						case Left(v) 	: cast Left(v);
						case Right(v) : f(v);
					}
			}
	}
}