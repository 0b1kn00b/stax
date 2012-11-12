package stx.reactive {
	import stx.reactive.Then;
	import stx.reactive.Arrow;
	import flash.Boot;
	public class Merge implements stx.reactive.Arrow{
		public function Merge(a : stx.reactive.Arrow = null,b : stx.reactive.Arrow = null) : void { if( !flash.Boot.skip_constructor ) {
			this.a = a;
			this.b = b;
		}}
		
		public function withInput(_tmp_i : * = null,_tmp_cont : Function) : void {
			var i : * = _tmp_i, cont : Function = _tmp_cont;
			stx.reactive.Then.then(this.a,this.b).withInput(i,cont);
			return;
		}
		
		protected var b : stx.reactive.Arrow;
		protected var a : stx.reactive.Arrow;
		static public function merge(a : stx.reactive.Arrow,b : stx.reactive.Arrow) : stx.reactive.Arrow {
			return new stx.reactive.Merge(a,b);
		}
		
	}
}
