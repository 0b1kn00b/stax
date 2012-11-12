package stx.functional {
	import stx.functional._PartialFunctionExtensions.PartialFunction2Impl;
	public class PartialFunction2ImplExtensions {
		static public function toPartialFunction(def : Array) : stx.functional._PartialFunctionExtensions.PartialFunction2Impl {
			return stx.functional._PartialFunctionExtensions.PartialFunction2Impl.create(def);
		}
		
	}
}
