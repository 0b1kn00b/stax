package stx.functional._PartialFunctionExtensions {
	import stx.Option;
	import stx.Tuple2;
	import stx.Entuple;
	import stx.functional.PartialFunction3;
	import stx.Tuples;
	import flash.Boot;
	public class PartialFunction3Impl implements stx.functional.PartialFunction3{
		public function PartialFunction3Impl(def : Array = null) : void { if( !flash.Boot.skip_constructor ) {
			this._def = def;
		}}
		
		public function toFunction() : Function {
			var self : stx.functional._PartialFunctionExtensions.PartialFunction3Impl = this;
			return function(a : *,b : *,c : *) : stx.Option {
				return ((self.isDefinedAt(a,b,c))?stx.Option.Some(self.call(a,b,c)):stx.Option.None);
			}
		}
		
		public function call(_tmp_a : *,_tmp_b : *,_tmp_c : *) : * {
			var a : * = _tmp_a, b : * = _tmp_b, c : * = _tmp_c;
			{
				var _g : int = 0, _g1 : Array = this._def;
				while(_g < _g1.length) {
					var d : stx.Tuple2 = _g1[_g];
					++_g;
					if((d._1)(a,b,c)) return (d._2)(a,b,c);
				}
			}
			return Prelude.error("Function undefined at (" + Std.string(a) + ", " + Std.string(b) + ", " + Std.string(c) + ")",{ fileName : "PartialFunctionExtensions.hx", lineNumber : 189, className : "stx.functional._PartialFunctionExtensions.PartialFunction3Impl", methodName : "call"});
		}
		
		public function orAlwaysC(_tmp_z : Function) : stx.functional.PartialFunction3 {
			var z : Function = _tmp_z;
			return stx.functional._PartialFunctionExtensions.PartialFunction3Impl.create(this._def.concat([stx.Entuple.entuple(function(a : *,b : *,c : *) : Boolean {
				return true;
			},function(a1 : *,b1 : *,c1 : *) : * {
				return z();
			})]));
		}
		
		public function orAlways(_tmp_f : Function) : stx.functional.PartialFunction3 {
			var f : Function = _tmp_f;
			return stx.functional._PartialFunctionExtensions.PartialFunction3Impl.create(this._def.concat([stx.Entuple.entuple(function(a : *,b : *,c : *) : Boolean {
				return true;
			},f)]));
		}
		
		public function orElse(_tmp_that : stx.functional.PartialFunction3) : stx.functional.PartialFunction3 {
			var that : stx.functional.PartialFunction3 = _tmp_that;
			return stx.functional._PartialFunctionExtensions.PartialFunction3Impl.create(this._def.concat([stx.Tuples.t2(that.isDefinedAt,that.call)]));
		}
		
		public function isDefinedAt(_tmp_a : *,_tmp_b : *,_tmp_c : *) : Boolean {
			var a : * = _tmp_a, b : * = _tmp_b, c : * = _tmp_c;
			{
				var _g : int = 0, _g1 : Array = this._def;
				while(_g < _g1.length) {
					var d : stx.Tuple2 = _g1[_g];
					++_g;
					if((d._1)(a,b,c)) return true;
				}
			}
			return false;
		}
		
		protected var _def : Array;
		static public function create(def : Array) : stx.functional._PartialFunctionExtensions.PartialFunction3Impl {
			return new stx.functional._PartialFunctionExtensions.PartialFunction3Impl(def);
		}
		
	}
}
