package stx.functional {
	import stx.functional._PartialFunctionExtensions.PartialFunction3Impl;
	public class PartialFunction3ImplExtensions {
		static public function toPartialFunction(def : Array) : stx.functional._PartialFunctionExtensions.PartialFunction3Impl {
			return stx.functional._PartialFunctionExtensions.PartialFunction3Impl.create(def);
		}
		
	}
}
