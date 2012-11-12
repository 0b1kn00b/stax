package stx {
	public class Functions2 {
		static public function p1(f : Function,p1 : *) : Function {
			return (stx.Functions2.curry(f))(p1);
		}
		
		static public function p2(f : Function,p2 : *) : Function {
			return (stx.Functions2.curry(stx.Functions2.flip(f)))(p2);
		}
		
		static public function swallow(f : Function) : Function {
			return stx.Functions2.toEffect(stx.Functions2.swallowWith(f,null));
		}
		
		static public function swallowWith(f : Function,d : *) : Function {
			return function(p1 : *,p2 : *) : * {
				try {
					return f(p1,p2);
				}
				catch( e : * ){
				}
				return d;
			}
		}
		
		static public function thenDo(f1 : Function,f2 : Function) : Function {
			return function(p1 : *,p2 : *) : void {
				f1(p1,p2);
				f2(p1,p2);
			}
		}
		
		static public function returning(f : Function,thunk : Function) : Function {
			return function(p1 : *,p2 : *) : * {
				f(p1,p2);
				return thunk();
			}
		}
		
		static public function andThen(f1 : Function,f2 : Function) : Function {
			return function(u : *,v : *) : * {
				return f2(f1(u,v));
			}
		}
		
		static public function returningC(f : Function,value : *) : Function {
			return stx.Functions2.returning(f,value.toThunk());
		}
		
		static public function flip(f : Function) : Function {
			return function(p2 : *,p1 : *) : * {
				return f(p1,p2);
			}
		}
		
		static public function curry(f : Function) : Function {
			return function(p1 : *) : Function {
				return function(p2 : *) : * {
					return f(p1,p2);
				}
			}
		}
		
		static public function uncurry(f : Function) : Function {
			return function(p1 : *,p2 : *) : * {
				return (f(p1))(p2);
			}
		}
		
		static public function lazy(f : Function,p1 : *,p2 : *) : Function {
			var r : * = null;
			return function() : * {
				return ((r == null)?function() : * {
					var $r : *;
					r = f(p1,p2);
					$r = r;
					return $r;
				}():r);
			}
		}
		
		static public function toEffect(f : Function) : Function {
			return function(p1 : *,p2 : *) : void {
				f(p1,p2);
			}
		}
		
		static public function equals(a : Function,b : Function) : Boolean {
			return Reflect.compareMethods(a,b);
		}
		
	}
}
