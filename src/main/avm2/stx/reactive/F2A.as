package stx.reactive {
	import stx.Functions2;
	import stx.reactive.F1A;
	import stx.reactive.Viaz;
	import stx.Tuple2;
	import stx.Entuple;
	import stx.reactive.Arrow;
	public class F2A {
		static public function lift(f : Function) : stx.reactive.Arrow {
			return stx.reactive.F1A.lift((stx.Functions2.curry(stx.Functions2.flip(stx.Tuple2.into)))(f));
		}
		
		static public function run(arr : stx.reactive.Arrow,a : *,b : *) : void {
			stx.reactive.Viaz.run(arr,stx.Entuple.entuple(a,b));
		}
		
	}
}
