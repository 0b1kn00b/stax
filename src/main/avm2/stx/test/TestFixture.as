package stx.test {
	import stx.test.Dispatcher;
	import flash.Boot;
	public class TestFixture {
		public function TestFixture(target : * = null,methodName : String = null,method : Function = null,setup : String = null,teardown : String = null) : void { if( !flash.Boot.skip_constructor ) {
			this.target = target;
			this.methodName = methodName;
			this.method = method;
			this.setup = setup;
			this.teardown = teardown;
			this.onTested = new stx.test.Dispatcher();
			this.onTimeout = new stx.test.Dispatcher();
			this.onComplete = new stx.test.Dispatcher();
		}}
		
		protected function checkMethod(name : String,arg : String) : void {
			var field : * = Reflect.field(this.target,name);
			if(field == null) throw arg + " function " + name + " is not a field of target";
			if(!Reflect.isFunction(field)) throw arg + " function " + name + " is not a function";
		}
		
		public var onComplete : stx.test.Dispatcher;
		public var onTimeout : stx.test.Dispatcher;
		public var onTested : stx.test.Dispatcher;
		public var teardown : String;
		public var setup : String;
		public var method : Function;
		public var methodName : String;
		public var target : *;
	}
}
