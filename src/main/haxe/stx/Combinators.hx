package stx;

import stx.Tuples.*;
import stx.Prelude;
import stx.Error;

import stx.Error;

using stx.Tuples;
using stx.Eithers;
using stx.Future;

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
class FutureCombinators{
	static public function or<A,B,C>(a:A->Future<Either<B,C>>,b:A->Future<Either<B,C>>):A->Future<Either<B,C>>{
		return function(x){
				return 
				a(x).flatMap(
					function(y){
						return switch (y) {
							case Left(_) 	: b(x);
							case Right(v) : Future.pure(Right(v));
						}
					}
				);
			}
	}
	static public function and<A,B,C>(a:A->Future<Either<B,C>>,b:A->Future<Either<B,C>>):A->Future<Either<B,Tuple2<C,C>>>{
		return 
			function(x){ return 
					a(x).flatMap(
						function(y){
							return switch (y) {
								case Left(v) 		: Future.pure(Left(v));
								case Right(v1) 	:
									b(x)
										.flatMap(
											function(z){
												return 
													switch(z){
														case Left(v) 		: Future.pure(Left(v));
														case Right(v2)  : Future.pure(Right(tuple2(v1,v2)));
													}
											}
										);
							}
						}
					);
			}
	}
}