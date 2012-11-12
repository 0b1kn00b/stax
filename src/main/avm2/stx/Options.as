package stx {
	import stx.Eithers;
	import stx.Option;
	import stx.Tuple2;
	import stx.Dynamics;
	import stx.Tuples;
	import stx.Either;
	public class Options {
		static public function toOption(t : *) : stx.Option {
			return ((t == null)?stx.Option.None:stx.Option.Some(t));
		}
		
		static public function toArray(o : stx.Option) : Array {
			return function() : Array {
				var $r : Array;
				{
					var $e2 : enum = (o);
					switch( $e2.index ) {
					case 0:
					$r = [];
					break;
					case 1:
					var v : * = $e2.params[0];
					$r = [v];
					break;
					}
				}
				return $r;
			}();
		}
		
		static public function map(o : stx.Option,f : Function) : stx.Option {
			return function() : stx.Option {
				var $r : stx.Option;
				{
					var $e2 : enum = (o);
					switch( $e2.index ) {
					case 0:
					$r = stx.Option.None;
					break;
					case 1:
					var v : * = $e2.params[0];
					$r = stx.Option.Some(f(v));
					break;
					}
				}
				return $r;
			}();
		}
		
		static public function then(o1 : stx.Option,o2 : stx.Option) : stx.Option {
			return o2;
		}
		
		static public function foreach(o : stx.Option,f : Function) : stx.Option {
			return function() : stx.Option {
				var $r : stx.Option;
				{
					var $e2 : enum = (o);
					switch( $e2.index ) {
					case 0:
					$r = o;
					break;
					case 1:
					var v : * = $e2.params[0];
					$r = function() : stx.Option {
						var $r3 : stx.Option;
						f(v);
						$r3 = o;
						return $r3;
					}();
					break;
					}
				}
				return $r;
			}();
		}
		
		static public function filter(o : stx.Option,f : Function) : stx.Option {
			return function() : stx.Option {
				var $r : stx.Option;
				{
					var $e2 : enum = (o);
					switch( $e2.index ) {
					case 0:
					$r = stx.Option.None;
					break;
					case 1:
					var v : * = $e2.params[0];
					$r = ((f(v))?o:stx.Option.None);
					break;
					}
				}
				return $r;
			}();
		}
		
		static public function flatMap(o : stx.Option,f : Function) : stx.Option {
			return stx.Options.flatten(stx.Options.map(o,f));
		}
		
		static public function flatten(o1 : stx.Option) : stx.Option {
			return function() : stx.Option {
				var $r : stx.Option;
				{
					var $e2 : enum = (o1);
					switch( $e2.index ) {
					case 0:
					$r = stx.Option.None;
					break;
					case 1:
					var o2 : stx.Option = $e2.params[0];
					$r = o2;
					break;
					}
				}
				return $r;
			}();
		}
		
		static public function zip(o1 : stx.Option,o2 : stx.Option) : stx.Option {
			return function() : stx.Option {
				var $r : stx.Option;
				{
					var $e2 : enum = (o1);
					switch( $e2.index ) {
					case 0:
					$r = stx.Option.None;
					break;
					case 1:
					var v1 : * = $e2.params[0];
					$r = stx.Options.map(o2,function() : Function {
						var $r3 : Function;
						var _1 : * = v1;
						$r3 = function(_2 : *) : stx.Tuple2 {
							return stx.Tuples.t2(_1,_2);
						}
						return $r3;
					}());
					break;
					}
				}
				return $r;
			}();
		}
		
		static public function zipWith(o1 : stx.Option,o2 : stx.Option,f : Function) : stx.Option {
			return function() : stx.Option {
				var $r : stx.Option;
				{
					var $e2 : enum = (o1);
					switch( $e2.index ) {
					case 0:
					$r = stx.Option.None;
					break;
					case 1:
					var v1 : * = $e2.params[0];
					$r = function() : stx.Option {
						var $r3 : stx.Option;
						{
							var $e4 : enum = (o2);
							switch( $e4.index ) {
							case 0:
							$r3 = stx.Option.None;
							break;
							case 1:
							var v2 : * = $e4.params[0];
							$r3 = stx.Option.Some(f(v1,v2));
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
		}
		
		static public function get(o : stx.Option) : * {
			return function() : * {
				var $r : *;
				{
					var $e2 : enum = (o);
					switch( $e2.index ) {
					case 0:
					$r = function() : * {
						var $r3 : *;
						Prelude.error("Error: Option is empty",{ fileName : "Options.hx", lineNumber : 104, className : "stx.Options", methodName : "get"});
						$r3 = null;
						return $r3;
					}();
					break;
					case 1:
					var v : * = $e2.params[0];
					$r = v;
					break;
					}
				}
				return $r;
			}();
		}
		
		static public function orElse(o1 : stx.Option,thunk : Function) : stx.Option {
			return function() : stx.Option {
				var $r : stx.Option;
				{
					var $e2 : enum = (o1);
					switch( $e2.index ) {
					case 0:
					$r = thunk();
					break;
					case 1:
					var v : * = $e2.params[0];
					$r = o1;
					break;
					}
				}
				return $r;
			}();
		}
		
		static public function orElseC(o1 : stx.Option,o2 : stx.Option) : stx.Option {
			return stx.Options.orElse(o1,stx.Dynamics.toThunk(o2));
		}
		
		static public function orEither(o1 : stx.Option,thunk : Function) : stx.Either {
			return function() : stx.Either {
				var $r : stx.Either;
				{
					var $e2 : enum = (o1);
					switch( $e2.index ) {
					case 0:
					$r = stx.Eithers.toLeft(thunk());
					break;
					case 1:
					var v : * = $e2.params[0];
					$r = stx.Eithers.toRight(v);
					break;
					}
				}
				return $r;
			}();
		}
		
		static public function orEitherC(o1 : stx.Option,c : *) : stx.Either {
			return stx.Options.orEither(o1,stx.Dynamics.toThunk(c));
		}
		
		static public function getOrElse(o : stx.Option,thunk : Function) : * {
			return function() : * {
				var $r : *;
				{
					var $e2 : enum = (o);
					switch( $e2.index ) {
					case 0:
					$r = thunk();
					break;
					case 1:
					var v : * = $e2.params[0];
					$r = v;
					break;
					}
				}
				return $r;
			}();
		}
		
		static public function getOrElseC(o : stx.Option,c : *) : * {
			return stx.Options.getOrElse(o,stx.Dynamics.toThunk(c));
		}
		
		static public function isEmpty(o : stx.Option) : Boolean {
			return function() : Boolean {
				var $r : Boolean;
				{
					var $e2 : enum = (o);
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
		
		static public function isDefined(o : stx.Option) : Boolean {
			return function() : Boolean {
				var $r : Boolean;
				{
					var $e2 : enum = (o);
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
		
	}
}
