package stx.test {
	import stx.test.Assert;
	import stx.test.Assertation;
	import stx.test.TestFixture;
	import haxe.Stack;
	import haxe.Timer;
	import stx.test.Dispatcher;
	import flash.Boot;
	public class TestHandler {
		public function TestHandler(fixture : stx.test.TestFixture = null) : void { if( !flash.Boot.skip_constructor ) {
			if(fixture == null) throw "fixture argument is null";
			this.fixture = fixture;
			this.results = new List();
			this.asyncStack = new List();
			this.onTested = fixture.onTested;
			this.onTimeout = fixture.onTimeout;
			this.onComplete = fixture.onComplete;
		}}
		
		protected function completed() : void {
			try {
				this.executeMethodByName(this.fixture.teardown);
			}
			catch( e : * ){
				this.results.add(stx.test.Assertation.TeardownError(e,stx.test.TestHandler.exceptionStack(2)));
			}
			this.unbindHandler();
			this.onComplete.dispatch(this);
		}
		
		protected function timeout() : void {
			this.results.add(stx.test.Assertation.TimeoutError(this.asyncStack.length,[]));
			this.onTimeout.dispatch(this);
			this.completed();
		}
		
		protected function tested() : void {
			if(this.results.length == 0) this.results.add(stx.test.Assertation.Warning("no assertions"));
			this.onTested.dispatch(this);
			this.completed();
		}
		
		protected function executeMethod(f : Function) : void {
			if(f != null) {
				this.bindHandler();
				f();
			}
		}
		
		protected function executeMethodByName(name : String) : void {
			if(name == null) return;
			var method : * = Reflect.field(this.fixture.target,name);
			if(method != null) {
				this.bindHandler();
				Reflect.callMethod(this.fixture.target,method,[]);
			}
		}
		
		public function addEvent(f : Function,timeout : int = 250) : Function {
			this.asyncStack.add(f);
			var handler : stx.test.TestHandler = this;
			this.setTimeout(timeout);
			return function(e : *) : void {
				if(!handler.asyncStack.remove(f)) {
					handler.results.add(stx.test.Assertation.AsyncError("event already executed",[]));
					return;
				}
				try {
					handler.bindHandler();
					f(e);
				}
				catch( e1 : * ){
					handler.results.add(stx.test.Assertation.AsyncError(e1,stx.test.TestHandler.exceptionStack(0)));
				}
			}
		}
		
		public function addAsync(f : Function,timeout : int = 250) : Function {
			this.asyncStack.add(f);
			var handler : stx.test.TestHandler = this;
			this.setTimeout(timeout);
			return function() : void {
				if(!handler.asyncStack.remove(f)) {
					handler.results.add(stx.test.Assertation.AsyncError("method already executed",[]));
					return;
				}
				try {
					handler.bindHandler();
					f();
				}
				catch( e : * ){
					handler.results.add(stx.test.Assertation.AsyncError(e,stx.test.TestHandler.exceptionStack(0)));
				}
			}
		}
		
		protected function unbindHandler() : void {
			stx.test.Assert.results = null;
			stx.test.Assert.createAsync = function(f : Function,t : * = null) : Function {
				return function() : void {
				}
			}
			stx.test.Assert.createEvent = function(f1 : Function,t1 : * = null) : Function {
				return function(e : *) : void {
				}
			}
		}
		
		protected function bindHandler() : void {
			stx.test.Assert.results = this.results;
			stx.test.Assert.createAsync = this.addAsync;
			stx.test.Assert.createEvent = this.addEvent;
		}
		
		public function setTimeout(timeout : int) : void {
			var newexpire : Number = haxe.Timer.stamp() + timeout / 1000;
			this.expireson = ((this.expireson == null)?newexpire:((newexpire > this.expireson)?newexpire:this.expireson));
		}
		
		public var expireson : *;
		protected function checkTested() : void {
			if(this.expireson == null || this.asyncStack.length == 0) this.tested();
			else if(haxe.Timer.stamp() > this.expireson) this.timeout();
			else haxe.Timer.delay(this.checkTested,10);
		}
		
		public function execute() : void {
			try {
				this.executeMethodByName(this.fixture.setup);
				try {
					this.executeMethod(this.fixture.method);
				}
				catch( e : * ){
					this.results.add(stx.test.Assertation.Error(e,stx.test.TestHandler.exceptionStack()));
				}
			}
			catch( e1 : * ){
				this.results.add(stx.test.Assertation.SetupError(e1,stx.test.TestHandler.exceptionStack()));
			}
			this.checkTested();
		}
		
		public var onComplete : stx.test.Dispatcher;
		public var onTimeout : stx.test.Dispatcher;
		public var onTested : stx.test.Dispatcher;
		protected var asyncStack : List;
		public var fixture : stx.test.TestFixture;
		public var results : List;
		static protected var POLLING_TIME : int = 10;
		static protected function exceptionStack(pops : int = 2) : Array {
			var stack : Array = haxe.Stack.exceptionStack();
			while(pops-- > 0) stack.pop();
			return stack;
		}
		
	}
}
