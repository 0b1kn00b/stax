package stx.test {
	import stx.ds.Collection;
	import stx.Either;
	import stx.plus.Equal;
	import stx.Strings;
	public class Must {
		static public function equal(expected : *,equal : Function = null) : Function {
			if(equal == null) equal = stx.plus.Equal.getEqualFor(expected);
			return function(value : *) : stx.Either {
				var result : * = { assertion : "x == " + Std.string(value), negation : "x != " + Std.string(value)}
				return ((!equal(value,expected))?stx.Either.Left(result):stx.Either.Right(result));
			}
		}
		
		static public function beTrue() : Function {
			return function(value : Boolean) : stx.Either {
				var result : * = { assertion : "x == true", negation : "x == false"}
				return ((!value)?stx.Either.Left(result):stx.Either.Right(result));
			}
		}
		
		static public function beFalse() : Function {
			return function(value : Boolean) : stx.Either {
				var result : * = { assertion : "x == false", negation : "x == true"}
				return ((value)?stx.Either.Left(result):stx.Either.Right(result));
			}
		}
		
		static public function beGreaterThan(ref : Number) : Function {
			return function(value : Number) : stx.Either {
				var result : * = { assertion : "x > " + ref, negation : "x <= " + ref}
				return ((value <= ref)?stx.Either.Left(result):stx.Either.Right(result));
			}
		}
		
		static public function beLessThan(ref : Number) : Function {
			return function(value : Number) : stx.Either {
				var result : * = { assertion : "x < " + ref, negation : "x >= " + ref}
				return ((value >= ref)?stx.Either.Left(result):stx.Either.Right(result));
			}
		}
		
		static public function beGreaterThanInt(ref : int) : Function {
			return function(value : int) : stx.Either {
				var result : * = { assertion : "x > " + ref, negation : "x <= " + ref}
				return ((value <= ref)?stx.Either.Left(result):stx.Either.Right(result));
			}
		}
		
		static public function beLessThanInt(ref : int) : Function {
			return function(value : int) : stx.Either {
				var result : * = { assertion : "x < " + ref, negation : "x >= " + ref}
				return ((value >= ref)?stx.Either.Left(result):stx.Either.Right(result));
			}
		}
		
		static public function haveLength(length : int) : Function {
			return function(value : *) : stx.Either {
				var len : int = 0;
				{ var $it : * = value.iterator();
				while( $it.hasNext() ) { var e : * = $it.next();
				++len;
				}}
				var result : * = { assertion : "x.length == " + length, negation : "x.length != " + length}
				return ((len != length)?stx.Either.Left(result):stx.Either.Right(result));
			}
		}
		
		static public function haveClass(c : Class) : Function {
			return function(value : *) : stx.Either {
				var result : * = { assertion : "x.isInstanceOf(" + Type.getClassName(c) + ")", negation : "!x.isInstanceOf(" + Type.getClassName(c) + ")"}
				return ((!Std._is(value,c))?stx.Either.Left(result):stx.Either.Right(result));
			}
		}
		
		static public function containElement(element : *) : Function {
			return function(c : stx.ds.Collection) : stx.Either {
				var result : * = { assertion : "x.contains(" + Std.string(element) + ")", negation : "!x.contains(" + Std.string(element) + ")"}
				return ((!c.contains(element))?stx.Either.Left(result):stx.Either.Right(result));
			}
		}
		
		static public function containString(sub : String) : Function {
			return function(value : String) : stx.Either {
				var result : * = { assertion : "x.contains(\"" + sub + "\")", negation : "!x.contains(\"" + sub + "\")"}
				return ((!stx.Strings.contains(value,sub))?stx.Either.Left(result):stx.Either.Right(result));
			}
		}
		
		static public function startWithString(s : String) : Function {
			return function(value : String) : stx.Either {
				var result : * = { assertion : "x.startsWith(\"" + s + "\")", negation : "!x.startsWith(\"" + s + "\")"}
				return ((!stx.Strings.startsWith(value,s))?stx.Either.Left(result):stx.Either.Right(result));
			}
		}
		
		static public function endWithString(s : String) : Function {
			return function(value : String) : stx.Either {
				var result : * = { assertion : "x.endsWith(\"" + s + "\")", negation : "!x.endsWith(\"" + s + "\")"}
				return ((!stx.Strings.endsWith(value,s))?stx.Either.Left(result):stx.Either.Right(result));
			}
		}
		
		static public function beNull() : Function {
			return function(value : *) : stx.Either {
				var result : * = { assertion : "x == null", negation : "x != null"}
				return ((value != null)?stx.Either.Left(result):stx.Either.Right(result));
			}
		}
		
		static public function beNonNull() : Function {
			return function(value : *) : stx.Either {
				var result : * = { assertion : "x != null", negation : "x == null"}
				return ((value == null)?stx.Either.Left(result):stx.Either.Right(result));
			}
		}
		
	}
}
