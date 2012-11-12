package stx.reactive {
	import stx.reactive.Propagation;
	import stx.reactive.Streams;
	import stx.reactive.Signal;
	import stx.reactive.Pulse;
	import stx.reactive.Stream;
	public class SignalSignal {
		public function SignalSignal() : void {
		}
		
		static public function switchS(signal : stx.reactive.Signal) : stx.reactive.Signal {
			return stx.reactive.SignalSignal.flatten(signal);
		}
		
		static public function join(signal : stx.reactive.Signal) : stx.reactive.Signal {
			return stx.reactive.SignalSignal.flatten(signal);
		}
		
		static public function flatten(signal : stx.reactive.Signal) : stx.reactive.Signal {
			var init : stx.reactive.Signal = signal.valueNow();
			var prevSourceE : stx.reactive.Stream = null;
			var receiverE : stx.reactive.Stream = stx.reactive.Streams.pure();
			var makerE : stx.reactive.Stream = stx.reactive.Streams.create(function(p : stx.reactive.Pulse) : stx.reactive.Propagation {
				if(prevSourceE != null) prevSourceE.removeListener(receiverE);
				prevSourceE = p.value.changes();
				prevSourceE.attachListener(receiverE);
				receiverE.sendEvent(p.value.valueNow());
				return stx.reactive.Propagation.doNotPropagate;
			},[signal.changes()]);
			makerE.sendEvent(init);
			return receiverE.startsWith(init.valueNow());
		}
		
	}
}
