package stx;

import stx.Tuples;
import stx.Prelude;
import stx.Fail;

import stx.Fail;

using stx.Tuples;
using stx.Either;
using stx.Eventual;

class EitherCombinators{
	static public function or<A,B,C>(a:A->Either<B,C>,b:A->Either<B,C>):A-> Either<B,C>{
		return function(x:A){
				return 
					switch (a(x)) {
						case Left(_) 	:
							b(x);
						case Right(v) : Right(v);
					}
			}
	}
	static public function and<A,B,C>(a:A->Either<B,C>,b:A->Either<B,C>):A->Either<B,Tuple2<C,C>>{
		return function(x:A){
				return 
					switch (a(x)) {
						case Left(v) 	: Left(v);
						case Right(v1) :
							switch(b(x)){
								case Left(v) : Left(v);
								case Right(v2) : Right(tuple2(v1,v2));
							}
					}
			}
	}
}
class EventualCombinators{
	static public function or<A,B,C>(a:A->Eventual<Either<B,C>>,b:A->Eventual<Either<B,C>>):A->Eventual<Either<B,C>>{
		return function(x){
				return 
				a(x).flatMap(
					function(y){
						return switch (y) {
							case Left(_) 	: b(x);
							case Right(v) : Eventual.pure(Right(v));
						}
					}
				);
			}
	}
	static public function and<A,B,C>(a:A->Eventual<Either<B,C>>,b:A->Eventual<Either<B,C>>):A->Eventual<Either<B,Tuple2<C,C>>>{
		return 
			function(x){ return 
					a(x).flatMap(
						function(y){
							return switch (y) {
								case Left(v) 		: Eventual.pure(Left(v));
								case Right(v1) 	:
									b(x)
										.flatMap(
											function(z){
												return 
													switch(z){
														case Left(v) 		: Eventual.pure(Left(v));
														case Right(v2)  : Eventual.pure(Right(tuple2(v1,v2)));
													}
											}
										);
							}
						}
					);
			}
	}
}