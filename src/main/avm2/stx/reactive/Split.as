package stx.reactive {
	import stx.reactive.Pair;
	import stx.Tuples;
	import stx.reactive.Arrow;
	import flash.Boot;
	public class Split implements stx.reactive.Arrow{
		public function Split(l : stx.reactive.Arrow = null,r : stx.reactive.Arrow = null) : void { if( !flash.Boot.skip_constructor ) {
			this.a = new stx.reactive.Pair(l,r);
		}}
		
		public function withInput(_tmp_i : * = null,_tmp_cont : Function) : void {
			var i : * = _tmp_i, cont : Function = _tmp_cont;
			this.a.withInput(stx.Tuples.t2(i,i),cont);
		}
		
		protected var a : stx.reactive.Pair;
		static public function split(split_ : stx.reactive.Arrow,_split : stx.reactive.Arrow) : stx.reactive.Arrow {
			return new stx.reactive.Split(split_,_split);
		}
		
	}
}
