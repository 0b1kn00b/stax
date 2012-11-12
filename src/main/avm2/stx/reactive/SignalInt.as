package stx.reactive {
	import stx.reactive.Signal;
	import stx.reactive.Signals;
	import stx.Tuple2;
	public class SignalInt {
		public function SignalInt() : void {
		}
		
		static public function plus(b : stx.reactive.Signal,value : int) : stx.reactive.Signal {
			return stx.reactive.SignalInt.plusS(b,stx.reactive.Signals.constant(value));
		}
		
		static public function plusS(b1 : stx.reactive.Signal,b2 : stx.reactive.Signal) : stx.reactive.Signal {
			return b1.zip(b2).map(function(t : stx.Tuple2) : int {
				return t._1 + t._2;
			});
		}
		
		static public function minusS(b1 : stx.reactive.Signal,b2 : stx.reactive.Signal) : stx.reactive.Signal {
			return b1.zip(b2).map(function(t : stx.Tuple2) : int {
				return t._1 - t._2;
			});
		}
		
		static public function minus(b : stx.reactive.Signal,value : int) : stx.reactive.Signal {
			return stx.reactive.SignalInt.minusS(b,stx.reactive.Signals.constant(value));
		}
		
		static public function timesS(b1 : stx.reactive.Signal,b2 : stx.reactive.Signal) : stx.reactive.Signal {
			return b1.zip(b2).map(function(t : stx.Tuple2) : int {
				return t._1 * t._2;
			});
		}
		
		static public function times(b : stx.reactive.Signal,value : int) : stx.reactive.Signal {
			return stx.reactive.SignalInt.timesS(b,stx.reactive.Signals.constant(value));
		}
		
		static public function modS(b1 : stx.reactive.Signal,b2 : stx.reactive.Signal) : stx.reactive.Signal {
			return b1.zip(b2).map(function(t : stx.Tuple2) : int {
				return t._1 % t._2;
			});
		}
		
		static public function mod(b : stx.reactive.Signal,value : int) : stx.reactive.Signal {
			return stx.reactive.SignalInt.modS(b,stx.reactive.Signals.constant(value));
		}
		
		static public function dividedByS(b1 : stx.reactive.Signal,b2 : stx.reactive.Signal) : stx.reactive.Signal {
			return b1.zip(b2).map(function(t : stx.Tuple2) : int {
				return Std._int(t._1 / t._2);
			});
		}
		
		static public function dividedBy(b : stx.reactive.Signal,value : int) : stx.reactive.Signal {
			return stx.reactive.SignalInt.dividedByS(b,stx.reactive.Signals.constant(value));
		}
		
		static public function abs(b : stx.reactive.Signal) : stx.reactive.Signal {
			return b.map(function(e : int) : int {
				return Std._int(Math.abs(e));
			});
		}
		
		static public function negate(b : stx.reactive.Signal) : stx.reactive.Signal {
			return b.map(function(e : int) : int {
				return -e;
			});
		}
		
		static public function toFloat(b : stx.reactive.Signal) : stx.reactive.Signal {
			return b.map(function(e : int) : Number {
				return e;
			});
		}
		
	}
}
