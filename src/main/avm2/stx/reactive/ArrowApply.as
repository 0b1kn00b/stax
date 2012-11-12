package stx.reactive {
	import stx.reactive.Arrow;
	import stx.Tuple2;
	public class ArrowApply implements stx.reactive.Arrow{
		public function ArrowApply() : void {
		}
		
		public function withInput(_tmp_i : * = null,_tmp_cont : Function) : void {
			var i : stx.Tuple2 = _tmp_i, cont : Function = _tmp_cont;
			i._1.withInput(i._2,function(x : *) : void {
				cont(x);
			});
		}
		
	}
}
