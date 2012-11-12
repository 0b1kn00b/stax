package stx {
	import stx.Functions1;
	import stx.Tuples;
	import stx.Functions2;
	import stx.Functions3;
	import stx.Tuple2;
	public class States {
		static public function apply(state : Function,v : *) : stx.Tuple2 {
			return state(v);
		}
		
		static public function exec(state : Function,s : *) : * {
			return stx.Tuple2.second(state(s));
		}
		
		static public function eval(state : Function,s : *) : * {
			return stx.Tuple2.first(state(s));
		}
		
		static public function map(state : Function,fn : Function) : Function {
			return stx.Functions1.andThen(stx.Functions2.p1(stx.States.apply,state),stx.Functions2.p2(stx.Functions3.p3(stx.Tuple2.translate,Prelude.unfold
Prelude.unfold()),fn));
		}
		
		static public function mapS(state : Function,fn : Function) : Function {
			return function(s : *) : stx.Tuple2 {
				var o : stx.Tuple2 = state(s);
				return stx.Tuples.t2(o._1,fn(o._2));
			}
		}
		
		static public function flatMap(state : Function,fn : Function) : Function {
			return stx.Functions1.andThen(stx.Functions1.andThen(stx.Functions2.p1(stx.States.apply,state),stx.Functions2.p2(stx.Functions3.p3(stx.Tuple2.translate,Prelude.unfold
Prelude.unfold()),fn)),function(t : stx.Tuple2) : stx.Tuple2 {
				return (t._1)(t._2);
			});
		}
		
		static public function getS(state : Function) : Function {
			return function(s : *) : stx.Tuple2 {
				var o : stx.Tuple2 = state(s);
				return stx.Tuples.t2(o._2,o._2);
			}
		}
		
		static public function putS(state : Function,n : *) : Function {
			return function(s : *) : stx.Tuple2 {
				return stx.Tuples.t2(null,n);
			}
		}
		
		static public function stateOf(v : *) : Function {
			return function(s : *) : stx.Tuple2 {
				return stx.Tuples.t2(null,s);
			}
		}
		
		static public function unit(value : *) : Function {
			return function(s : *) : stx.Tuple2 {
				return stx.Tuples.t2(value,s);
			}
		}
		
	}
}
