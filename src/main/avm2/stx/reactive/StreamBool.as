package stx.reactive {
	import stx.reactive.Propagation;
	import stx.reactive.Streams;
	import stx.Iterables;
	import stx.reactive.Pulse;
	import stx.reactive.Stream;
	public class StreamBool {
		public function StreamBool() : void {
		}
		
		static public function not(stream : stx.reactive.Stream) : stx.reactive.Stream {
			return stream.map(function(v : Boolean) : Boolean {
				return !v;
			});
		}
		
		static public function ifTrue(stream : stx.reactive.Stream,thenE : stx.reactive.Stream,elseE : stx.reactive.Stream) : stx.reactive.Stream {
			var testStamp : int = -1;
			var testValue : Boolean = false;
			stx.reactive.Streams.create(function(pulse : stx.reactive.Pulse) : stx.reactive.Propagation {
				testStamp = pulse.stamp;
				testValue = pulse.value;
				return stx.reactive.Propagation.doNotPropagate;
			},[stream]);
			return stx.reactive.Streams.merge([stx.reactive.Streams.create(function(pulse1 : stx.reactive.Pulse) : stx.reactive.Propagation {
				return ((testValue && testStamp == pulse1.stamp)?stx.reactive.Propagation.propagate(pulse1):stx.reactive.Propagation.doNotPropagate);
			},[thenE]),stx.reactive.Streams.create(function(pulse2 : stx.reactive.Pulse) : stx.reactive.Propagation {
				return ((!testValue && testStamp == pulse2.stamp)?stx.reactive.Propagation.propagate(pulse2):stx.reactive.Propagation.doNotPropagate);
			},[elseE])]);
		}
		
		static public function and(streams : *) : stx.reactive.Stream {
			var rev : * = stx.Iterables.reversed(streams);
			var count : int = Prelude.SIterables.size(streams);
			var iterator : * = rev.iterator();
			var acc : stx.reactive.Stream = ((iterator.hasNext())?iterator.next():stx.reactive.Streams.one(true));
			while(iterator.hasNext()) {
				var next : stx.reactive.Stream = iterator.next();
				acc = stx.reactive.StreamBool.ifTrue(next,acc,next.constant(false));
			}
			return acc;
		}
		
		static public function or(streams : *) : stx.reactive.Stream {
			var rev : * = stx.Iterables.reversed(streams);
			var count : int = Prelude.SIterables.size(streams);
			var iterator : * = rev.iterator();
			var acc : stx.reactive.Stream = ((iterator.hasNext())?iterator.next():stx.reactive.Streams.one(false));
			while(iterator.hasNext()) {
				var next : stx.reactive.Stream = iterator.next();
				acc = stx.reactive.StreamBool.ifTrue(next,next,acc);
			}
			return acc;
		}
		
	}
}
