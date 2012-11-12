package stx.functional._PartialFunctionExtensions {
	import stx.Option;
	import stx.Tuple2;
	import stx.functional.PartialFunction2;
	import stx.Entuple;
	import stx.Tuples;
	import flash.Boot;
	public class PartialFunction2Impl implements stx.functional.PartialFunction2{
		public function PartialFunction2Impl(def : Array = null) : void { if( !flash.Boot.skip_constructor ) {
			this._def = def;
		}}
		
		public function toFunction() : Function {
			var self : stx.functional._PartialFunctionExtensions.PartialFunction2Impl = this;
			return function(a : *,b : *) : stx.Option {
				return ((self.isDefinedAt(a,b))?stx.Option.Some(self.call(a,b)):stx.Option.None);
			}
		}
		
		public function call(_tmp_a : *,_tmp_b : *) : * {
			var a : * = _tmp_a, b : * = _tmp_b;
			{
				var _g : int = 0, _g1 : Array = this._def;
				while(_g < _g1.length) {
					var d : stx.Tuple2 = _g1[_g];
					++_g;
					if((d._1)(a,b)) return (d._2)(a,b);
				}
			}
			return Prelude.error("Function undefined at (" + Std.string(a) + ", " + Std.string(b) + ")",{ fileName : "PartialFunctionExtensions.hx", lineNumber : 128, className : "stx.functional._PartialFunctionExtensions.PartialFunction2Impl", methodName : "call"});
		}
		
		public function orAlwaysC(_tmp_z : Function) : stx.functional.PartialFunction2 {
			var z : Function = _tmp_z;
			return stx.functional._PartialFunctionExtensions.PartialFunction2Impl.create(this._def.concat([stx.Entuple.entuple(function(a : *,b : *) : Boolean {
				return true;
			},function(a1 : *,b1 : *) : * {
				return z();
			})]));
		}
		
		public function orAlways(_tmp_f : Function) : stx.functional.PartialFunction2 {
			var f : Function = _tmp_f;
			return stx.functional._PartialFunctionExtensions.PartialFunction2Impl.create(this._def.concat([stx.Entuple.entuple(function(a : *,b : *) : Boolean {
				return true;
			},f)]));
		}
		
		public function orElse(_tmp_that : stx.functional.PartialFunction2) : stx.functional.PartialFunction2 {
			var that : stx.functional.PartialFunction2 = _tmp_that;
			return stx.functional._PartialFunctionExtensions.PartialFunction2Impl.create(this._def.concat([stx.Tuples.t2(that.isDefinedAt,that.call)]));
		}
		
		public function isDefinedAt(_tmp_a : *,_tmp_b : *) : Boolean {
			var a : * = _tmp_a, b : * = _tmp_b;
			{
				var _g : int = 0, _g1 : Array = this._def;
				while(_g < _g1.length) {
					var d : stx.Tuple2 = _g1[_g];
					++_g;
					if((d._1)(a,b)) return true;
				}
			}
			return false;
		}
		
		protected var _def : Array;
		static public function create(def : Array) : stx.functional._PartialFunctionExtensions.PartialFunction2Impl {
			return new stx.functional._PartialFunctionExtensions.PartialFunction2Impl(def);
		}
		
	}
}
