package stx.functional {
	public interface PartialFunction2 {
		function toFunction() : Function ;
		function call(a : *,b : *) : * ;
		function orAlwaysC(z : Function) : stx.functional.PartialFunction2 ;
		function orAlways(f : Function) : stx.functional.PartialFunction2 ;
		function orElse(that : stx.functional.PartialFunction2) : stx.functional.PartialFunction2 ;
		function isDefinedAt(a : *,b : *) : Boolean ;
	}
}
