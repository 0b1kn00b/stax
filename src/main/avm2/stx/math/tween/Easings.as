package stx.math.tween {
	public class Easings {
		static public var Linear : Function = function(t : Number) : Number {
			return t;
		}
		static public var Quadratic : Function = function(t : Number) : Number {
			return t * t;
		}
		static public var Cubic : Function = function(t : Number) : Number {
			return t * t * t;
		}
		static public var Quartic : Function = function(t : Number) : Number {
			var squared : Number = t * t;
			return squared * squared;
		}
		static public var Quintic : Function = function(t : Number) : Number {
			var squared : Number = t * t;
			return squared * squared * t;
		}
	}
}
