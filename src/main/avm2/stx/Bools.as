package stx {
	import stx.Option;
	public class Bools {
		static public function toInt(v : Boolean) : Number {
			return ((v)?1:0);
		}
		
		static public function ifTrue(v : Boolean,f : Function) : stx.Option {
			return ((v)?stx.Option.Some(f()):stx.Option.None);
		}
		
		static public function ifFalse(v : Boolean,f : Function) : stx.Option {
			return ((!v)?stx.Option.Some(f()):stx.Option.None);
		}
		
		static public function ifElse(v : Boolean,f1 : Function,f2 : Function) : * {
			return ((v)?f1():f2());
		}
		
		static public function compare(v1 : Boolean,v2 : Boolean) : int {
			return ((!v1 && v2)?-1:((v1 && !v2)?1:0));
		}
		
		static public function equals(v1 : Boolean,v2 : Boolean) : Boolean {
			return v1 == v2;
		}
		
		static public function and(v1 : Boolean,v2 : Boolean) : Boolean {
			return v1 && v2;
		}
		
		static public function or(v1 : Boolean,v2 : Boolean) : Boolean {
			return v1 || v2;
		}
		
		static public function not(v : Boolean) : Boolean {
			return !v;
		}
		
	}
}
