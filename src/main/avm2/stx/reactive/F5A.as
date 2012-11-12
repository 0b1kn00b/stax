package stx.reactive {
	import stx.Functions2;
	import stx.reactive.F1A;
	import stx.Tuple2;
	import stx.reactive.Viaz;
	import stx.Entuple;
	import stx.Tuple3;
	import stx.reactive.Arrow;
	import stx.Tuple5;
	public class F5A {
		static public function lift(f : Function) : stx.reactive.Arrow {
			return stx.reactive.F1A.lift((stx.Functions2.curry(stx.Functions2.flip(stx.Tuple5.into)))(f));
		}
		
		static public function run(arr : stx.reactive.Arrow,a : *,b : *,c : *,d : *,e : *) : void {
			stx.reactive.Viaz.run(arr,stx.Tuple3.entuple(stx.Tuple2.entuple(stx.Entuple.entuple(a,b),c),d).entuple(e));
		}
		
	}
}
