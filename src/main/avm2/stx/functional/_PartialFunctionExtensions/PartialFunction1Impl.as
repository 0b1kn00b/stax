package stx.functional._PartialFunctionExtensions {
	import stx.functional.PartialFunction1;
	import stx.Option;
	import stx.Tuple2;
	import stx.Entuple;
	import stx.Tuples;
	import flash.Boot;
	public class PartialFunction1Impl implements stx.functional.PartialFunction1{
		public function PartialFunction1Impl(def : Array = null) : void { if( !flash.Boot.skip_constructor ) {
			this._def = def;
		}}
		
		public function toFunction() : Function {
			var self : stx.functional._PartialFunctionExtensions.PartialFunction1Impl = this;
			return function(a : *) : stx.Option {
				return ((self.isDefinedAt(a))?stx.Option.Some(self.call(a)):stx.Option.None);
			}
		}
		
		public function call(_tmp_a : *) : * {
			var a : * = _tmp_a;
			{
				var _g : int = 0, _g1 : Array = this._def;
				while(_g < _g1.length) {
					var d : stx.Tuple2 = _g1[_g];
					++_g;
					if((d._1)(a)) return (d._2)(a);
				}
			}
			return Prelude.error("Function undefined at " + Std.string(a),{ fileName : "PartialFunctionExtensions.hx", lineNumber : 67, className : "stx.functional._PartialFunctionExtensions.PartialFunction1Impl", methodName : "call"});
		}
		
		public function orAlwaysC(_tmp_z : Function) : stx.functional.PartialFunction1 {
			var z : Function = _tmp_z;
			return stx.functional._PartialFunctionExtensions.PartialFunction1Impl.create(this._def.concat([stx.Entuple.entuple(function(a : *) : Boolean {
				return true;
			},function(a1 : *) : * {
				return z();
			})]));
		}
		
		public function orAlways(_tmp_f : Function) : stx.functional.PartialFunction1 {
			var f : Function = _tmp_f;
			return stx.functional._PartialFunctionExtensions.PartialFunction1Impl.create(this._def.concat([stx.Entuple.entuple(function(a : *) : Boolean {
				return true;
			},f)]));
		}
		
		public function orElse(_tmp_that : stx.functional.PartialFunction1) : stx.functional.PartialFunction1 {
			var that : stx.functional.PartialFunction1 = _tmp_that;
			return stx.functional._PartialFunctionExtensions.PartialFunction1Impl.create(this._def.concat([stx.Tuples.t2(that.isDefinedAt,that.call)]));
		}
		
		public function isDefinedAt(_tmp_a : *) : Boolean {
			var a : * = _tmp_a;
			{
				var _g : int = 0, _g1 : Array = this._def;
				while(_g < _g1.length) {
					var d : stx.Tuple2 = _g1[_g];
					++_g;
					if((d._1)(a)) return true;
				}
			}
			return false;
		}
		
		protected var _def : Array;
		static public function create(def : Array) : stx.functional._PartialFunctionExtensions.PartialFunction1Impl {
			return new stx.functional._PartialFunctionExtensions.PartialFunction1Impl(def);
		}
		
	}
}
