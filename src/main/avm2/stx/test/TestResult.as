package stx.test {
	import stx.test.TestHandler;
	public class TestResult {
		public function TestResult() : void {
		}
		
		public var assertations : List;
		public var teardown : String;
		public var setup : String;
		public var method : String;
		public var cls : String;
		public var pack : String;
		static public function ofHandler(handler : stx.test.TestHandler) : stx.test.TestResult {
			var r : stx.test.TestResult = new stx.test.TestResult();
			var path : Array = Type.getClassName(Type.getClass(handler.fixture.target)).split(".");
			r.cls = path.pop();
			r.pack = path.join(".");
			r.method = handler.fixture.methodName;
			r.setup = handler.fixture.setup;
			r.teardown = handler.fixture.teardown;
			r.assertations = handler.results;
			return r;
		}
		
	}
}
