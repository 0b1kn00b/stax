package stx.reactive {
	import stx.reactive.Arrow;
	import flash.Boot;
	public class FunctionArrow implements stx.reactive.Arrow{
		public function FunctionArrow(m : Function = null) : void { if( !flash.Boot.skip_constructor ) {
			this.f = m;
		}}
		
		public function withInput(_tmp_i : * = null,_tmp_cont : Function) : void {
			var i : * = _tmp_i, cont : Function = _tmp_cont;
			cont((this.f)(i));
		}
		
		protected var f : Function;
	}
}
