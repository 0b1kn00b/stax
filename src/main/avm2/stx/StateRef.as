package stx {
	import stx.Functions1;
	import stx._States.WorldState;
	import stx.Tuple2;
	import stx.Tuples;
	import stx.States;
	import flash.Boot;
	public class StateRef {
		public function StateRef(v : * = null) : void { if( !flash.Boot.skip_constructor ) {
			this.value = v;
		}}
		
		public function modify(f : Function) : Function {
			var a : Function = this.read();
			var v : Function = stx.States.flatMap(a,stx.Functions1.andThen(f,this.write));
			return v;
		}
		
		public function write(a : *) : Function {
			var _g : stx.StateRef = this;
			return function(s : *) : stx.Tuple2 {
				_g.value = a;
				return stx.Tuples.t2(_g,s);
			}
		}
		
		public function read() : Function {
			return stx.States.unit(this.value);
		}
		
		protected var value : *;
		static public function newVar(v : *) : Function {
			return stx.States.unit(new stx.StateRef(v));
		}
		
		static public function run(v : Function) : void {
			v(new stx._States.WorldState());
		}
		
	}
}
