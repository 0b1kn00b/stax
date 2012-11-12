package stx.reactive {
	import stx.reactive.Stream;
	import stx.reactive.Propagation;
	import stx.reactive.SignalBool;
	import stx.reactive.Streams;
	import stx.reactive.External;
	import stx.reactive.Pulse;
	import stx.Tuple2;
	import stx.reactive.Signal;
	import stx.Iterables;
	public class Signals {
		public function Signals() : void {
		}
		
		static public function constant(value : *) : stx.reactive.Signal {
			return stx.reactive.Streams.pure().startsWith(value);
		}
		
		static public function cond(conditions : *,elseS : stx.reactive.Signal) : stx.reactive.Signal {
			return function() : stx.reactive.Signal {
				var $r : stx.reactive.Signal;
				{
					var $e2 : enum = (stx.Iterables.headOption(conditions));
					switch( $e2.index ) {
					case 0:
					$r = elseS;
					break;
					case 1:
					var h : stx.Tuple2 = $e2.params[0];
					$r = stx.reactive.SignalBool.ifTrue(h._1,h._2,stx.reactive.Signals.cond(stx.Iterables.tail(conditions),elseS));
					break;
					}
				}
				return $r;
			}();
		}
		
		static public function zipN(signals : *) : stx.reactive.Signal {
			var zipValueNow : Function = function() : * {
				return Prelude.SIterables.map(signals,function(b : stx.reactive.Signal) : * {
					return b.valueNow();
				});
			}
			return stx.reactive.Streams.create(function(pulse : stx.reactive.Pulse) : stx.reactive.Propagation {
				return stx.reactive.Propagation.propagate(pulse.withValue(zipValueNow()));
			},Prelude.SIterables.map(signals,function(b1 : stx.reactive.Signal) : stx.reactive.Stream {
				return b1.changes();
			})).startsWith(zipValueNow());
		}
		
		static public function sample(time : int) : stx.reactive.Signal {
			return stx.reactive.Streams.timer(time).startsWith(Std._int((stx.reactive.External.now)()));
		}
		
		static public function sampleS(time : stx.reactive.Signal) : stx.reactive.Signal {
			return stx.reactive.Streams.timerS(time).startsWith(Std._int((stx.reactive.External.now)()));
		}
		
		static public function toSignal(s : stx.reactive.Stream,init : * = null) : stx.reactive.Signal {
			return new stx.reactive.Signal(s,init,function(pulse : stx.reactive.Pulse) : stx.reactive.Propagation {
				return stx.reactive.Propagation.propagate(pulse);
			});
		}
		
	}
}
