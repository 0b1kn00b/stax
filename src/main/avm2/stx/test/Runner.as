package stx.test {
	import stx.test.TestHandler;
	import stx.Functions2;
	import stx.Option;
	import stx.test.TestFixture;
	import stx.Options;
	import stx.Strings;
	import stx.Predicates;
	import stx.test.TestResult;
	import stx.test.Dispatcher;
	import flash.Boot;
	public class Runner {
		public function Runner() : void { if( !flash.Boot.skip_constructor ) {
			this.fixtures = new Array();
			this.onProgress = new stx.test.Dispatcher();
			this.onStart = new stx.test.Dispatcher();
			this.onComplete = new stx.test.Dispatcher();
			this.length = 0;
		}}
		
		protected function addAfterAll(test : *,totalTestsHolder : Array,f : Function) : Function {
			if(Reflect.field(test,"afterAll") != null) {
				var afterAll : Function = stx.test.Runner.findMethodByName(test,"afterAll");
				var runAfterAll : Function = function() : void {
					totalTestsHolder[0] = totalTestsHolder[0] - 1;
					if(totalTestsHolder[0] == 0) afterAll();
				}
				return function(name : String) : Function {
					var method : Function = f(name);
					return function() : void {
						try {
							method();
						}
						catch( e : * ){
							runAfterAll();
							throw e;
						}
						runAfterAll();
					}
				}
			}
			return f;
		}
		
		protected function addBeforeAll(test : *,f : Function) : Function {
			if(Reflect.field(test,"beforeAll") != null) {
				var beforeAll : Function = stx.test.Runner.findMethodByName(test,"beforeAll");
				var totalTests : int = 0;
				var runBeforeAll : Function = function() : void {
					++totalTests;
					if(totalTests == 1) beforeAll();
				}
				return function(name : String) : Function {
					var method : Function = f(name);
					return function() : void {
						runBeforeAll();
						method();
					}
				}
			}
			return f;
		}
		
		protected function testComplete(h : stx.test.TestHandler) : void {
			this.onProgress.dispatch({ result : stx.test.TestResult.ofHandler(h), done : this.pos, totals : this.length});
			this.runNext();
		}
		
		protected function runFixture(fixture : stx.test.TestFixture) : void {
			var handler : stx.test.TestHandler = new stx.test.TestHandler(fixture);
			handler.onComplete.add(this.testComplete);
			handler.execute();
		}
		
		protected function runNext() : void {
			if(this.fixtures.length > this.pos) this.runFixture(this.fixtures[this.pos++]);
			else this.onComplete.dispatch(this);
		}
		
		public function run() : stx.test.Runner {
			this.pos = 0;
			this.onStart.dispatch(this);
			this.runNext();
			return this;
		}
		
		protected var pos : int;
		protected function isMethod(test : *,name : String) : Boolean {
			try {
				return Reflect.isFunction(Reflect.field(test,name));
			}
			catch( e : * ){
				return false;
			}
			return false;
		}
		
		public function getFixture(index : int) : stx.test.TestFixture {
			return this.fixtures[index];
		}
		
		public function addFixtures(fixtures : *) : stx.test.Runner {
			{ var $it : * = fixtures.iterator();
			while( $it.hasNext() ) { var fixture : stx.test.TestFixture = $it.next();
			this.addFixture(fixture);
			}}
			return this;
		}
		
		public function addFixture(fixture : stx.test.TestFixture) : stx.test.Runner {
			this.fixtures.push(fixture);
			this.length++;
			return this;
		}
		
		public function add(test : *,prefix : String = "test",pattern : EReg = null) : stx.test.Runner {
			if(prefix==null) prefix="test";
			if(!Reflect.isObject(test)) throw "can't add a null object as a test case";
			var patternMatches : Function = function(field : String) : stx.Option {
				return stx.Options.map(stx.Options.toOption(pattern),function(p : EReg) : Boolean {
					return p.match(field);
				});
			}
			var prefixMatches : Function = function(field1 : String) : stx.Option {
				return stx.Option.Some(stx.Strings.startsWith(field1,prefix));
			}
			var fieldIsTest : Function = function(field2 : String) : Boolean {
				return stx.Options.getOrElseC(stx.Options.orElseC(patternMatches(field2),prefixMatches(field2)),false);
			}
			var fieldIsMethod : Function = (stx.Functions2.curry(this.isMethod))(test);
			var testMethods : Array = Prelude.SArrays.filter(Type.getInstanceFields(Type.getClass(test)),stx.Predicates.and(fieldIsTest,fieldIsMethod));
			var getMethodByName : Function = this.addBeforeAll(test,this.addAfterAll(test,[testMethods.length],(stx.Functions2.curry(stx.test.Runner.findMethodByName))(test)));
			var methodFixtures : Array = Prelude.SArrays.map(testMethods,function(field3 : String) : stx.test.TestFixture {
				return new stx.test.TestFixture(test,field3,getMethodByName(field3),"before","after");
			});
			this.addFixtures(methodFixtures);
			return this;
		}
		
		public function addAll(tests : *,prefix : String = "test",pattern : EReg = null) : stx.test.Runner {
			if(prefix==null) prefix="test";
			{ var $it : * = tests.iterator();
			while( $it.hasNext() ) { var test : * = $it.next();
			this.add(test,prefix,pattern);
			}}
			return this;
		}
		
		public var length : int;
		public var onComplete : stx.test.Dispatcher;
		public var onStart : stx.test.Dispatcher;
		public var onProgress : stx.test.Dispatcher;
		protected var fixtures : Array;
		static protected function findMethodByName(test : *,name : String) : Function {
			return function() : void {
				var method : * = Reflect.field(test,name);
				if(method != null) Reflect.callMethod(test,method,[]);
			}
		}
		
	}
}
