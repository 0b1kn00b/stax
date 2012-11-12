package stx.reactive {
	import stx.reactive.Stream;
	import stx.reactive.Propagation;
	import stx.reactive.Streams;
	import stx.reactive.Signals;
	import stx.reactive.Pulse;
	import stx.Tuple3;
	import stx.Iterables;
	import stx.Tuple4;
	import stx.Tuples;
	import stx.Tuple5;
	import flash.Boot;
	public class Signal {
		public function Signal(stream : stx.reactive.Stream = null,init : * = null,updater : Function = null) : void { if( !flash.Boot.skip_constructor ) {
			this._last = init;
			this._underlyingRaw = stream;
			this._updater = updater;
			var self : stx.reactive.Signal = this;
			this._underlying = stx.reactive.Streams.create(function(pulse : stx.reactive.Pulse) : stx.reactive.Propagation {
				return function() : stx.reactive.Propagation {
					var $r : stx.reactive.Propagation;
					{
						var $e2 : enum = (updater(pulse));
						switch( $e2.index ) {
						case 0:
						var newPulse : stx.reactive.Pulse = $e2.params[0];
						$r = function() : stx.reactive.Propagation {
							var $r3 : stx.reactive.Propagation;
							self._last = newPulse.value;
							$r3 = stx.reactive.Propagation.propagate(newPulse);
							return $r3;
						}();
						break;
						case 1:
						$r = stx.reactive.Propagation.doNotPropagate;
						break;
						}
					}
					return $r;
				}();
			},[stream.uniqueSteps()]);
		}}
		
		public function sendSignalTyped(value : *) : void {
			this.changes().sendEventTyped(value);
		}
		
		public function sendSignal(value : *) : void {
			this.changes().sendEvent(value);
		}
		
		public function nowAndWhenChanges(f : Function) : void {
			this.changes().foreach(f);
			f(this.valueNow());
		}
		
		public function whenChanges(f : Function) : void {
			this.changes().foreach(f);
		}
		
		public function changes() : stx.reactive.Stream {
			return this._underlying;
		}
		
		public function mapC(f : Function) : stx.reactive.Signal {
			return f(this.changes()).startsWith(this.valueNow());
		}
		
		public function valueNow() : * {
			return this._last;
		}
		
		public function delayS(time : stx.reactive.Signal) : stx.reactive.Signal {
			return this.mapC(function(s : stx.reactive.Stream) : stx.reactive.Stream {
				return s.delayS(time);
			});
		}
		
		public function delay(time : int) : stx.reactive.Signal {
			return this.mapC(function(s : stx.reactive.Stream) : stx.reactive.Stream {
				return s.delay(time);
			});
		}
		
		public function blindS(time : stx.reactive.Signal) : stx.reactive.Signal {
			return this.mapC(function(s : stx.reactive.Stream) : stx.reactive.Stream {
				return s.blindS(time);
			});
		}
		
		public function blind(time : int) : stx.reactive.Signal {
			return this.mapC(function(s : stx.reactive.Stream) : stx.reactive.Stream {
				return s.blind(time);
			});
		}
		
		public function calmS(time : stx.reactive.Signal) : stx.reactive.Signal {
			return this.mapC(function(s : stx.reactive.Stream) : stx.reactive.Stream {
				return s.calmS(time);
			});
		}
		
		public function calm(time : int) : stx.reactive.Signal {
			return this.mapC(function(s : stx.reactive.Stream) : stx.reactive.Stream {
				return s.calm(time);
			});
		}
		
		public function zipN(signals : *) : stx.reactive.Signal {
			var signals1 : * = stx.Iterables.cons(signals,this);
			return stx.reactive.Signals.zipN(signals1);
		}
		
		public function zip5(b2 : stx.reactive.Signal,b3 : stx.reactive.Signal,b4 : stx.reactive.Signal,b5 : stx.reactive.Signal) : stx.reactive.Signal {
			var self : stx.reactive.Signal = this;
			var createTuple : Function = function() : stx.Tuple5 {
				return stx.Tuples.t5(self.valueNow(),b2.valueNow(),b3.valueNow(),b4.valueNow(),b5.valueNow());
			}
			var arr : Array = [this,b2,b3,b4,b5];
			return stx.reactive.Streams.create(function(pulse : stx.reactive.Pulse) : stx.reactive.Propagation {
				return stx.reactive.Propagation.propagate(pulse.withValue(createTuple()));
			},Prelude.SArrays.map(arr,function(b : stx.reactive.Signal) : stx.reactive.Stream {
				return function() : stx.reactive.Stream {
					var $r : stx.reactive.Stream;
					var $t : stx.reactive.Stream = b.changes();
					if(Std._is($t,stx.reactive.Stream)) (($t) as stx.reactive.Stream);
					else throw "Class cast error";
					$r = $t;
					return $r;
				}();
			})).startsWith(createTuple());
		}
		
		public function zip4(b2 : stx.reactive.Signal,b3 : stx.reactive.Signal,b4 : stx.reactive.Signal) : stx.reactive.Signal {
			var self : stx.reactive.Signal = this;
			var createTuple : Function = function() : stx.Tuple4 {
				return stx.Tuples.t4(self.valueNow(),b2.valueNow(),b3.valueNow(),b4.valueNow());
			}
			var arr : Array = [this,b2,b3,b4];
			return stx.reactive.Streams.create(function(pulse : stx.reactive.Pulse) : stx.reactive.Propagation {
				return stx.reactive.Propagation.propagate(pulse.withValue(createTuple()));
			},Prelude.SArrays.map(arr,function(b : stx.reactive.Signal) : stx.reactive.Stream {
				return function() : stx.reactive.Stream {
					var $r : stx.reactive.Stream;
					var $t : stx.reactive.Stream = b.changes();
					if(Std._is($t,stx.reactive.Stream)) (($t) as stx.reactive.Stream);
					else throw "Class cast error";
					$r = $t;
					return $r;
				}();
			})).startsWith(createTuple());
		}
		
		public function zip3(b2 : stx.reactive.Signal,b3 : stx.reactive.Signal) : stx.reactive.Signal {
			var self : stx.reactive.Signal = this;
			var createTuple : Function = function() : stx.Tuple3 {
				return stx.Tuples.t3(self.valueNow(),b2.valueNow(),b3.valueNow());
			}
			var arr : Array = [this,b2,b3];
			return stx.reactive.Streams.create(function(pulse : stx.reactive.Pulse) : stx.reactive.Propagation {
				return stx.reactive.Propagation.propagate(pulse.withValue(createTuple()));
			},Prelude.SArrays.map(arr,function(b : stx.reactive.Signal) : stx.reactive.Stream {
				return function() : stx.reactive.Stream {
					var $r : stx.reactive.Stream;
					var $t : stx.reactive.Stream = b.changes();
					if(Std._is($t,stx.reactive.Stream)) (($t) as stx.reactive.Stream);
					else throw "Class cast error";
					$r = $t;
					return $r;
				}();
			})).startsWith(createTuple());
		}
		
		public function zip(b2 : stx.reactive.Signal) : stx.reactive.Signal {
			return this.zipWith(b2,stx.Tuples.t2);
		}
		
		public function zipWith(b2 : stx.reactive.Signal,f : Function) : stx.reactive.Signal {
			var self : stx.reactive.Signal = this;
			var applyF : Function = function() : * {
				return f(self.valueNow(),b2.valueNow());
			}
			var pulse : Function = function(pulse1 : stx.reactive.Pulse) : stx.reactive.Propagation {
				return stx.reactive.Propagation.propagate(pulse1.withValue(applyF()));
			}
			var arr : Array = [this,b2];
			var out : Array = Prelude.SArrays.map(arr,function(b : stx.reactive.Signal) : stx.reactive.Stream {
				return function() : stx.reactive.Stream {
					var $r : stx.reactive.Stream;
					var $t : stx.reactive.Stream = b.changes();
					if(Std._is($t,stx.reactive.Stream)) (($t) as stx.reactive.Stream);
					else throw "Class cast error";
					$r = $t;
					return $r;
				}();
			});
			return stx.reactive.Streams.create(pulse,out).startsWith(applyF());
		}
		
		public function liftS(f : stx.reactive.Signal) : stx.reactive.Signal {
			return this.changes().map(function(a : *) : * {
				return (f.valueNow())(a);
			}).startsWith((f.valueNow())(this.valueNow()));
		}
		
		public function lift(f : Function) : stx.reactive.Signal {
			return this.changes().map(f).startsWith(f(this.valueNow()));
		}
		
		public function mapS(f : stx.reactive.Signal) : stx.reactive.Signal {
			return this.liftS(f);
		}
		
		public function map(f : Function) : stx.reactive.Signal {
			return this.lift(f);
		}
		
		protected var _last : *;
		protected var _updater : Function;
		protected var _underlying : stx.reactive.Stream;
		protected var _underlyingRaw : stx.reactive.Stream;
	}
}
