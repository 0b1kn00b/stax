package stx.functional {
	public interface PartialFunction4 {
		function toFunction() : Function ;
		function call(a : *,b : *,c : *,d : *) : * ;
		function orAlwaysC(z : Function) : stx.functional.PartialFunction4 ;
		function orAlways(f : Function) : stx.functional.PartialFunction4 ;
		function orElse(that : stx.functional.PartialFunction4) : stx.functional.PartialFunction4 ;
		function isDefinedAt(a : *,b : *,c : *,d : *) : Boolean ;
	}
}
