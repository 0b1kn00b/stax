package stx.reactive {
	import stx.Functions1;
	import stx.Option;
	import stx.reactive.Viaz;
	import stx.Entuple;
	import stx.reactive.Arrow;
	import flash.Boot;
	public class OptionArrow implements stx.reactive.Arrow{
		public function OptionArrow(a : stx.reactive.Arrow = null) : void { if( !flash.Boot.skip_constructor ) {
			this.a = a;
		}}
		
		public function withInput(_tmp_i : * = null,_tmp_cont : Function) : void {
			var i : stx.Option = _tmp_i, cont : Function = _tmp_cont;
			{
				var $e : enum = (i);
				switch( $e.index ) {
				case 1:
				var v : * = $e.params[0];
				stx.reactive.Viaz.apply().withInput(stx.Entuple.entuple(this.a,v),stx.Functions1.andThen(stx.Option.Some,cont));
				break;
				case 0:
				cont(stx.Option.None);
				break;
				}
			}
		}
		
		protected var a : stx.reactive.Arrow;
		static public function option(a : stx.reactive.Arrow) : stx.reactive.Arrow {
			return new stx.reactive.OptionArrow(a);
		}
		
	}
}
