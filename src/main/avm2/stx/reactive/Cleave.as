package stx.reactive {
	import stx.Tuples;
	import stx.reactive.Arrow;
	import flash.Boot;
	public class Cleave implements stx.reactive.Arrow{
		public function Cleave(a : stx.reactive.Arrow = null) : void { if( !flash.Boot.skip_constructor ) {
			this.a = a;
		}}
		
		public function withInput(_tmp_i : * = null,_tmp_cont : Function) : void {
			var i : * = _tmp_i, cont : Function = _tmp_cont;
			this.a.withInput(i,function(o : *) : void {
				cont(stx.Tuples.t2(o,o));
			});
		}
		
		protected var a : stx.reactive.Arrow;
		static public function cleave(a : stx.reactive.Arrow) : stx.reactive.Arrow {
			return new stx.reactive.Cleave(a);
		}
		
	}
}
