package stx.functional._PartialFunctionExtensions {
	import stx.Option;
	import stx.Tuple2;
	import stx.Entuple;
	import stx.Tuples;
	import flash.Boot;
	import stx.functional.PartialFunction5;
	public class PartialFunction5Impl implements stx.functional.PartialFunction5{
		public function PartialFunction5Impl(def : Array = null) : void { if( !flash.Boot.skip_constructor ) {
			this._def = def;
		}}
		
		public function toFunction() : Function {
			var self : stx.functional._PartialFunctionExtensions.PartialFunction5Impl = this;
			return function(a : *,b : *,c : *,d : *,e : *) : stx.Option {
				return ((self.isDefinedAt(a,b,c,d,e))?stx.Option.Some(self.call(a,b,c,d,e)):stx.Option.None);
			}
		}
		
		public function call(_tmp_a : *,_tmp_b : *,_tmp_c : *,_tmp_d : *,_tmp_e : *) : * {
			var a : * = _tmp_a, b : * = _tmp_b, c : * = _tmp_c, d : * = _tmp_d, e : * = _tmp_e;
			{
				var _g : int = 0, _g1 : Array = this._def;
				while(_g < _g1.length) {
					var def : stx.Tuple2 = _g1[_g];
					++_g;
					if((def._1)(a,b,c,d,e)) return (def._2)(a,b,c,d,e);
				}
			}
			return Prelude.error("Function undefined at (" + Std.string(a) + ", " + Std.string(b) + ", " + Std.string(c) + ", " + Std.string(d) + ")",{ fileName : "PartialFunctionExtensions.hx", lineNumber : 311, className : "stx.functional._PartialFunctionExtensions.PartialFunction5Impl", methodName : "call"});
		}
		
		public function orAlwaysC(_tmp_z : Function) : stx.functional.PartialFunction5 {
			var z : Function = _tmp_z;
			return stx.functional._PartialFunctionExtensions.PartialFunction5Impl.create(this._def.concat([stx.Entuple.entuple(function(a : *,b : *,c : *,d : *,e : *) : Boolean {
				return true;
			},function(a1 : *,b1 : *,c1 : *,d1 : *,e1 : *) : * {
				return z();
			})]));
		}
		
		public function orAlways(_tmp_f : Function) : stx.functional.PartialFunction5 {
			var f : Function = _tmp_f;
			return stx.functional._PartialFunctionExtensions.PartialFunction5Impl.create(this._def.concat([stx.Entuple.entuple(function(a : *,b : *,c : *,d : *,e : *) : Boolean {
				return true;
			},f)]));
		}
		
		public function orElse(_tmp_that : stx.functional.PartialFunction5) : stx.functional.PartialFunction5 {
			var that : stx.functional.PartialFunction5 = _tmp_that;
			return stx.functional._PartialFunctionExtensions.PartialFunction5Impl.create(this._def.concat([stx.Tuples.t2(that.isDefinedAt,that.call)]));
		}
		
		public function isDefinedAt(_tmp_a : *,_tmp_b : *,_tmp_c : *,_tmp_d : *,_tmp_e : *) : Boolean {
			var a : * = _tmp_a, b : * = _tmp_b, c : * = _tmp_c, d : * = _tmp_d, e : * = _tmp_e;
			{
				var _g : int = 0, _g1 : Array = this._def;
				while(_g < _g1.length) {
					var def : stx.Tuple2 = _g1[_g];
					++_g;
					if((def._1)(a,b,c,d,e)) return true;
				}
			}
			return false;
		}
		
		protected var _def : Array;
		static public function create(def : Array) : stx.functional._PartialFunctionExtensions.PartialFunction5Impl {
			return new stx.functional._PartialFunctionExtensions.PartialFunction5Impl(def);
		}
		
	}
}
