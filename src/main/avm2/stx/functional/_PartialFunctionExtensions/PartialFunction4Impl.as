package stx.functional._PartialFunctionExtensions {
	import stx.Option;
	import stx.Tuple2;
	import stx.Entuple;
	import stx.Tuples;
	import stx.functional.PartialFunction4;
	import flash.Boot;
	public class PartialFunction4Impl implements stx.functional.PartialFunction4{
		public function PartialFunction4Impl(def : Array = null) : void { if( !flash.Boot.skip_constructor ) {
			this._def = def;
		}}
		
		public function toFunction() : Function {
			var self : stx.functional._PartialFunctionExtensions.PartialFunction4Impl = this;
			return function(a : *,b : *,c : *,d : *) : stx.Option {
				return ((self.isDefinedAt(a,b,c,d))?stx.Option.Some(self.call(a,b,c,d)):stx.Option.None);
			}
		}
		
		public function call(_tmp_a : *,_tmp_b : *,_tmp_c : *,_tmp_d : *) : * {
			var a : * = _tmp_a, b : * = _tmp_b, c : * = _tmp_c, d : * = _tmp_d;
			{
				var _g : int = 0, _g1 : Array = this._def;
				while(_g < _g1.length) {
					var def : stx.Tuple2 = _g1[_g];
					++_g;
					if((def._1)(a,b,c,d)) return (def._2)(a,b,c,d);
				}
			}
			return Prelude.error("Function undefined at (" + Std.string(a) + ", " + Std.string(b) + ", " + Std.string(c) + ", " + Std.string(d) + ")",{ fileName : "PartialFunctionExtensions.hx", lineNumber : 250, className : "stx.functional._PartialFunctionExtensions.PartialFunction4Impl", methodName : "call"});
		}
		
		public function orAlwaysC(_tmp_z : Function) : stx.functional.PartialFunction4 {
			var z : Function = _tmp_z;
			return stx.functional._PartialFunctionExtensions.PartialFunction4Impl.create(this._def.concat([stx.Entuple.entuple(function(a : *,b : *,c : *,d : *) : Boolean {
				return true;
			},function(a1 : *,b1 : *,c1 : *,d1 : *) : * {
				return z();
			})]));
		}
		
		public function orAlways(_tmp_f : Function) : stx.functional.PartialFunction4 {
			var f : Function = _tmp_f;
			return stx.functional._PartialFunctionExtensions.PartialFunction4Impl.create(this._def.concat([stx.Entuple.entuple(function(a : *,b : *,c : *,d : *) : Boolean {
				return true;
			},f)]));
		}
		
		public function orElse(_tmp_that : stx.functional.PartialFunction4) : stx.functional.PartialFunction4 {
			var that : stx.functional.PartialFunction4 = _tmp_that;
			return stx.functional._PartialFunctionExtensions.PartialFunction4Impl.create(this._def.concat([stx.Tuples.t2(that.isDefinedAt,that.call)]));
		}
		
		public function isDefinedAt(_tmp_a : *,_tmp_b : *,_tmp_c : *,_tmp_d : *) : Boolean {
			var a : * = _tmp_a, b : * = _tmp_b, c : * = _tmp_c, d : * = _tmp_d;
			{
				var _g : int = 0, _g1 : Array = this._def;
				while(_g < _g1.length) {
					var def : stx.Tuple2 = _g1[_g];
					++_g;
					if((def._1)(a,b,c,d)) return true;
				}
			}
			return false;
		}
		
		protected var _def : Array;
		static public function create(def : Array) : stx.functional._PartialFunctionExtensions.PartialFunction4Impl {
			return new stx.functional._PartialFunctionExtensions.PartialFunction4Impl(def);
		}
		
	}
}
