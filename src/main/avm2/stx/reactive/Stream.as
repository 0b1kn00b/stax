package stx.reactive {
	import stx.reactive.Signal;
	import stx.reactive.Pulse;
	import stx.reactive.External;
	import flash.Boot;
	import stx.reactive._Reactive.PriorityQueue;
	import stx.reactive.Streams;
	import stx.reactive.Stamp;
	import stx.Tuple2;
	import stx.Tuple3;
	import stx.plus.Equal;
	import stx.Tuple4;
	import stx.Iterables;
	import stx.Tuple5;
	import stx.reactive.StreamStream;
	import stx.reactive.Rank;
	import stx.reactive.Propagation;
	import stx.reactive.Signals;
	import stx.Tuples;
	public class Stream {
		public function Stream(updater : Function = null,sources : Array = null) : void { if( !flash.Boot.skip_constructor ) {
			this._updater = updater;
			this._sendsTo = [];
			this._weak = false;
			this._rank = stx.reactive.Rank.nextRank();
			this._cleanups = [];
			if(sources != null) {
				var _g : int = 0;
				while(_g < sources.length) {
					var source : stx.reactive.Stream = sources[_g];
					++_g;
					source.attachListener(this);
				}
			}
		}}
		
		public function getWeaklyHeld() : Boolean {
			return this._weak;
		}
		
		public function setWeaklyHeld(held : Boolean) : Boolean {
			if(this._weak != held) {
				this._weak = held;
				if(!held) {
					{
						var _g : int = 0, _g1 : Array = this._cleanups;
						while(_g < _g1.length) {
							var cleanup : Function = _g1[_g];
							++_g;
							cleanup();
						}
					}
					this._cleanups = [];
				}
			}
			return this._weak;
		}
		
		protected function propagatePulse(pulse : stx.reactive.Pulse) : void {
			var queue : stx.reactive._Reactive.PriorityQueue = new stx.reactive._Reactive.PriorityQueue();
			var self : stx.reactive.Stream = (function($this:Stream) : stx.reactive.Stream {
				var $r : stx.reactive.Stream;
				var $t : stx.reactive.Stream = $this;
				if(Std._is($t,stx.reactive.Stream)) (($t) as stx.reactive.Stream);
				else throw "Class cast error";
				$r = $t;
				return $r;
			}(this));
			queue.insert({ k : this._rank, v : { stream : self, pulse : pulse}});
			while(queue.length() > 0) {
				var qv : * = queue.pop();
				var stream : stx.reactive.Stream = qv.v.stream;
				var pulse1 : stx.reactive.Pulse = qv.v.pulse;
				var propagation : stx.reactive.Propagation = (stream._updater)(pulse1);
				{
					var $e2 : enum = (propagation);
					switch( $e2.index ) {
					case 0:
					var nextPulse : stx.reactive.Pulse = $e2.params[0];
					{
						var weaklyHeld : Boolean = true;
						{
							var _g : int = 0, _g1 : Array = stream._sendsTo;
							while(_g < _g1.length) {
								var recipient : stx.reactive.Stream = _g1[_g];
								++_g;
								weaklyHeld = weaklyHeld && recipient.getWeaklyHeld();
								queue.insert({ k : recipient._rank, v : { stream : (function($this:Stream) : stx.reactive.Stream {
									var $r3 : stx.reactive.Stream;
									var $t : stx.reactive.Stream = recipient;
									if(Std._is($t,stx.reactive.Stream)) (($t) as stx.reactive.Stream);
									else throw "Class cast error";
									$r3 = $t;
									return $r3;
								}(this)), pulse : nextPulse}});
							}
						}
						if(stream._sendsTo.length > 0 && weaklyHeld) stream.setWeaklyHeld(true);
					}
					break;
					case 1:
					break;
					}
				}
			}
		}
		
		public function unique(eq : Function = null) : stx.reactive.Stream {
			return this.uniqueSteps().uniqueEvents(eq);
		}
		
		public function uniqueEvents(eq : Function = null) : stx.reactive.Stream {
			if(eq == null) eq = function(e1 : *,e2 : *) : Boolean {
				return e1 == e2;
			}
			var lastEvent : * = null;
			return stx.reactive.Streams.create(function(pulse : stx.reactive.Pulse) : stx.reactive.Propagation {
				return ((lastEvent == null || !eq(pulse.value,lastEvent))?function() : stx.reactive.Propagation {
					var $r : stx.reactive.Propagation;
					lastEvent = pulse.value;
					$r = stx.reactive.Propagation.propagate(pulse);
					return $r;
				}():stx.reactive.Propagation.doNotPropagate);
			},[this]);
		}
		
		public function uniqueSteps() : stx.reactive.Stream {
			var lastStamp : int = -1;
			return stx.reactive.Streams.create(function(pulse : stx.reactive.Pulse) : stx.reactive.Propagation {
				return ((pulse.stamp != lastStamp)?function() : stx.reactive.Propagation {
					var $r : stx.reactive.Propagation;
					lastStamp = pulse.stamp;
					$r = stx.reactive.Propagation.propagate(pulse);
					return $r;
				}():stx.reactive.Propagation.doNotPropagate);
			},[this]);
		}
		
		public function merge(that : stx.reactive.Stream) : stx.reactive.Stream {
			return stx.reactive.Streams.create(function(p : stx.reactive.Pulse) : stx.reactive.Propagation {
				return stx.reactive.Propagation.propagate(p);
			},[this,that]);
		}
		
		public function groupBy(eq : Function) : stx.reactive.Stream {
			var prev : * = null;
			var cur : Array = [];
			return stx.reactive.Streams.create(function(pulse : stx.reactive.Pulse) : stx.reactive.Propagation {
				var ret : stx.reactive.Propagation = stx.reactive.Propagation.doNotPropagate;
				if(prev != null) {
					if(!eq(prev,pulse.value)) {
						var iter : * = cur;
						ret = stx.reactive.Propagation.propagate(pulse.withValue(iter));
						cur = [];
						cur.push(pulse.value);
						prev = null;
					}
					else cur.push(pulse.value);
				}
				else cur.push(pulse.value);
				prev = pulse.value;
				return ret;
			},[this]);
		}
		
		public function group() : stx.reactive.Stream {
			return this.groupBy(function(e1 : *,e2 : *) : Boolean {
				return e1 == e2;
			});
		}
		
		public function zip5(_as : stx.reactive.Stream,bs : stx.reactive.Stream,cs : stx.reactive.Stream,ds : stx.reactive.Stream) : stx.reactive.Stream {
			var streams : Array = [];
			streams.push(this);
			streams.push(_as);
			streams.push(bs);
			streams.push(cs);
			streams.push(ds);
			return stx.reactive.Streams.zipN(streams).map(function(i : *) : stx.Tuple5 {
				return stx.Tuples.t5(stx.Iterables.at(i,0),stx.Iterables.at(i,1),stx.Iterables.at(i,2),stx.Iterables.at(i,3),stx.Iterables.at(i,4));
			});
		}
		
		public function zip4(_as : stx.reactive.Stream,bs : stx.reactive.Stream,cs : stx.reactive.Stream) : stx.reactive.Stream {
			var streams : Array = [];
			streams.push(this);
			streams.push(_as);
			streams.push(bs);
			streams.push(cs);
			return stx.reactive.Streams.zipN(streams).map(function(i : *) : stx.Tuple4 {
				return stx.Tuples.t4(stx.Iterables.at(i,0),stx.Iterables.at(i,1),stx.Iterables.at(i,2),stx.Iterables.at(i,3));
			});
		}
		
		public function zip3(_as : stx.reactive.Stream,bs : stx.reactive.Stream) : stx.reactive.Stream {
			var streams : Array = [];
			streams.push(this);
			streams.push(_as);
			streams.push(bs);
			return stx.reactive.Streams.zipN(streams).map(function(i : *) : stx.Tuple3 {
				return stx.Tuples.t3(stx.Iterables.at(i,0),stx.Iterables.at(i,1),stx.Iterables.at(i,2));
			});
		}
		
		public function zip(_as : stx.reactive.Stream) : stx.reactive.Stream {
			return this.zipWith(_as,stx.Tuples.t2);
		}
		
		public function zipWith(_as : stx.reactive.Stream,f : Function) : stx.reactive.Stream {
			var testStamp : int = -1;
			var value1 : * = null;
			stx.reactive.Streams.create(function(pulse : stx.reactive.Pulse) : stx.reactive.Propagation {
				testStamp = pulse.stamp;
				value1 = pulse.value;
				return stx.reactive.Propagation.doNotPropagate;
			},[this]);
			return stx.reactive.Streams.create(function(pulse1 : stx.reactive.Pulse) : stx.reactive.Propagation {
				return ((testStamp == pulse1.stamp)?stx.reactive.Propagation.propagate(pulse1.withValue(f(value1,pulse1.value))):stx.reactive.Propagation.doNotPropagate);
			},[_as]);
		}
		
		public function filterWhile(pred : Function) : stx.reactive.Stream {
			var checking : Boolean = true;
			var self : stx.reactive.Stream = this;
			return stx.reactive.Streams.create(function(pulse : stx.reactive.Pulse) : stx.reactive.Propagation {
				return ((checking)?((pred(pulse.value))?stx.reactive.Propagation.propagate(pulse):function() : stx.reactive.Propagation {
					var $r : stx.reactive.Propagation;
					checking = false;
					self.setWeaklyHeld(true);
					$r = stx.reactive.Propagation.doNotPropagate;
					return $r;
				}()):stx.reactive.Propagation.doNotPropagate);
			},[this]);
		}
		
		public function filter(pred : Function) : stx.reactive.Stream {
			return stx.reactive.Streams.create(function(pulse : stx.reactive.Pulse) : stx.reactive.Propagation {
				return ((pred(pulse.value))?stx.reactive.Propagation.propagate(pulse):stx.reactive.Propagation.doNotPropagate);
			},[this]);
		}
		
		public function partitionWhile(pred : Function) : stx.Tuple2 {
			var trueStream : stx.reactive.Stream = this.takeWhile(pred);
			var falseStream : stx.reactive.Stream = this.dropWhile(pred);
			return stx.Tuples.t2(trueStream,falseStream);
		}
		
		public function partition(pred : Function) : stx.Tuple2 {
			var trueStream : stx.reactive.Stream = stx.reactive.Streams.create(function(pulse : stx.reactive.Pulse) : stx.reactive.Propagation {
				return ((pred(pulse.value))?stx.reactive.Propagation.propagate(pulse):stx.reactive.Propagation.doNotPropagate);
			},[this]);
			var falseStream : stx.reactive.Stream = stx.reactive.Streams.create(function(pulse1 : stx.reactive.Pulse) : stx.reactive.Propagation {
				return ((!pred(pulse1.value))?stx.reactive.Propagation.propagate(pulse1):stx.reactive.Propagation.doNotPropagate);
			},[this]);
			return stx.Tuples.t2(trueStream,falseStream);
		}
		
		public function dropWhile(pred : Function) : stx.reactive.Stream {
			var checking : Boolean = true;
			return stx.reactive.Streams.create(function(pulse : stx.reactive.Pulse) : stx.reactive.Propagation {
				return ((checking)?((pred(pulse.value))?stx.reactive.Propagation.doNotPropagate:function() : stx.reactive.Propagation {
					var $r : stx.reactive.Propagation;
					checking = false;
					$r = stx.reactive.Propagation.propagate(pulse);
					return $r;
				}()):stx.reactive.Propagation.propagate(pulse));
			},[this]);
		}
		
		public function drop(n : int) : stx.reactive.Stream {
			var count : int = n;
			return stx.reactive.Streams.create(function(pulse : stx.reactive.Pulse) : stx.reactive.Propagation {
				return ((count > 0)?function() : stx.reactive.Propagation {
					var $r : stx.reactive.Propagation;
					--count;
					$r = stx.reactive.Propagation.doNotPropagate;
					return $r;
				}():stx.reactive.Propagation.propagate(pulse));
			},[this]);
		}
		
		public function shiftWith(elements : *) : stx.reactive.Stream {
			var queue : Array = Prelude.SIterables.toArray(elements);
			var n : int = queue.length;
			return stx.reactive.Streams.create(function(pulse : stx.reactive.Pulse) : stx.reactive.Propagation {
				queue.push(pulse.value);
				return ((queue.length <= n)?stx.reactive.Propagation.doNotPropagate:stx.reactive.Propagation.propagate(pulse.withValue(queue.shift())));
			},[this]);
		}
		
		public function shiftWhile(pred : Function) : stx.reactive.Stream {
			var queue : Array = [];
			var checking : Boolean = true;
			return stx.reactive.Streams.create(function(pulse : stx.reactive.Pulse) : stx.reactive.Propagation {
				queue.push(pulse.value);
				return ((checking)?((pred(pulse.value))?stx.reactive.Propagation.doNotPropagate:function() : stx.reactive.Propagation {
					var $r : stx.reactive.Propagation;
					checking = false;
					$r = stx.reactive.Propagation.propagate(pulse.withValue(queue.shift()));
					return $r;
				}()):stx.reactive.Propagation.propagate(pulse.withValue(queue.shift())));
			},[this]);
		}
		
		public function shift(n : int) : stx.reactive.Stream {
			var queue : Array = [];
			return stx.reactive.Streams.create(function(pulse : stx.reactive.Pulse) : stx.reactive.Propagation {
				queue.push(pulse.value);
				return ((queue.length <= n)?stx.reactive.Propagation.doNotPropagate:stx.reactive.Propagation.propagate(pulse.withValue(queue.shift())));
			},[this]);
		}
		
		public function takeWhile(filter : Function) : stx.reactive.Stream {
			var stillChecking : Boolean = true;
			var self : stx.reactive.Stream = this;
			return stx.reactive.Streams.create(function(pulse : stx.reactive.Pulse) : stx.reactive.Propagation {
				return ((stillChecking)?((filter(pulse.value))?stx.reactive.Propagation.propagate(pulse):function() : stx.reactive.Propagation {
					var $r : stx.reactive.Propagation;
					stillChecking = false;
					self.setWeaklyHeld(true);
					$r = stx.reactive.Propagation.doNotPropagate;
					return $r;
				}()):stx.reactive.Propagation.doNotPropagate);
			},[this]);
		}
		
		public function take(n : int) : stx.reactive.Stream {
			var count : int = n;
			var self : stx.reactive.Stream = this;
			return stx.reactive.Streams.create(function(pulse : stx.reactive.Pulse) : stx.reactive.Propagation {
				return ((count > 0)?function() : stx.reactive.Propagation {
					var $r : stx.reactive.Propagation;
					--count;
					$r = stx.reactive.Propagation.propagate(pulse);
					return $r;
				}():function() : stx.reactive.Propagation {
					var $r2 : stx.reactive.Propagation;
					self.setWeaklyHeld(true);
					$r2 = stx.reactive.Propagation.doNotPropagate;
					return $r2;
				}());
			},[this]);
		}
		
		public function scanlP(folder : Function) : stx.reactive.Stream {
			var acc : * = null;
			return this.map(function(n : *) : * {
				var next : *;
				if(acc != null) next = folder(acc,n);
				else next = n;
				acc = next;
				return next;
			});
		}
		
		public function scanl(initial : *,folder : Function) : stx.reactive.Stream {
			var acc : * = initial;
			return this.map(function(n : *) : * {
				var next : * = folder(acc,n);
				acc = next;
				return next;
			});
		}
		
		public function flatMap(mapper : Function) : stx.reactive.Stream {
			return this.bind(mapper);
		}
		
		public function map(mapper : Function) : stx.reactive.Stream {
			return stx.reactive.Streams.create(function(pulse : stx.reactive.Pulse) : stx.reactive.Propagation {
				return stx.reactive.Propagation.propagate(pulse.map(mapper));
			},[this]);
		}
		
		public function filterRepeatsBy(optStart : * = null,eq : Function) : stx.reactive.Stream {
			var hadFirst : Boolean = ((optStart == null)?false:true);
			var prev : * = optStart;
			return this.filter(function(v : *) : Boolean {
				return ((!hadFirst || !eq(prev,v))?function() : Boolean {
					var $r : Boolean;
					hadFirst = true;
					prev = v;
					$r = true;
					return $r;
				}():false);
			});
		}
		
		public function filterRepeats(optStart : * = null) : stx.reactive.Stream {
			return this.filterRepeatsBy(optStart,function(v1 : *,v2 : *) : Boolean {
				return (stx.plus.Equal.getEqualFor(v1))(v1,v2);
			});
		}
		
		public function snapshot(value : stx.reactive.Signal) : stx.reactive.Stream {
			return this.map(function(t : *) : * {
				return value.valueNow();
			});
		}
		
		public function blindS(time : stx.reactive.Signal) : stx.reactive.Stream {
			var lastSent : Number = (stx.reactive.External.now)() - time.valueNow() - 1;
			return stx.reactive.Streams.create(function(p : stx.reactive.Pulse) : stx.reactive.Propagation {
				var curTime : Number = (stx.reactive.External.now)();
				if(curTime - lastSent > time.valueNow()) {
					lastSent = curTime;
					return stx.reactive.Propagation.propagate(p);
				}
				else return stx.reactive.Propagation.doNotPropagate;
				return null;
			},[this]);
		}
		
		public function blind(time : int) : stx.reactive.Stream {
			return this.blindS(stx.reactive.Signals.constant(time));
		}
		
		public function startsWith(init : *) : stx.reactive.Signal {
			return new stx.reactive.Signal(this,init,function(pulse : stx.reactive.Pulse) : stx.reactive.Propagation {
				return stx.reactive.Propagation.propagate(pulse);
			});
		}
		
		public function calmS(time : stx.reactive.Signal) : stx.reactive.Stream {
			var out : stx.reactive.Stream = stx.reactive.Streams.pure();
			var towards : * = null;
			stx.reactive.Streams.create(function(pulse : stx.reactive.Pulse) : stx.reactive.Propagation {
				if(towards != null) (stx.reactive.External.cancelTimeout)(towards);
				towards = stx.reactive.External.setTimeout(function() : void {
					towards = null;
					out.sendEvent(pulse.value);
				},time.valueNow());
				return stx.reactive.Propagation.doNotPropagate;
			},[this]);
			return out;
		}
		
		public function calm(time : int) : stx.reactive.Stream {
			return this.calmS(stx.reactive.Signals.constant(time));
		}
		
		public function delayS(time : stx.reactive.Signal) : stx.reactive.Stream {
			var self : stx.reactive.Stream = this;
			var receiverEE : stx.reactive.Stream = stx.reactive.Streams.pure();
			var link : * = { from : self, towards : self.delay(time.valueNow())}
			var switcherE : stx.reactive.Stream = stx.reactive.Streams.create(function(pulse : stx.reactive.Pulse) : stx.reactive.Propagation {
				link.from.removeListener(link.towards);
				link = { from : self, towards : self.delay(pulse.value)}
				receiverEE.sendEvent(link.towards);
				return stx.reactive.Propagation.doNotPropagate;
			},[time.changes()]);
			var resE : stx.reactive.Stream = stx.reactive.StreamStream.flatten(receiverEE);
			switcherE.sendEvent(time.valueNow());
			return resE;
		}
		
		public function delay(time : int) : stx.reactive.Stream {
			var resE : stx.reactive.Stream = stx.reactive.Streams.pure();
			stx.reactive.Streams.create(function(pulse : stx.reactive.Pulse) : stx.reactive.Propagation {
				resE.sendLaterIn(pulse.value,time);
				return stx.reactive.Propagation.doNotPropagate;
			},[this]);
			return resE;
		}
		
		public function sendLater(value : *) : stx.reactive.Stream {
			return this.sendLaterIn(value,0);
		}
		
		public function sendLaterIn(value : *,millis : int) : stx.reactive.Stream {
			var self : stx.reactive.Stream = this;
			stx.reactive.External.setTimeout(function() : void {
				self.sendEvent(value);
			},millis);
			return this;
		}
		
		public function sendEventTyped(value : *) : stx.reactive.Stream {
			this.propagatePulse(new stx.reactive.Pulse(stx.reactive.Stamp.nextStamp(),value));
			return this;
		}
		
		public function sendEvent(value : *) : stx.reactive.Stream {
			this.propagatePulse(new stx.reactive.Pulse(stx.reactive.Stamp.nextStamp(),value));
			return this;
		}
		
		public function bind(k : Function) : stx.reactive.Stream {
			var m : stx.reactive.Stream = this;
			var prevE : stx.reactive.Stream = null;
			var outE : stx.reactive.Stream = stx.reactive.Streams.pure();
			var inE : stx.reactive.Stream = stx.reactive.Streams.create(function(pulse : stx.reactive.Pulse) : stx.reactive.Propagation {
				var first : Boolean = prevE == null;
				if(prevE != null) prevE.removeListener(outE,true);
				prevE = k(pulse.value);
				prevE.attachListener(outE);
				return stx.reactive.Propagation.doNotPropagate;
			},[m]);
			return outE;
		}
		
		public function constant(value : *) : stx.reactive.Stream {
			return this.map(function(v : *) : * {
				return value;
			});
		}
		
		public function toArray() : Array {
			var array : Array = [];
			this._each(function(e : *) : void {
				array.push(e);
			});
			return array;
		}
		
		public function _each(f : Function) : stx.reactive.Stream {
			return this.foreach(f);
		}
		
		public function foreach(f : Function) : stx.reactive.Stream {
			stx.reactive.Streams.create(function(pulse : stx.reactive.Pulse) : stx.reactive.Propagation {
				f(pulse.value);
				return stx.reactive.Propagation.doNotPropagate;
			},[this]);
			return this;
		}
		
		public function whenFinishedDo(f : Function) : void {
			if(this.getWeaklyHeld()) f();
			else this._cleanups.push(f);
		}
		
		public function removeListener(dependent : stx.reactive.Stream,isWeakReference : Boolean = false) : Boolean {
			var foundSending : Boolean = false;
			{
				var _g1 : int = 0, _g : int = this._sendsTo.length;
				while(_g1 < _g) {
					var i : int = _g1++;
					if(this._sendsTo[i] == dependent) {
						this._sendsTo.splice(i,1);
						foundSending = true;
						break;
					}
				}
			}
			if(isWeakReference && this._sendsTo.length == 0) this.setWeaklyHeld(true);
			return foundSending;
		}
		
		public function attachListener(dependent : stx.reactive.Stream) : void {
			this._sendsTo.push(dependent);
			if(this._rank > dependent._rank) {
				var lowest : int = stx.reactive.Rank.lastRank() + 1;
				var q : Array = [dependent];
				while(q.length > 0) {
					var cur : stx.reactive.Stream = q.splice(0,1)[0];
					cur._rank = stx.reactive.Rank.nextRank();
					q = q.concat(cur._sendsTo);
				}
			}
		}
		
		protected var _cleanups : Array;
		public function get weaklyHeld() : Boolean { return getWeaklyHeld(); }
		public function set weaklyHeld( __v : Boolean ) : void { setWeaklyHeld(__v); }
		protected var $weaklyHeld : Boolean;
		protected var _weak : Boolean;
		protected var _updater : Function;
		protected var _sendsTo : Array;
		protected var _rank : int;
	}
}
