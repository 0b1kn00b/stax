package stx.reactive {
	import stx.reactive.Arrow;
	import stx.reactive.Arrows;
	import stx.reactive.RepeatV;
	import flash.Boot;
	public class RepeatArrow implements stx.reactive.Arrow{
		public function RepeatArrow(a : stx.reactive.Arrow = null) : void { if( !flash.Boot.skip_constructor ) {
			this.a = a;
		}}
		
		public function withInput(_tmp_i : * = null,_tmp_cont : Function) : void {
			var i : * = _tmp_i, cont : Function = _tmp_cont;
			var thiz : stx.reactive.RepeatArrow = this;
			var withRes : Function = (function($this:RepeatArrow) : Function {
				var $r : Function;
				var withRes1 : Function = null;
				withRes1 = function(res : stx.reactive.RepeatV) : void {
					{
						var $e2 : enum = (res);
						switch( $e2.index ) {
						case 0:
						var rv : * = $e2.params[0];
						thiz.a.withInput(rv,stx.reactive.Arrows.trampoline(withRes1));
						break;
						case 1:
						var dv : * = $e2.params[0];
						cont(dv);
						break;
						}
					}
				}
				$r = withRes1;
				return $r;
			}(this));
			this.a.withInput(i,withRes);
		}
		
		protected var a : stx.reactive.Arrow;
		static public function repeat(a : stx.reactive.Arrow) : stx.reactive.Arrow {
			return new stx.reactive.RepeatArrow(a);
		}
		
	}
}
