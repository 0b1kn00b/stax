package stx.reactive {
	import stx.reactive.Signal;
	import stx.reactive.Signals;
	import stx.Tuple2;
	public class SignalFloat {
		public function SignalFloat() : void {
		}
		
		static public function plus(b : stx.reactive.Signal,value : Number) : stx.reactive.Signal {
			return stx.reactive.SignalFloat.plusS(b,stx.reactive.Signals.constant(value));
		}
		
		static public function plusS(b1 : stx.reactive.Signal,b2 : stx.reactive.Signal) : stx.reactive.Signal {
			return b1.zip(b2).map(function(t : stx.Tuple2) : Number {
				return t._1 + t._2;
			});
		}
		
		static public function minusS(b1 : stx.reactive.Signal,b2 : stx.reactive.Signal) : stx.reactive.Signal {
			return b1.zip(b2).map(function(t : stx.Tuple2) : Number {
				return t._1 - t._2;
			});
		}
		
		static public function minus(b : stx.reactive.Signal,value : Number) : stx.reactive.Signal {
			return stx.reactive.SignalFloat.minusS(b,stx.reactive.Signals.constant(value));
		}
		
		static public function timesS(b1 : stx.reactive.Signal,b2 : stx.reactive.Signal) : stx.reactive.Signal {
			return b1.zip(b2).map(function(t : stx.Tuple2) : Number {
				return t._1 * t._2;
			});
		}
		
		static public function times(b : stx.reactive.Signal,value : Number) : stx.reactive.Signal {
			return stx.reactive.SignalFloat.timesS(b,stx.reactive.Signals.constant(value));
		}
		
		static public function dividedByS(b1 : stx.reactive.Signal,b2 : stx.reactive.Signal) : stx.reactive.Signal {
			return b1.zip(b2).map(function(t : stx.Tuple2) : Number {
				return t._1 / t._2;
			});
		}
		
		static public function dividedBy(b : stx.reactive.Signal,value : Number) : stx.reactive.Signal {
			return stx.reactive.SignalFloat.dividedByS(b,stx.reactive.Signals.constant(value));
		}
		
		static public function abs(b : stx.reactive.Signal) : stx.reactive.Signal {
			return b.map(function(e : Number) : Number {
				return Math.abs(e);
			});
		}
		
		static public function negate(b : stx.reactive.Signal) : stx.reactive.Signal {
			return b.map(function(e : Number) : Number {
				return -e;
			});
		}
		
		static public function floor(b : stx.reactive.Signal) : stx.reactive.Signal {
			return b.map(function(e : Number) : Number {
				return Math.floor(e);
			});
		}
		
		static public function ceil(b : stx.reactive.Signal) : stx.reactive.Signal {
			return b.map(function(e : Number) : Number {
				return Math.ceil(e);
			});
		}
		
		static public function round(b : stx.reactive.Signal) : stx.reactive.Signal {
			return b.map(function(e : Number) : Number {
				return Math.round(e);
			});
		}
		
		static public function acos(b : stx.reactive.Signal) : stx.reactive.Signal {
			return b.map(function(e : Number) : Number {
				return Math.acos(e);
			});
		}
		
		static public function asin(b : stx.reactive.Signal) : stx.reactive.Signal {
			return b.map(function(e : Number) : Number {
				return Math.asin(e);
			});
		}
		
		static public function atan(b : stx.reactive.Signal) : stx.reactive.Signal {
			return b.map(function(e : Number) : Number {
				return Math.atan(e);
			});
		}
		
		static public function atan2B(b1 : stx.reactive.Signal,b2 : stx.reactive.Signal) : stx.reactive.Signal {
			return b1.zip(b2).map(function(t : stx.Tuple2) : Number {
				return Math.atan2(t._1,t._2);
			});
		}
		
		static public function atan2(b : stx.reactive.Signal,value : Number) : stx.reactive.Signal {
			return stx.reactive.SignalFloat.atan2B(b,stx.reactive.Signals.constant(value));
		}
		
		static public function cos(b : stx.reactive.Signal) : stx.reactive.Signal {
			return b.map(function(e : Number) : Number {
				return Math.cos(e);
			});
		}
		
		static public function exp(b : stx.reactive.Signal) : stx.reactive.Signal {
			return b.map(function(e : Number) : Number {
				return Math.exp(e);
			});
		}
		
		static public function log(b : stx.reactive.Signal) : stx.reactive.Signal {
			return b.map(function(e : Number) : Number {
				return Math.log(e);
			});
		}
		
		static public function maxS(b1 : stx.reactive.Signal,b2 : stx.reactive.Signal) : stx.reactive.Signal {
			return b1.zip(b2).map(function(t : stx.Tuple2) : Number {
				return Math.max(t._1,t._2);
			});
		}
		
		static public function max(b : stx.reactive.Signal,value : Number) : stx.reactive.Signal {
			return stx.reactive.SignalFloat.maxS(b,stx.reactive.Signals.constant(value));
		}
		
		static public function minS(b1 : stx.reactive.Signal,b2 : stx.reactive.Signal) : stx.reactive.Signal {
			return b1.zip(b2).map(function(t : stx.Tuple2) : Number {
				return Math.min(t._1,t._2);
			});
		}
		
		static public function min(b : stx.reactive.Signal,value : Number) : stx.reactive.Signal {
			return stx.reactive.SignalFloat.minS(b,stx.reactive.Signals.constant(value));
		}
		
		static public function powS(b1 : stx.reactive.Signal,b2 : stx.reactive.Signal) : stx.reactive.Signal {
			return b1.zip(b2).map(function(t : stx.Tuple2) : Number {
				return Math.pow(t._1,t._2);
			});
		}
		
		static public function pow(b : stx.reactive.Signal,value : Number) : stx.reactive.Signal {
			return stx.reactive.SignalFloat.powS(b,stx.reactive.Signals.constant(value));
		}
		
		static public function sin(b : stx.reactive.Signal) : stx.reactive.Signal {
			return b.map(function(e : Number) : Number {
				return Math.sin(e);
			});
		}
		
		static public function sqrt(b : stx.reactive.Signal) : stx.reactive.Signal {
			return b.map(function(e : Number) : Number {
				return Math.sqrt(e);
			});
		}
		
		static public function tan(b : stx.reactive.Signal) : stx.reactive.Signal {
			return b.map(function(e : Number) : Number {
				return Math.tan(e);
			});
		}
		
	}
}
