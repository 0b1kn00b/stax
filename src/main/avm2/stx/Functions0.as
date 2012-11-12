package stx {
	import stx.Dynamics;
	public class Functions0 {
		static public function enclose(f : Function) : Function {
			return function() : void {
				f();
			}
		}
		
		static public function swallow(f : Function) : Function {
			return function() : void {
				try {
					f();
				}
				catch( e : * ){
				}
			}
		}
		
		static public function thenDo(f1 : Function,f2 : Function) : Function {
			return function() : void {
				f1();
				f2();
			}
		}
		
		static public function returning(f : Function,thunk : Function) : Function {
			return function() : * {
				f();
				return thunk();
			}
		}
		
		static public function returningC(f : Function,value : *) : Function {
			return stx.Functions0.returning(f,stx.Dynamics.toThunk(value));
		}
		
		static public function promote(f : Function) : Function {
			return function(a : *) : * {
				return f();
			}
		}
		
		static public function promoteEffect(f : Function) : Function {
			return function(a : *) : void {
				f();
			}
		}
		
		static public function stage(f : Function,before : Function,after : Function) : * {
			var state : * = before();
			var result : * = f();
			after(state);
			return result;
		}
		
		static public function toEffect(f : Function) : Function {
			return function() : void {
				f();
			}
		}
		
		static public function map(f : Function,f1 : Function) : Function {
			return function() : * {
				return f1(f());
			}
		}
		
		static public function equals(a : Function,b : Function) : Boolean {
			return Reflect.compareMethods(a,b);
		}
		
	}
}
