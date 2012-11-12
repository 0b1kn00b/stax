package stx {
	import stx.Eithers;
	import stx.reactive.Then;
	import stx.reactive.F1A;
	import stx.Option;
	import stx.Options;
	import stx.reactive.Viaz;
	import stx.error.NullReferenceError;
	import stx.Future;
	import stx.reactive.Arrow;
	import stx.Either;
	import flash.Boot;
	public class Promise {
		public function Promise(cancel : stx.reactive.Arrow = null) : void { if( !flash.Boot.skip_constructor ) {
			this.done = false;
			this.fut = new stx.Future();
			this.err = stx.Option.None;
			if(cancel != null) this.onError(cancel);
		}}
		
		public function toCallback(cb : Function) : * {
			if(cb == null) throw new stx.error.NullReferenceError("cb",{ fileName : "Promise.hx", lineNumber : 255, className : "stx.Promise", methodName : "toCallback"});
			this.deliverTo(function(b : *) : void {
				cb(null,b);
			});
			this.onError(stx.reactive.F1A.lift(function(x : *) : * {
				cb(x,null);
				return x;
			}));
			return this;
		}
		
		public function cancel() : void {
			this.fut.cancel();
		}
		
		public function flatMap(f : Function) : stx.Promise {
			var nf : stx.Promise = new stx.Promise();
			nf.err = this.err;
			this.onError(stx.reactive.F1A.lift(function(x : *) : * {
				nf.onCancel(x);
				return x;
			}));
			this.fut.deliverTo(function(either : stx.Either) : void {
				{
					var $e : enum = (either);
					switch( $e.index ) {
					case 1:
					var result : * = $e.params[0];
					{
						var op : stx.Promise = f(result);
						op.onError(stx.reactive.F1A.lift(function(x1 : *) : * {
							nf.onCancel(x1);
							return x1;
						}));
						op.deliverTo(function(r : *) : void {
							nf.resolve(stx.Either.Right(r),{ fileName : "Promise.hx", lineNumber : 209, className : "stx.Promise", methodName : "flatMap"});
						});
					}
					break;
					case 0:
					var msg : * = $e.params[0];
					break;
					}
				}
			});
			return nf;
		}
		
		public function map(f : Function) : stx.Promise {
			var _g : stx.Promise = this;
			var nf : stx.Promise = new stx.Promise();
			var uc : stx.reactive.Arrow = this.userCancel;
			nf.err = this.err;
			this.onError(stx.reactive.F1A.lift(function(x : *) : * {
				nf.onCancel(x);
				return x;
			}));
			this.fut.deliverTo(function(e : stx.Either) : void {
				{
					var $e : enum = (e);
					switch( $e.index ) {
					case 1:
					var t : * = $e.params[0];
					nf.right(f(t));
					break;
					case 0:
					var msg : * = $e.params[0];
					_g.onCancel(msg);
					break;
					}
				}
			});
			return nf;
		}
		
		public function right(b : *) : stx.Promise {
			this.resolve(stx.Either.Right(b),{ fileName : "Promise.hx", lineNumber : 157, className : "stx.Promise", methodName : "right"});
			return this;
		}
		
		public function left(a : *) : stx.Promise {
			this.resolve(stx.Either.Left(a),{ fileName : "Promise.hx", lineNumber : 150, className : "stx.Promise", methodName : "left"});
			return this;
		}
		
		public function resolve(e : stx.Either,pos : * = null) : void {
			this.fut.deliver(e,pos);
			{
				var $e : enum = (e);
				switch( $e.index ) {
				case 0:
				var v : * = $e.params[0];
				if(!this.isDone()) this.onCancel(v);
				break;
				default:
				break;
				}
			}
		}
		
		public function deliverTo(cb : Function) : stx.Promise {
			var _g : stx.Promise = this;
			this.fut.deliverTo(function(e : stx.Either) : void {
				{
					var $e : enum = (e);
					switch( $e.index ) {
					case 1:
					var v : * = $e.params[0];
					cb(v);
					break;
					case 0:
					var v1 : * = $e.params[0];
					_g.onCancel(v1);
					break;
					}
				}
			});
			return this;
		}
		
		public function error() : stx.Option {
			return this.err;
		}
		
		public function onError(cb : stx.reactive.Arrow) : stx.Promise {
			if(cb == null) throw new stx.error.NullReferenceError("cb",{ fileName : "Promise.hx", lineNumber : 88, className : "stx.Promise", methodName : "onError"});
			if(this.userCancel == null) this.userCancel = cb;
			else this.userCancel = stx.reactive.Then.then(this.userCancel,cb);
			{
				var $e : enum = (this.err);
				switch( $e.index ) {
				case 1:
				var v : * = $e.params[0];
				{
					{
						var $e2 : enum = (this.err);
						switch( $e2.index ) {
						case 1:
						var v1 : * = $e2.params[0];
						{
							this.err = stx.Option.Some(v1);
							if(this.userCancel != null) stx.reactive.Viaz.run(this.userCancel,v1);
						}
						break;
						default:
						break;
						}
					}
				}
				break;
				default:
				break;
				}
			}
			return this;
		}
		
		public function future() : stx.Future {
			return this.fut;
		}
		
		public function foreach(f : Function) : stx.Promise {
			return this.deliverTo(f);
		}
		
		protected function onCancel(e : *) : void {
			if(this.isDone()) return;
			this.err = stx.Option.Some(e);
			if(this.userCancel != null) stx.reactive.Viaz.run(this.userCancel,e);
			this.done = true;
		}
		
		public function isDone() : Boolean {
			return this.fut.isDone() && this.done;
		}
		
		public function toString() : String {
			return "Promise";
		}
		
		protected var err : stx.Option;
		protected var done : Boolean;
		public var userCancel : stx.reactive.Arrow;
		protected var fut : stx.Future;
		static public var count : int = 0;
		static public function success(value : *) : stx.Promise {
			var o : stx.Promise = new stx.Promise();
			o.right(value);
			return o;
		}
		
		static public function failure(value : *) : stx.Promise {
			var o : stx.Promise = new stx.Promise();
			o.left(value);
			return o;
		}
		
		static public function fromCallback(promise : stx.Promise) : Function {
			return function(err : *,val : *) : void {
				if(err != null) promise.left(err);
				else promise.right(val);
			}
		}
		
		static public function waitFor(toJoin : Array) : stx.Promise {
			var f0 : Boolean = false;
			var oc : stx.Promise = new stx.Promise(), results : Array = [];
			Prelude.SArrays.foreach(toJoin,function(x : stx.Promise) : void {
				x.onError(stx.reactive.F1A.lift(function(x1 : *) : * {
					if(oc.userCancel != null && !f0) f0 = true;
					return x1;
				}));
			});
			stx.Future.waitFor(Prelude.SArrays.map(toJoin,function(promise : stx.Promise) : stx.Future {
				return promise.future();
			})).deliverTo(function(aoc : Array) : void {
				var failed : Boolean = false;
				Prelude.SArrays.foreach(aoc,function(el : stx.Either) : void {
					if(!failed) {
						if(stx.Eithers.isLeft(el)) {
							failed = true;
							oc.resolve(stx.Either.Left(stx.Options.get(stx.Eithers.left(el))),{ fileName : "Promise.hx", lineNumber : 294, className : "stx.Promise", methodName : "waitFor"});
							return;
						}
						results.push(stx.Options.get(stx.Eithers.right(el)));
					}
				});
				if(!failed) oc.resolve(stx.Either.Right(results),{ fileName : "Promise.hx", lineNumber : 301, className : "stx.Promise", methodName : "waitFor"});
			});
			return oc;
		}
		
	}
}
