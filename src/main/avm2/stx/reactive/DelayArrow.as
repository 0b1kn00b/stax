package stx.reactive {
	import haxe.Timer;
	import stx.reactive.Arrow;
	import stx.reactive.Viaz;
	import flash.Boot;
	public class DelayArrow implements stx.reactive.Arrow{
		public function DelayArrow(a : stx.reactive.Arrow = null,delay : int = 0) : void { if( !flash.Boot.skip_constructor ) {
			this.a = a;
			this.t = delay;
		}}
		
		public function withInput(_tmp_i : * = null,_tmp_cont : Function) : void {
			var i : * = _tmp_i, cont : Function = _tmp_cont;
			var _g : stx.reactive.DelayArrow = this;
			var f : Function = function() : void {
				stx.reactive.Viaz.runCPS(_g.a,i,cont);
			}
			haxe.Timer.delay(f,this.t);
		}
		
		protected var t : int;
		protected var a : stx.reactive.Arrow;
		static public function delay(a : stx.reactive.Arrow,delay : int) : stx.reactive.Arrow {
			return new stx.reactive.DelayArrow(a,delay);
		}
		
	}
}
