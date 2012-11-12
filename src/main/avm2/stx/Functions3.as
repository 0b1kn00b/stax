package stx {
	public class Functions3 {
		static public function p1(f : Function,p1 : *) : Function {
			return function(p2 : *,p3 : *) : * {
				return f(p1,p2,p3);
			}
		}
		
		static public function p2(f : Function,p2 : *) : Function {
			return function(p1 : *,p3 : *) : * {
				return f(p1,p2,p3);
			}
		}
		
		static public function p3(f : Function,p3 : *) : Function {
			return function(p1 : *,p2 : *) : * {
				return f(p1,p2,p3);
			}
		}
		
		static public function swallow(f : Function) : Function {
			return stx.Functions3.toEffect(stx.Functions3.swallowWith(f,null));
		}
		
		static public function swallowWith(f : Function,d : *) : Function {
			return function(a : *,b : *,c : *) : * {
				try {
					return f(a,b,c);
				}
				catch( e : * ){
				}
				return d;
			}
		}
		
		static public function thenDo(f1 : Function,f2 : Function) : Function {
			return function(p1 : *,p2 : *,p3 : *) : void {
				f1(p1,p2,p3);
				f2(p1,p2,p3);
			}
		}
		
		static public function returning(f : Function,thunk : Function) : Function {
			return function(p1 : *,p2 : *,p3 : *) : * {
				f(p1,p2,p3);
				return thunk();
			}
		}
		
		static public function returningC(f : Function,value : *) : Function {
			return stx.Functions3.returning(f,value.toThunk());
		}
		
		static public function curry(f : Function) : Function {
			return function(p1 : *) : Function {
				return function(p2 : *) : Function {
					return function(p3 : *) : * {
						return f(p1,p2,p3);
					}
				}
			}
		}
		
		static public function uncurry(f : Function) : Function {
			return function(p1 : *,p2 : *,p3 : *) : * {
				return ((f(p1))(p2))(p3);
			}
		}
		
		static public function lazy(f : Function,p1 : *,p2 : *,p3 : *) : Function {
			var r : * = null;
			return function() : * {
				return ((r == null)?function() : * {
					var $r : *;
					r = f(p1,p2,p3);
					$r = r;
					return $r;
				}():r);
			}
		}
		
		static public function toEffect(f : Function) : Function {
			return function(p1 : *,p2 : *,p3 : *) : void {
				f(p1,p2,p3);
			}
		}
		
		static public function equals(a : Function,b : Function) : Boolean {
			return Reflect.compareMethods(a,b);
		}
		
	}
}
