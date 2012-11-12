package stx.reactive {
	import stx.reactive.Then;
	import stx.reactive.F1A;
	import stx.reactive.Arrow;
	public class F1F {
		static public function thenF(f1 : Function,f2 : Function) : stx.reactive.Arrow {
			var a1 : stx.reactive.Arrow = stx.reactive.F1A.lift(f1);
			var a2 : stx.reactive.Arrow = stx.reactive.F1A.lift(f2);
			return stx.reactive.Then.then(a1,a2);
		}
		
	}
}
