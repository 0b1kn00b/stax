package stx.functional {
	import stx.functional._PartialFunctionExtensions.PartialFunction4Impl;
	public class PartialFunction4ImplExtensions {
		static public function toPartialFunction(def : Array) : stx.functional._PartialFunctionExtensions.PartialFunction4Impl {
			return stx.functional._PartialFunctionExtensions.PartialFunction4Impl.create(def);
		}
		
	}
}
