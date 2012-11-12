package stx {
	import stx.Either;
	import stx.Tuples;
	import stx.Eithers;
	import stx.Future;
	public class Promises {
		static public function mapR(f : stx.Future,fn : Function) : stx.Future {
			return f.map(function(x : stx.Either) : stx.Either {
				return stx.Eithers.mapR(x,function(y : *) : * {
					return fn(y);
				});
			});
		}
		
		static public function zipRWith(f0 : stx.Future,f1 : stx.Future,fn : Function) : stx.Future {
			return f0.zipWith(f1,function(a : stx.Either,b : stx.Either) : stx.Either {
				return function() : stx.Either {
					var $r : stx.Either;
					{
						var $e2 : enum = (a);
						switch( $e2.index ) {
						case 0:
						var v1 : * = $e2.params[0];
						$r = stx.Either.Left(v1);
						break;
						case 1:
						var v11 : * = $e2.params[0];
						$r = function() : stx.Either {
							var $r3 : stx.Either;
							{
								var $e4 : enum = (b);
								switch( $e4.index ) {
								case 0:
								var v2 : * = $e4.params[0];
								$r3 = stx.Either.Left(v2);
								break;
								case 1:
								var v21 : * = $e4.params[0];
								$r3 = stx.Either.Right(fn(v11,v21));
								break;
								}
							}
							return $r3;
						}();
						break;
						}
					}
					return $r;
				}();
			});
		}
		
		static public function zipR(f0 : stx.Future,f1 : stx.Future) : stx.Future {
			return stx.Promises.zipRWith(f0,f1,stx.Tuples.t2);
		}
		
		static public function flatMapR(f0 : stx.Future,fn : Function) : stx.Future {
			return f0.flatMap(function(x : stx.Either) : stx.Future {
				return function() : stx.Future {
					var $r : stx.Future;
					{
						var $e2 : enum = (x);
						switch( $e2.index ) {
						case 0:
						var v1 : * = $e2.params[0];
						$r = new stx.Future().deliver(stx.Either.Left(v1),{ fileName : "Future.hx", lineNumber : 354, className : "stx.Promises", methodName : "flatMapR"});
						break;
						case 1:
						var v2 : * = $e2.params[0];
						$r = fn(v2);
						break;
						}
					}
					return $r;
				}();
			});
		}
		
		static public function flatMapL(f0 : stx.Future,fn : Function) : stx.Future {
			return f0.flatMap(function(x : stx.Either) : stx.Future {
				return function() : stx.Future {
					var $r : stx.Future;
					{
						var $e2 : enum = (x);
						switch( $e2.index ) {
						case 1:
						var v1 : * = $e2.params[0];
						$r = new stx.Future().deliver(stx.Either.Right(v1),{ fileName : "Future.hx", lineNumber : 366, className : "stx.Promises", methodName : "flatMapL"});
						break;
						case 0:
						var v2 : * = $e2.params[0];
						$r = fn(v2);
						break;
						}
					}
					return $r;
				}();
			});
		}
		
		static public function promiseOf(e : stx.Either) : stx.Future {
			return new stx.Future().deliver(e,{ fileName : "Future.hx", lineNumber : 373, className : "stx.Promises", methodName : "promiseOf"});
		}
		
	}
}
