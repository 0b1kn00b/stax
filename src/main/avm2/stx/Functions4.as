package stx {
	public class Functions4 {
		static public function swallow(f : Function) : Function {
			return stx.Functions4.toEffect(stx.Functions4.swallowWith(f,null));
		}
		
		static public function swallowWith(f : Function,def : *) : Function {
			return function(a : *,b : *,c : *,d : *) : * {
				try {
					return f(a,b,c,d);
				}
				catch( e : * ){
				}
				return def;
			}
		}
		
		static public function thenDo(f1 : Function,f2 : Function) : Function {
			return function(p1 : *,p2 : *,p3 : *,p4 : *) : void {
				f1(p1,p2,p3,p4);
				f2(p1,p2,p3,p4);
			}
		}
		
		static public function returning(f : Function,thunk : Function) : Function {
			return function(p1 : *,p2 : *,p3 : *,p4 : *) : * {
				f(p1,p2,p3,p4);
				return thunk();
			}
		}
		
		static public function returningC(f : Function,value : *) : Function {
			return stx.Functions4.returning(f,value.toThunk());
		}
		
		static public function curry(f : Function) : Function {
			return function(p1 : *) : Function {
				return function(p2 : *) : Function {
					return function(p3 : *) : Function {
						return function(p4 : *) : * {
							return f(p1,p2,p3,p4);
						}
					}
				}
			}
		}
		
		static public function uncurry(f : Function) : Function {
			return function(p1 : *,p2 : *,p3 : *,p4 : *) : * {
				return (((f(p1))(p2))(p3))(p4);
			}
		}
		
		static public function lazy(f : Function,p1 : *,p2 : *,p3 : *,p4 : *) : Function {
			var r : * = null;
			return function() : * {
				return ((r == null)?function() : * {
					var $r : *;
					r = f(p1,p2,p3,p4);
					$r = r;
					return $r;
				}():r);
			}
		}
		
		static public function toEffect(f : Function) : Function {
			return function(p1 : *,p2 : *,p3 : *,p4 : *) : void {
				f(p1,p2,p3,p4);
			}
		}
		
		static public function equals(a : Function,b : Function) : Boolean {
			return Reflect.compareMethods(a,b);
		}
		
	}
}
