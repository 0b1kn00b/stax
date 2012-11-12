package stx.reactive {
	import stx.reactive.F1A;
	import stx.reactive.Then;
	import haxe.Log;
	import stx.Tuple2;
	import stx.reactive.FutureArrow;
	import stx.reactive.ArrowApply;
	import stx.Tuples;
	import stx.reactive.Arrow;
	import stx.reactive.FunctionArrow;
	public class Viaz implements stx.reactive.Arrow{
		public function Viaz() : void {
		}
		
		public function withInput(_tmp_i : * = null,_tmp_cont : Function) : void {
			var i : * = _tmp_i, cont : Function = _tmp_cont;
		}
		
		static public function constant(v : *) : stx.reactive.Arrow {
			return new stx.reactive.FunctionArrow(function(x : *) : * {
				return v;
			});
		}
		
		static public function identity() : stx.reactive.Arrow {
			return stx.reactive.F1A.lift(function(x : *) : * {
				return x;
			});
		}
		
		static public function fan(a : stx.reactive.Arrow) : stx.reactive.Arrow {
			return stx.reactive.Then.then(a,stx.reactive.F1A.lift(function(x : *) : stx.Tuple2 {
				return stx.Tuples.t2(x,x);
			}));
		}
		
		static public function _as(a : stx.reactive.Arrow,type : Class) : stx.reactive.Arrow {
			return stx.reactive.Then.then(a,stx.reactive.F1A.lift(function(x : *) : * {
				return x;
			}));
		}
		
		static public function runCPS(a : stx.reactive.Arrow,i : *,cont : Function) : void {
			a.withInput(i,cont);
			return;
		}
		
		static public function runCont(a : stx.reactive.Arrow,i : *) : Function {
			return function(cont : Function) : void {
				a.withInput(i,cont);
			}
		}
		
		static public function _trace(a : stx.reactive.Arrow) : stx.reactive.Arrow {
			var m : Function = function(x : *) : * {
				haxe.Log._trace(x,{ fileName : "Arrows.hx", lineNumber : 50, className : "stx.reactive.Viaz", methodName : "trace"});
				return x;
			}
			return new stx.reactive.Then(a,new stx.reactive.FunctionArrow(m));
		}
		
		static public function run(a : stx.reactive.Arrow,i : * = null,cont : Function = null) : void {
			stx.reactive.Viaz.runCPS(a,i,((cont == null)?function(x : *) : void {
			}:cont));
		}
		
		static public function execute(a : stx.reactive.Arrow,i : *) : void {
			stx.reactive.Viaz.run(a,i);
		}
		
		static public function apply() : stx.reactive.ArrowApply {
			return new stx.reactive.ArrowApply();
		}
		
		static public function futureA() : stx.reactive.Arrow {
			return new stx.reactive.FutureArrow();
		}
		
	}
}
