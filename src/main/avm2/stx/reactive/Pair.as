package stx.reactive {
	import stx.test.Assert;
	import stx.Option;
	import stx.reactive.Viaz;
	import stx.Options;
	import stx.Tuple2;
	import stx.Tuples;
	import stx.reactive.Arrow;
	import flash.Boot;
	public class Pair implements stx.reactive.Arrow{
		public function Pair(l : stx.reactive.Arrow = null,r : stx.reactive.Arrow = null) : void { if( !flash.Boot.skip_constructor ) {
			this.l = l;
			this.r = r;
		}}
		
		public function withInput(_tmp_i : * = null,_tmp_cont : Function) : void {
			var i : stx.Tuple2 = _tmp_i, cont : Function = _tmp_cont;
			stx.test.Assert.notNull(cont,null,{ fileName : "Arrows.hx", lineNumber : 237, className : "stx.reactive.Pair", methodName : "withInput"});
			var ol : stx.Option = null;
			var or : stx.Option = null;
			var merge : Function = function(l : *,r : *) : void {
				cont(stx.Tuples.t2(l,r));
			}
			var check : Function = function() : void {
				if(ol != null && or != null) merge(stx.Options.get(ol),stx.Options.get(or));
			}
			var hl : Function = function(v : *) : void {
				ol = ((v == null)?stx.Option.None:stx.Option.Some(v));
				check();
			}
			var hr : Function = function(v1 : *) : void {
				or = ((v1 == null)?stx.Option.None:stx.Option.Some(v1));
				check();
			}
			this.l.withInput(i._1,hl);
			this.r.withInput(i._2,hr);
		}
		
		public var r : stx.reactive.Arrow;
		public var l : stx.reactive.Arrow;
		static public function pair(pair_ : stx.reactive.Arrow,_pair : stx.reactive.Arrow) : stx.reactive.Arrow {
			return new stx.reactive.Pair(pair_,_pair);
		}
		
		static public function first(first : stx.reactive.Arrow) : stx.reactive.Arrow {
			return new stx.reactive.Pair(first,stx.reactive.Viaz.identity());
		}
		
		static public function second(second : stx.reactive.Arrow) : stx.reactive.Arrow {
			return new stx.reactive.Pair(stx.reactive.Viaz.identity(),second);
		}
		
	}
}
