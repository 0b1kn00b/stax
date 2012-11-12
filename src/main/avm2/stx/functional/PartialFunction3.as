package stx.functional {
	public interface PartialFunction3 {
		function toFunction() : Function ;
		function call(a : *,b : *,c : *) : * ;
		function orAlwaysC(z : Function) : stx.functional.PartialFunction3 ;
		function orAlways(f : Function) : stx.functional.PartialFunction3 ;
		function orElse(that : stx.functional.PartialFunction3) : stx.functional.PartialFunction3 ;
		function isDefinedAt(a : *,b : *,c : *) : Boolean ;
	}
}
