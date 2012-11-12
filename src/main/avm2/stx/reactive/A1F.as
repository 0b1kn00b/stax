package stx.reactive {
	import stx.reactive.Then;
	import stx.reactive.F1A;
	import stx.reactive.Arrow;
	public class A1F {
		static public function thenF(a : stx.reactive.Arrow,f : Function) : stx.reactive.Arrow {
			var a2 : stx.reactive.Arrow = stx.reactive.F1A.lift(f);
			return stx.reactive.Then.then(a,a2);
		}
		
	}
}
