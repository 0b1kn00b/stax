package stx {
	import stx.error.Positions;
	import stx.Option;
	import stx.Options;
	import stx.Dynamics;
	import stx.Tuples;
	import flash.Boot;
	public class Future {
		public function Future() : void { if( !flash.Boot.skip_constructor ) {
			this._listeners = [];
			this._result = null;
			this._isSet = false;
			this._isCanceled = false;
			this._cancelers = [];
			this._canceled = [];
		}}
		
		public function deliverMe(f : Function) : stx.Future {
			var _g : stx.Future = this;
			if(this.isCanceled()) return this;
			else if(this.isDelivered()) f(this);
			else this._listeners.push(function(g : *) : void {
				f(_g);
			});
			return this;
		}
		
		protected function forceCancel() : stx.Future {
			if(!this._isCanceled) {
				this._isCanceled = true;
				{
					var _g : int = 0, _g1 : Array = this._canceled;
					while(_g < _g1.length) {
						var canceled : Function = _g1[_g];
						++_g;
						canceled();
					}
				}
			}
			return this;
		}
		
		public function toArray() : Array {
			return stx.Options.toArray(this.value());
		}
		
		public function toOption() : stx.Option {
			return this.value();
		}
		
		public function value() : stx.Option {
			return ((this._isSet)?stx.Option.Some(this._result):stx.Option.None);
		}
		
		public function zipWith(f2 : stx.Future,fn : Function) : stx.Future {
			var zipped : stx.Future = new stx.Future();
			var f1 : stx.Future = this;
			var deliverZip : Function = function() : void {
				if(f1.isDelivered() && f2.isDelivered()) zipped.deliver(fn(stx.Options.get(f1.value()),stx.Options.get(f2.value())),{ fileName : "Future.hx", lineNumber : 232, className : "stx.Future", methodName : "zipWith"});
			}
			f1.deliverTo(function(v : *) : void {
				deliverZip();
			});
			f2.deliverTo(function(v1 : *) : void {
				deliverZip();
			});
			zipped.allowCancelOnlyIf(function() : Boolean {
				return f1.cancel() || f2.cancel();
			});
			f1.ifCanceled(function() : void {
				zipped.forceCancel();
			});
			f2.ifCanceled(function() : void {
				zipped.forceCancel();
			});
			return zipped;
		}
		
		public function zip(f2 : stx.Future) : stx.Future {
			return this.zipWith(f2,stx.Tuples.t2);
		}
		
		public function filter(f : Function) : stx.Future {
			var fut : stx.Future = new stx.Future();
			this.deliverTo(function(t : *) : void {
				if(f(t)) fut.deliver(t,{ fileName : "Future.hx", lineNumber : 210, className : "stx.Future", methodName : "filter"});
				else fut.forceCancel();
			});
			this.ifCanceled(function() : void {
				fut.forceCancel();
			});
			return fut;
		}
		
		public function flatMap(f : Function) : stx.Future {
			var fut : stx.Future = new stx.Future();
			this.deliverTo(function(t : *) : void {
				f(t).deliverTo(function(s : *) : void {
					fut.deliver(s,{ fileName : "Future.hx", lineNumber : 192, className : "stx.Future", methodName : "flatMap"});
				}).ifCanceled(function() : void {
					fut.forceCancel();
				});
			});
			this.ifCanceled(function() : void {
				fut.forceCancel();
			});
			return fut;
		}
		
		public function then(f : stx.Future) : stx.Future {
			return f;
		}
		
		public function map(f : Function) : stx.Future {
			var fut : stx.Future = new stx.Future();
			this.deliverTo(function(t : *) : void {
				fut.deliver(f(t),{ fileName : "Future.hx", lineNumber : 163, className : "stx.Future", methodName : "map"});
			});
			this.ifCanceled(function() : void {
				fut.forceCancel();
			});
			return fut;
		}
		
		public function foreach(f : Function) : stx.Future {
			return this.deliverTo(f);
		}
		
		public function deliverTo(f : Function) : stx.Future {
			if(this.isCanceled()) return this;
			else if(this.isDelivered()) f(this._result);
			else this._listeners.push(f);
			return this;
		}
		
		public function isCanceled() : Boolean {
			return this._isCanceled;
		}
		
		public function isDelivered() : Boolean {
			return this._isSet;
		}
		
		public function isDone() : Boolean {
			return this.isDelivered() || this.isCanceled();
		}
		
		public function cancel() : Boolean {
			return ((this.isDone())?false:((this.isCanceled())?true:(function($this:Future) : Boolean {
				var $r : Boolean;
				var r : Boolean = true;
				{
					var _g : int = 0, _g1 : Array = $this._cancelers;
					while(_g < _g1.length) {
						var canceller : Function = _g1[_g];
						++_g;
						r = r && canceller();
					}
				}
				if(r) $this.forceCancel();
				$r = r;
				return $r;
			}(this))));
		}
		
		public function ifCanceled(f : Function) : stx.Future {
			if(this.isCanceled()) f();
			else if(!this.isDone()) this._canceled.push(f);
			return this;
		}
		
		public function allowCancelOnlyIf(f : Function) : stx.Future {
			if(!this.isDone()) this._cancelers.push(f);
			return this;
		}
		
		public function deliver(t : *,pos : * = null) : stx.Future {
			return ((this._isCanceled)?this:((this._isSet)?Prelude.error("Future :" + Std.string(this.value()) + " already delivered at " + stx.error.Positions.toString(pos),{ fileName : "Future.hx", lineNumber : 58, className : "stx.Future", methodName : "deliver"}):(function($this:Future) : stx.Future {
				var $r : stx.Future;
				$this._result = t;
				$this._isSet = true;
				{
					var _g : int = 0, _g1 : Array = $this._listeners;
					while(_g < _g1.length) {
						var l : Function = _g1[_g];
						++_g;
						l($this._result);
					}
				}
				$this._listeners = [];
				$r = $this;
				return $r;
			}(this))));
		}
		
		public function isEmpty() : Boolean {
			return this._listeners.length == 0;
		}
		
		protected var _canceled : Array;
		protected var _cancelers : Array;
		protected var _isCanceled : Boolean;
		protected var _isSet : Boolean;
		protected var _result : *;
		protected var _listeners : Array;
		static public function dead() : stx.Future {
			return stx.Dynamics.withEffect(new stx.Future(),function(future : stx.Future) : void {
				future.cancel();
			});
		}
		
		static public function create() : stx.Future {
			return new stx.Future();
		}
		
		static public function toFuture(t : *) : stx.Future {
			return stx.Future.create().deliver(t,{ fileName : "Future.hx", lineNumber : 276, className : "stx.Future", methodName : "toFuture"});
		}
		
		static public function waitFor(toJoin : Array) : stx.Future {
			var joinLen : int = Prelude.SArrays.size(toJoin), myprm : stx.Future = stx.Future.create(), combined : Array = [], sequence : int = 0;
			Prelude.SArrays.foreach(toJoin,function(xprm : *) : void {
				if(!Std._is(xprm,stx.Future)) throw "not a promise:" + Std.string(xprm);
				xprm.sequence = sequence++;
				xprm.deliverMe(function(r : *) : void {
					combined.push({ seq : r.sequence, val : r._result});
					if(combined.length == joinLen) {
						combined.sort(function(x : *,y : *) : int {
							return x.seq - y.seq;
						});
						myprm.deliver(Prelude.SArrays.map(combined,function(el : *) : * {
							return el.val;
						}),{ fileName : "Future.hx", lineNumber : 305, className : "stx.Future", methodName : "waitFor"});
					}
				});
			});
			return myprm;
		}
		
	}
}
