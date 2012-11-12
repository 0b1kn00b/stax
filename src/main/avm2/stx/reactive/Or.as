package stx.reactive {
	import stx.Either;
	import stx.reactive.Arrow;
	import flash.Boot;
	public class Or implements stx.reactive.Arrow{
		public function Or(l : stx.reactive.Arrow = null,r : stx.reactive.Arrow = null) : void { if( !flash.Boot.skip_constructor ) {
			this.a = l;
			this.b = r;
		}}
		
		public function withInput(_tmp_i : * = null,_tmp_cont : Function) : void {
			var i : stx.Either = _tmp_i, cont : Function = _tmp_cont;
			{
				var $e : enum = (i);
				switch( $e.index ) {
				case 0:
				var v : * = $e.params[0];
				this.a.withInput(v,cont);
				break;
				case 1:
				var v1 : * = $e.params[0];
				this.b.withInput(v1,cont);
				break;
				}
			}
		}
		
		protected var b : stx.reactive.Arrow;
		protected var a : stx.reactive.Arrow;
		static public function or(or_ : stx.reactive.Arrow,_or : stx.reactive.Arrow) : stx.reactive.Arrow {
			return new stx.reactive.Or(or_,_or);
		}
		
	}
}
