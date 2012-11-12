package stx.reactive {
	import stx.reactive.RepeatArrow;
	import stx.Option;
	import stx.reactive.F1A;
	import stx.reactive.Then;
	import stx.reactive.OptionArrow;
	import haxe.Log;
	import stx.reactive.RepeatV;
	import stx.reactive.Arrow;
	import flash.Boot;
	public class MapArrow implements stx.reactive.Arrow{
		public function MapArrow(fn : stx.reactive.Arrow = null) : void { if( !flash.Boot.skip_constructor ) {
			this.a = fn;
		}}
		
		public function withInput(_tmp_i : * = null,_tmp_cont : Function) : void {
			var i : * = _tmp_i, cont : Function = _tmp_cont;
			haxe.Log._trace(i,{ fileName : "Arrows.hx", lineNumber : 150, className : "stx.reactive.MapArrow", methodName : "withInput"});
			var iter : * = i.iterator();
			var o : Array = [];
			var index : int = 0;
			new stx.reactive.RepeatArrow(stx.reactive.Then.then(stx.reactive.Then.then(stx.reactive.F1A.lift(function(iter1 : *) : stx.Option {
				return ((iter1.hasNext())?stx.Option.Some(iter1.next()):stx.Option.None);
			}),stx.reactive.OptionArrow.option(this.a)),stx.reactive.F1A.lift(function(x : stx.Option) : stx.reactive.RepeatV {
				return function() : stx.reactive.RepeatV {
					var $r : stx.reactive.RepeatV;
					{
						var $e2 : enum = (x);
						switch( $e2.index ) {
						case 0:
						$r = stx.reactive.RepeatV.Done(o);
						break;
						case 1:
						var v : * = $e2.params[0];
						$r = function() : stx.reactive.RepeatV {
							var $r3 : stx.reactive.RepeatV;
							o.push(v);
							$r3 = stx.reactive.RepeatV.Repeat(iter);
							return $r3;
						}();
						break;
						}
					}
					return $r;
				}();
			}))).withInput(iter,cont);
			return;
		}
		
		protected var a : stx.reactive.Arrow;
		static public function mapper(a : stx.reactive.Arrow) : stx.reactive.Arrow {
			return new stx.reactive.MapArrow(a);
		}
		
	}
}
