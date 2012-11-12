package stx.functional {
	public interface PartialFunction1 {
		function toFunction() : Function ;
		function call(a : *) : * ;
		function orAlwaysC(z : Function) : stx.functional.PartialFunction1 ;
		function orAlways(f : Function) : stx.functional.PartialFunction1 ;
		function orElse(that : stx.functional.PartialFunction1) : stx.functional.PartialFunction1 ;
		function isDefinedAt(a : *) : Boolean ;
	}
}
