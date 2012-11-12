package stx {
	public class Dynamics {
		static public function withEffect(t : *,f : Function) : * {
			f(t);
			return t;
		}
		
		static public function withEffectP(a : *,f : Function) : * {
			f(a);
			return a;
		}
		
		static public function into(a : *,f : Function) : * {
			return f(a);
		}
		
		static public function memoize(t : Function) : Function {
			var evaled : Boolean = false;
			var result : * = null;
			return function() : * {
				if(!evaled) {
					evaled = true;
					result = t();
				}
				return result;
			}
		}
		
		static public function toThunk(t : *) : Function {
			return function() : * {
				return t;
			}
		}
		
		static public function toConstantFunction(t : *) : Function {
			return function(s : *) : * {
				return t;
			}
		}
		
		static public function apply(v : *,fn : Function) : void {
			fn(v);
		}
		
		static public function then(a : *,b : *) : * {
			return b;
		}
		
	}
}
