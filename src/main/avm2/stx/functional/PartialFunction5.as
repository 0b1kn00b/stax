package stx.functional {
	public interface PartialFunction5 {
		function toFunction() : Function ;
		function call(a : *,b : *,c : *,d : *,e : *) : * ;
		function orAlwaysC(z : Function) : stx.functional.PartialFunction5 ;
		function orAlways(f : Function) : stx.functional.PartialFunction5 ;
		function orElse(that : stx.functional.PartialFunction5) : stx.functional.PartialFunction5 ;
		function isDefinedAt(a : *,b : *,c : *,d : *,e : *) : Boolean ;
	}
}
