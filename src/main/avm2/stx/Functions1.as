package stx {
	import stx.Dynamics;
	public class Functions1 {
		static public function swallow(f : Function) : Function {
			return stx.Functions1.toEffect(stx.Functions1.swallowWith(f,null));
		}
		
		static public function swallowWith(f : Function,d : *) : Function {
			return function(a : *) : * {
				try {
					return f(a);
				}
				catch( e : * ){
				}
				return d;
			}
		}
		
		static public function thenDo(f1 : Function,f2 : Function) : Function {
			return function(p1 : *) : void {
				f1(p1);
				f2(p1);
			}
		}
		
		static public function curry(f : Function) : Function {
			return function() : Function {
				return function(p1 : *) : * {
					return f(p1);
				}
			}
		}
		
		static public function returning(f : Function,thunk : Function) : Function {
			return function(p1 : *) : * {
				f(p1);
				return thunk();
			}
		}
		
		static public function returningC(f : Function,value : *) : Function {
			return stx.Functions1.returning(f,stx.Dynamics.toThunk(value));
		}
		
		static public function compose(f1 : Function,f2 : Function) : Function {
			return function(u : *) : * {
				return f1(f2(u));
			}
		}
		
		static public function andThen(f1 : Function,f2 : Function) : Function {
			return stx.Functions1.compose(f2,f1);
		}
		
		static public function lazy(f : Function,p1 : *) : Function {
			var r : * = null;
			return function() : * {
				return ((r == null)?function() : * {
					var $r : *;
					r = f(p1);
					$r = r;
					return $r;
				}():r);
			}
		}
		
		static public function toEffect(f : Function) : Function {
			return function(p1 : *) : void {
				f(p1);
			}
		}
		
		static public function equals(a : Function,b : Function) : Boolean {
			return Reflect.compareMethods(a,b);
		}
		
	}
}
