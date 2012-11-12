package stx.reactive {
	import stx.reactive.F1A;
	import stx.reactive.Arrow;
	public class F0A {
		static public function lift(t : Function) : stx.reactive.Arrow {
			return stx.reactive.F1A.lift(function(v : *) : * {
				return t();
			});
		}
		
	}
}
