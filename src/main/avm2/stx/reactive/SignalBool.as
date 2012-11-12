package stx.reactive {
	import stx.reactive.Signal;
	import stx.Iterables;
	import stx.reactive.Signals;
	import stx.reactive.StreamBool;
	public class SignalBool {
		public function SignalBool() : void {
		}
		
		static public function not(signal : stx.reactive.Signal) : stx.reactive.Signal {
			return stx.reactive.StreamBool.not(signal.changes()).startsWith(!signal.valueNow());
		}
		
		static public function ifTrue(condition : stx.reactive.Signal,thenS : stx.reactive.Signal,elseS : stx.reactive.Signal) : stx.reactive.Signal {
			return condition.map(function(b : Boolean) : * {
				return ((b)?thenS.valueNow():elseS.valueNow());
			});
		}
		
		static public function and(signals : *) : stx.reactive.Signal {
			return stx.reactive.Signals.zipN(signals).map(function(i : *) : Boolean {
				return stx.Iterables.and(i);
			});
		}
		
		static public function or(signals : *) : stx.reactive.Signal {
			return stx.reactive.Signals.zipN(signals).map(function(i : *) : Boolean {
				return stx.Iterables.or(i);
			});
		}
		
	}
}
