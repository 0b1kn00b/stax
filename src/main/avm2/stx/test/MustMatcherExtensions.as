package stx.test {
	import stx.Either;
	import stx.Eithers;
	public class MustMatcherExtensions {
		static public function negate(c : Function) : Function {
			var inverter : Function = function(result : *) : * {
				return { assertion : result.negation, negation : result.assertion}
			}
			return function(value : *) : stx.Either {
				return stx.Eithers.map(c(value),inverter,inverter);
			}
		}
		
		static public function or(c1 : Function,c2 : Function) : Function {
			var transformer : Function = function(r1 : *,r2 : *) : * {
				return { assertion : "(" + r1.assertion + ") || (" + r2.assertion + ")", negation : "(" + r1.negation + ") && (" + r2.negation + ")"}
			}
			return function(value : *) : stx.Either {
				return stx.Eithers.composeRight(c1(value),c2(value),transformer,transformer);
			}
		}
		
		static public function and(c1 : Function,c2 : Function) : Function {
			var transformer : Function = function(r1 : *,r2 : *) : * {
				return { assertion : "(" + r1.assertion + ") && (" + r2.assertion + ")", negation : "(" + r1.negation + ") || (" + r2.negation + ")"}
			}
			return function(value : *) : stx.Either {
				return stx.Eithers.composeLeft(c1(value),c2(value),transformer,transformer);
			}
		}
		
	}
}
