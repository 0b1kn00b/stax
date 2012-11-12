package stx.reactive {
	import stx.Either;
	import stx.Tuples;
	import stx.reactive.ArrowApply;
	import stx.reactive.Arrow;
	import flash.Boot;
	public class LeftChoice implements stx.reactive.Arrow{
		public function LeftChoice(a : stx.reactive.Arrow = null) : void { if( !flash.Boot.skip_constructor ) {
			this.a = a;
		}}
		
		public function withInput(_tmp_i : * = null,_tmp_cont : Function) : void {
			var i : stx.Either = _tmp_i, cont : Function = _tmp_cont;
			{
				var $e : enum = (i);
				switch( $e.index ) {
				case 0:
				var v : * = $e.params[0];
				new stx.reactive.ArrowApply().withInput(stx.Tuples.t2(this.a,v),function(x : *) : void {
					cont(stx.Either.Left(x));
				});
				break;
				case 1:
				var v1 : * = $e.params[0];
				cont(stx.Either.Right(v1));
				break;
				}
			}
		}
		
		protected var a : stx.reactive.Arrow;
		static public function left(arr : stx.reactive.Arrow) : stx.reactive.Arrow {
			return new stx.reactive.LeftChoice(arr);
		}
		
	}
}
