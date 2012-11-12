package stx {
	import stx.plus.Equal;
	public class Predicates {
		static public function isNull() : Function {
			return function(value : *) : Boolean {
				return value == null;
			}
		}
		
		static public function isNotNull() : Function {
			return function(value : *) : Boolean {
				return value != null;
			}
		}
		
		static public function isGreaterThan(ref : Number) : Function {
			return function(value : Number) : Boolean {
				return value > ref;
			}
		}
		
		static public function isLessThan(ref : Number) : Function {
			return function(value : Number) : Boolean {
				return value < ref;
			}
		}
		
		static public function isGreaterThanInt(ref : int) : Function {
			return function(value : int) : Boolean {
				return value > ref;
			}
		}
		
		static public function isLessThanInt(ref : int) : Function {
			return function(value : int) : Boolean {
				return value < ref;
			}
		}
		
		static public function isEqualTo(ref : *,equal : Function = null) : Function {
			if(equal == null) equal = stx.plus.Equal.getEqualFor(ref);
			return function(value : *) : Boolean {
				return equal(ref,value);
			}
		}
		
		static public function and(p1 : Function,p2 : Function) : Function {
			return function(value : *) : Boolean {
				return p1(value) && p2(value);
			}
		}
		
		static public function andAll(p1 : Function,ps : *) : Function {
			return function(value : *) : Boolean {
				var result : Boolean = p1(value);
				{ var $it : * = ps.iterator();
				while( $it.hasNext() ) { var p : Function = $it.next();
				{
					if(!result) break;
					result = result && p(value);
				}
				}}
				return result;
			}
		}
		
		static public function or(p1 : Function,p2 : Function) : Function {
			return function(value : *) : Boolean {
				return p1(value) || p2(value);
			}
		}
		
		static public function not(p1 : Function) : Function {
			return function(value : *) : Boolean {
				return !p1(value);
			}
		}
		
		static public function orAny(p1 : Function,ps : *) : Function {
			return function(value : *) : Boolean {
				var result : Boolean = p1(value);
				{ var $it : * = ps.iterator();
				while( $it.hasNext() ) { var p : Function = $it.next();
				{
					if(result) break;
					result = result || p(value);
				}
				}}
				return result;
			}
		}
		
		static public function negate(p : Function) : Function {
			return function(value : *) : Boolean {
				return !p(value);
			}
		}
		
	}
}
