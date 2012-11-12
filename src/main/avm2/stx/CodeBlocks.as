package stx {
	import stx.Either;
	public class CodeBlocks {
		static public function returningC(c : Function,val : *) : Function {
			return function() : * {
				c();
				return val;
			}
		}
		
		static public function catching(c : Function) : stx.Either {
			var o : stx.Either = null;
			try {
				o = stx.Either.Right(c());
			}
			catch( e : * ){
				o = stx.Either.Left(e);
			}
			return o;
		}
		
		static public function equals(a : Function,b : Function) : Boolean {
			return Reflect.compareMethods(a,b);
		}
		
	}
}
