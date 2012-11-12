package stx {
	import stx.Option;
	import stx.Either;
	import stx.Tuples;
	import stx.Tuple2;
	public class Eithers {
		static public function toTuple(e : stx.Either) : stx.Tuple2 {
			return function() : stx.Tuple2 {
				var $r : stx.Tuple2;
				{
					var $e2 : enum = (e);
					switch( $e2.index ) {
					case 0:
					var v : * = $e2.params[0];
					$r = stx.Tuples.t2(v,null);
					break;
					case 1:
					var v1 : * = $e2.params[0];
					$r = stx.Tuples.t2(null,v1);
					break;
					default:
					$r = function() : stx.Tuple2 {
						var $r3 : stx.Tuple2;
						throw "Either is neither Left not Right";
						$r3 = null;
						return $r3;
					}();
					break;
					}
				}
				return $r;
			}();
		}
		
		static public function toTupleO(e : stx.Either) : stx.Tuple2 {
			return function() : stx.Tuple2 {
				var $r : stx.Tuple2;
				{
					var $e2 : enum = (e);
					switch( $e2.index ) {
					case 0:
					var v : * = $e2.params[0];
					$r = stx.Tuples.t2(stx.Option.Some(v),stx.Option.None);
					break;
					case 1:
					var v1 : * = $e2.params[0];
					$r = stx.Tuples.t2(stx.Option.None,stx.Option.Some(v1));
					break;
					default:
					$r = function() : stx.Tuple2 {
						var $r3 : stx.Tuple2;
						throw "Either is neither Left not Right";
						return $r3;
					}();
					break;
					}
				}
				return $r;
			}();
		}
		
		static public function toLeft(v : *) : stx.Either {
			return stx.Either.Left(v);
		}
		
		static public function toRight(v : *) : stx.Either {
			return stx.Either.Right(v);
		}
		
		static public function flip(e : stx.Either) : stx.Either {
			return function() : stx.Either {
				var $r : stx.Either;
				{
					var $e2 : enum = (e);
					switch( $e2.index ) {
					case 0:
					var v : * = $e2.params[0];
					$r = stx.Either.Right(v);
					break;
					case 1:
					var v1 : * = $e2.params[0];
					$r = stx.Either.Left(v1);
					break;
					}
				}
				return $r;
			}();
		}
		
		static public function left(e : stx.Either) : stx.Option {
			return function() : stx.Option {
				var $r : stx.Option;
				{
					var $e2 : enum = (e);
					switch( $e2.index ) {
					case 0:
					var v : * = $e2.params[0];
					$r = stx.Option.Some(v);
					break;
					default:
					$r = stx.Option.None;
					break;
					}
				}
				return $r;
			}();
		}
		
		static public function isLeft(e : stx.Either) : Boolean {
			return function() : Boolean {
				var $r : Boolean;
				{
					var $e2 : enum = (e);
					switch( $e2.index ) {
					case 0:
					$r = true;
					break;
					case 1:
					$r = false;
					break;
					}
				}
				return $r;
			}();
		}
		
		static public function isRight(e : stx.Either) : Boolean {
			return function() : Boolean {
				var $r : Boolean;
				{
					var $e2 : enum = (e);
					switch( $e2.index ) {
					case 0:
					$r = false;
					break;
					case 1:
					$r = true;
					break;
					}
				}
				return $r;
			}();
		}
		
		static public function right(e : stx.Either) : stx.Option {
			return function() : stx.Option {
				var $r : stx.Option;
				{
					var $e2 : enum = (e);
					switch( $e2.index ) {
					case 1:
					var v : * = $e2.params[0];
					$r = stx.Option.Some(v);
					break;
					default:
					$r = stx.Option.None;
					break;
					}
				}
				return $r;
			}();
		}
		
		static public function get(e : stx.Either) : * {
			return function() : * {
				var $r : *;
				{
					var $e2 : enum = (e);
					switch( $e2.index ) {
					case 0:
					var v : * = $e2.params[0];
					$r = v;
					break;
					case 1:
					var v1 : * = $e2.params[0];
					$r = v1;
					break;
					}
				}
				return $r;
			}();
		}
		
		static public function mapLeft(e : stx.Either,f : Function) : stx.Either {
			return function() : stx.Either {
				var $r : stx.Either;
				{
					var $e2 : enum = (e);
					switch( $e2.index ) {
					case 0:
					var v : * = $e2.params[0];
					$r = stx.Either.Left(f(v));
					break;
					case 1:
					var v1 : * = $e2.params[0];
					$r = stx.Either.Right(v1);
					break;
					}
				}
				return $r;
			}();
		}
		
		static public function map(e : stx.Either,f1 : Function,f2 : Function) : stx.Either {
			return function() : stx.Either {
				var $r : stx.Either;
				{
					var $e2 : enum = (e);
					switch( $e2.index ) {
					case 0:
					var v : * = $e2.params[0];
					$r = stx.Either.Left(f1(v));
					break;
					case 1:
					var v1 : * = $e2.params[0];
					$r = stx.Either.Right(f2(v1));
					break;
					}
				}
				return $r;
			}();
		}
		
		static public function mapR(e : stx.Either,f : Function) : stx.Either {
			return function() : stx.Either {
				var $r : stx.Either;
				{
					var $e2 : enum = (e);
					switch( $e2.index ) {
					case 0:
					var v : * = $e2.params[0];
					$r = stx.Either.Left(v);
					break;
					case 1:
					var v1 : * = $e2.params[0];
					$r = stx.Either.Right(f(v1));
					break;
					}
				}
				return $r;
			}();
		}
		
		static public function flatMap(e : stx.Either,f1 : Function,f2 : Function) : stx.Either {
			return function() : stx.Either {
				var $r : stx.Either;
				{
					var $e2 : enum = (e);
					switch( $e2.index ) {
					case 0:
					var v : * = $e2.params[0];
					$r = f1(v);
					break;
					case 1:
					var v1 : * = $e2.params[0];
					$r = f2(v1);
					break;
					}
				}
				return $r;
			}();
		}
		
		static public function flatMapR(e : stx.Either,f : Function) : stx.Either {
			return stx.Eithers.flatMap(e,stx.Eithers.toLeft,f);
		}
		
		static public function composeLeft(e1 : stx.Either,e2 : stx.Either,ac : Function,bc : Function) : stx.Either {
			return function() : stx.Either {
				var $r : stx.Either;
				{
					var $e2 : enum = (e1);
					switch( $e2.index ) {
					case 0:
					var v1 : * = $e2.params[0];
					$r = function() : stx.Either {
						var $r3 : stx.Either;
						{
							var $e4 : enum = (e2);
							switch( $e4.index ) {
							case 0:
							var v2 : * = $e4.params[0];
							$r3 = stx.Either.Left(ac(v1,v2));
							break;
							case 1:
							var v21 : * = $e4.params[0];
							$r3 = stx.Either.Left(v1);
							break;
							}
						}
						return $r3;
					}();
					break;
					case 1:
					var v11 : * = $e2.params[0];
					$r = function() : stx.Either {
						var $r5 : stx.Either;
						{
							var $e6 : enum = (e2);
							switch( $e6.index ) {
							case 0:
							var v22 : * = $e6.params[0];
							$r5 = stx.Either.Left(v22);
							break;
							case 1:
							var v23 : * = $e6.params[0];
							$r5 = stx.Either.Right(bc(v11,v23));
							break;
							}
						}
						return $r5;
					}();
					break;
					}
				}
				return $r;
			}();
		}
		
		static public function composeRight(e1 : stx.Either,e2 : stx.Either,ac : Function,bc : Function) : stx.Either {
			return function() : stx.Either {
				var $r : stx.Either;
				{
					var $e2 : enum = (e1);
					switch( $e2.index ) {
					case 0:
					var v1 : * = $e2.params[0];
					$r = function() : stx.Either {
						var $r3 : stx.Either;
						{
							var $e4 : enum = (e2);
							switch( $e4.index ) {
							case 0:
							var v2 : * = $e4.params[0];
							$r3 = stx.Either.Left(ac(v1,v2));
							break;
							case 1:
							var v21 : * = $e4.params[0];
							$r3 = stx.Either.Right(v21);
							break;
							}
						}
						return $r3;
					}();
					break;
					case 1:
					var v11 : * = $e2.params[0];
					$r = function() : stx.Either {
						var $r5 : stx.Either;
						{
							var $e6 : enum = (e2);
							switch( $e6.index ) {
							case 0:
							var v22 : * = $e6.params[0];
							$r5 = stx.Either.Right(v11);
							break;
							case 1:
							var v23 : * = $e6.params[0];
							$r5 = stx.Either.Right(bc(v11,v23));
							break;
							}
						}
						return $r5;
					}();
					break;
					}
				}
				return $r;
			}();
		}
		
	}
}
