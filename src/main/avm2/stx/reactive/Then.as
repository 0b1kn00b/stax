package stx.reactive {
	import stx.reactive.Arrow;
	import stx.reactive.Viaz;
	import stx.reactive.Split;
	import stx.test.Assert;
	import flash.Boot;
	public class Then implements stx.reactive.Arrow{
		public function Then(a : stx.reactive.Arrow = null,b : stx.reactive.Arrow = null) : void { if( !flash.Boot.skip_constructor ) {
			this.a = a;
			this.b = b;
		}}
		
		public function withInput(_tmp_i : * = null,_tmp_cont : Function) : void {
			var i : * = _tmp_i, cont : Function = _tmp_cont;
			var _g : stx.reactive.Then = this;
			stx.test.Assert.notNull(cont,null,{ fileName : "Arrows.hx", lineNumber : 99, className : "stx.reactive.Then", methodName : "withInput"});
			var m : Function = function(reta : *) : void {
				_g.b.withInput(reta,cont);
			}
			this.a.withInput(i,m);
		}
		
		protected var b : stx.reactive.Arrow;
		protected var a : stx.reactive.Arrow;
		static public function then(before : stx.reactive.Arrow,after : stx.reactive.Arrow) : stx.reactive.Arrow {
			return new stx.reactive.Then(before,after);
		}
		
		static public function join(joinl : stx.reactive.Arrow,joinr : stx.reactive.Arrow) : stx.reactive.Arrow {
			return new stx.reactive.Then(joinl,stx.reactive.Split.split(stx.reactive.Viaz.identity(),joinr));
		}
		
		static public function bind(bindl : stx.reactive.Arrow,bindr : stx.reactive.Arrow) : stx.reactive.Arrow {
			return new stx.reactive.Then(stx.reactive.Split.split(stx.reactive.Viaz.identity(),bindl),bindr);
		}
		
	}
}
