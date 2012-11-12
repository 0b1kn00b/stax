package stx.functional {
	import stx.functional._PartialFunctionExtensions.PartialFunction1Impl;
	public class PartialFunction1ImplExtensions {
		static public function toPartialFunction(def : Array) : stx.functional._PartialFunctionExtensions.PartialFunction1Impl {
			return stx.functional._PartialFunctionExtensions.PartialFunction1Impl.create(def);
		}
		
	}
}
