package stx.reactive {
	import stx.reactive.Arrow;
	import flash.Boot;
	public class Stack {
		public function Stack() : void { if( !flash.Boot.skip_constructor ) {
			this.data = [];
		}}
		
		public function next(x : *,f : stx.reactive.Arrow,g : stx.reactive.Arrow) : void {
		}
		
		protected var data : Array;
	}
}
