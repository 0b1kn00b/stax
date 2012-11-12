package stx.reactive {
	import stx.reactive.StreamBool;
	import stx.reactive.Stream;
	import stx.reactive.Propagation;
	import stx.reactive.Signals;
	import stx.reactive.External;
	import stx.reactive.Signal;
	import stx.Tuple2;
	import stx.reactive.Pulse;
	import stx.Future;
	import stx.Iterables;
	public class Streams {
		public function Streams() : void {
		}
		
		static public function create(updater : Function,sources : * = null) : stx.reactive.Stream {
			var sourceEvents : Array = ((sources == null)?null:Prelude.SIterables.toArray(sources));
			return new stx.reactive.Stream(updater,sourceEvents);
		}
		
		static public function identity(sources : * = null) : stx.reactive.Stream {
			var sourceArray : Array = ((sources == null)?null:Prelude.SIterables.toArray(sources));
			return new stx.reactive.Stream(function(pulse : stx.reactive.Pulse) : stx.reactive.Propagation {
				return stx.reactive.Propagation.propagate(pulse);
			},sourceArray);
		}
		
		static public function zero() : stx.reactive.Stream {
			return stx.reactive.Streams.create(function(pulse : stx.reactive.Pulse) : stx.reactive.Propagation {
				throw "zeroE : received a value; zeroE should not receive a value; the value was " + Std.string(pulse.value);
				return stx.reactive.Propagation.doNotPropagate;
			});
		}
		
		static public function toStream(f : stx.Future) : stx.reactive.Stream {
			var s : stx.reactive.Stream = stx.reactive.Streams.create(function(pulse : stx.reactive.Pulse) : stx.reactive.Propagation {
				return stx.reactive.Propagation.propagate(pulse.value);
			});
			f.foreach(function(v : *) : void {
				s.sendEvent(v);
			});
			return s;
		}
		
		static public function one(val : *) : stx.reactive.Stream {
			var sent : Boolean = false;
			var stream : stx.reactive.Stream = stx.reactive.Streams.create(function(pulse : stx.reactive.Pulse) : stx.reactive.Propagation {
				if(sent) throw "Streams.one: received an extra value";
				sent = false;
				return stx.reactive.Propagation.propagate(pulse);
			});
			stream.sendLater(val);
			return stream;
		}
		
		static public function merge(streams : *) : stx.reactive.Stream {
			return ((Prelude.SIterables.size(streams) == 0)?stx.reactive.Streams.zero():stx.reactive.Streams.pure(streams));
		}
		
		static public function constant(value : *,sources : * = null) : stx.reactive.Stream {
			return stx.reactive.Streams.create(function(pulse : stx.reactive.Pulse) : stx.reactive.Propagation {
				return stx.reactive.Propagation.propagate(pulse.withValue(value));
			},sources);
		}
		
		static public function receiver() : stx.reactive.Stream {
			return stx.reactive.Streams.pure();
		}
		
		static public function cond(conditions : *) : stx.reactive.Stream {
			return function() : stx.reactive.Stream {
				var $r : stx.reactive.Stream;
				{
					var $e2 : enum = (stx.Iterables.headOption(conditions));
					switch( $e2.index ) {
					case 0:
					$r = stx.reactive.Streams.zero();
					break;
					case 1:
					var h : stx.Tuple2 = $e2.params[0];
					$r = stx.reactive.StreamBool.ifTrue(h._1,h._2,stx.reactive.Streams.cond(stx.Iterables.tail(conditions)));
					break;
					}
				}
				return $r;
			}();
		}
		
		static public function timer(time : int) : stx.reactive.Stream {
			return stx.reactive.Streams.timerS(stx.reactive.Signals.constant(time));
		}
		
		static public function timerS(time : stx.reactive.Signal) : stx.reactive.Stream {
			var stream : stx.reactive.Stream = stx.reactive.Streams.pure();
			var pulser : Function = null;
			var timer : * = null;
			var createTimer : Function = function() : * {
				return stx.reactive.External.setTimeout(pulser,time.valueNow());
			}
			pulser = function() : void {
				stream.sendEvent((stx.reactive.External.now)());
				if(timer != null) (stx.reactive.External.cancelTimeout)(timer);
				if(!stream.getWeaklyHeld()) timer = createTimer();
			}
			timer = createTimer();
			return stream;
		}
		
		static public function zipN(streams : *) : stx.reactive.Stream {
			var stamps : Array = Prelude.SIterables.toArray(Prelude.SIterables.map(streams,function(s : stx.reactive.Stream) : int {
				return -1;
			}));
			var values : Array = Prelude.SIterables.toArray(Prelude.SIterables.map(streams,function(s1 : stx.reactive.Stream) : * {
				return null;
			}));
			var output : stx.reactive.Stream = stx.reactive.Streams.pure();
			{
				var _g1 : int = 0, _g : int = Prelude.SIterables.size(streams);
				while(_g1 < _g) {
					var index : Array = [_g1++];
					var stream : stx.reactive.Stream = stx.Iterables.at(streams,index[0]);
					output = output.merge(stx.reactive.Streams.create((function(index : Array) : Function {
						return function(pulse : stx.reactive.Pulse) : stx.reactive.Propagation {
							stamps[index[0]] = pulse.stamp;
							values[index[0]] = pulse.value;
							return stx.reactive.Propagation.propagate(pulse);
						}
					})(index),[stream]));
				}
			}
			return stx.reactive.Streams.create(function(pulse1 : stx.reactive.Pulse) : stx.reactive.Propagation {
				var stampsEqual : Boolean = Prelude.SIterables.size(stx.Iterables.nub(stamps)) == 1;
				return ((stampsEqual)?function() : stx.reactive.Propagation {
					var $r : stx.reactive.Propagation;
					var iter : * = Prelude.SArrays.snapshot(values);
					$r = stx.reactive.Propagation.propagate(pulse1.withValue(iter));
					return $r;
				}():stx.reactive.Propagation.doNotPropagate);
			},[output]).uniqueSteps();
		}
		
		static public function randomS(time : stx.reactive.Signal) : stx.reactive.Stream {
			return stx.reactive.Streams.timerS(time).map(function(e : int) : Number {
				return Math.random();
			});
		}
		
		static public function random(time : int) : stx.reactive.Stream {
			return stx.reactive.Streams.randomS(stx.reactive.Signals.constant(time));
		}
		
	}
}
