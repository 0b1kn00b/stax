package stx.reactive {
	import stx.reactive.Arrow;
	import stx.Future;
	public class FutureArrow implements stx.reactive.Arrow{
		public function FutureArrow() : void {
		}
		
		public function withInput(_tmp_i : * = null,_tmp_cont : Function) : void {
			var i : stx.Future = _tmp_i, cont : Function = _tmp_cont;
			i.foreach(cont);
		}
		
	}
}
