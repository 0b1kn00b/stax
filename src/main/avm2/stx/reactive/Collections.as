package stx.reactive {
	import stx.reactive.Streams;
	import stx.reactive.Signal;
	import stx.reactive.Signals;
	import stx.reactive.External;
	import stx.reactive.Stream;
	public class Collections {
		public function Collections() : void {
		}
		
		static public function toStream(collection : *,time : int) : stx.reactive.Stream {
			return stx.reactive.Collections.toStreamS(collection,stx.reactive.Signals.constant(time));
		}
		
		static public function toStreamS(collection : *,time : stx.reactive.Signal) : stx.reactive.Stream {
			var startTime : Number = -1.0;
			var accum : int = 0;
			var iterator : * = collection.iterator();
			if(!iterator.hasNext()) return stx.reactive.Streams.zero();
			var stream : stx.reactive.Stream = stx.reactive.Streams.pure();
			var pulser : Function = null;
			var timer : * = null;
			var createTimer : Function = function() : * {
				var nowTime : Number = (stx.reactive.External.now)();
				if(startTime < 0.0) startTime = nowTime;
				var delta : int = time.valueNow();
				var endTime : Number = startTime + accum + delta;
				var timeToWait : Number = endTime - nowTime;
				accum += delta;
				return ((timeToWait < 0)?function() : * {
					var $r : *;
					pulser();
					$r = null;
					return $r;
				}():function() : * {
					var $r2 : *;
					var t : * = stx.reactive.External.setTimeout(pulser,Std._int(timeToWait));
					$r2 = t;
					return $r2;
				}());
			}
			pulser = function() : void {
				var next : * = iterator.next();
				stream.sendEvent(next);
				if(timer != null) (stx.reactive.External.cancelTimeout)(timer);
				if(iterator.hasNext()) timer = createTimer();
			}
			timer = createTimer();
			return stream;
		}
		
	}
}
