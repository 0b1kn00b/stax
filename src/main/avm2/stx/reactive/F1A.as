package stx.reactive {
	import stx.reactive.Then;
	import stx.reactive.FunctionArrow;
	import stx.reactive.Arrow;
	public class F1A {
		static public function lift(f : Function) : stx.reactive.Arrow {
			return new stx.reactive.FunctionArrow(f);
		}
		
		static public function thenA(f : Function,a : stx.reactive.Arrow) : stx.reactive.Arrow {
			return stx.reactive.Then.then(stx.reactive.F1A.lift(f),a);
		}
		
	}
}
